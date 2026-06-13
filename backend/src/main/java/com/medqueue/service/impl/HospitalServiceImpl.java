package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.medqueue.mapper.HospitalMapper;
import com.medqueue.service.IHospitalService;
import cn.hutool.core.util.StrUtil;           // [Hutool] 字符串工具：isNotBlank()
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;          // [项目] 缓存工具类：穿透/击穿防护
import com.medqueue.utils.SystemConstants;
import org.springframework.data.geo.Circle;           // [Spring GEO] 圆形区域（中心点 + 半径）
import org.springframework.data.geo.Distance;          // [Spring GEO] 距离（数值 + 单位）
import org.springframework.data.geo.GeoResults;       // [Spring GEO] GEO 查询结果集
import org.springframework.data.geo.Metrics;          // [Spring GEO] 度量单位：KILOMETERS / MILES
import org.springframework.data.geo.Point;            // [Spring GEO] 地理坐标点 (x=经度, y=纬度)
import org.springframework.data.redis.connection.RedisGeoCommands;  // [Spring GEO] Redis GEO 命令封装
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

import static com.medqueue.utils.RedisConstants.*;

@Service
public class HospitalServiceImpl extends ServiceImpl<HospitalMapper, Hospital> implements IHospitalService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;     // [Spring] Redis 操作模板
    @Resource
    private CacheClient cacheClient;                    // [项目] 缓存工具类（穿透/击穿防护）

    // ===================== 缓存的三种策略（穿透/击穿/逻辑过期） =====================

    @Override
    public Result queryById(Long id) {
        // [项目] CacheClient.getWithPassThrough() = 缓存穿透防护方案
        //   原理：查不到的数据缓存空值 ""，防止恶意请求穿透到 DB
        //   this::getById = 方法引用，作为回调查 DB
        Hospital hospital = cacheClient
                .getWithPassThrough(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            throw new BizException(ErrorCode.HOSPITAL_NOT_EXIST, "医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result queryWithPassThrough(Long id) {
        return queryById(id);  // 与上方相同，穿透方案
    }

    @Override
    public Result queryWithMutex(Long id) {
        // [项目] 互斥锁方案（目前复用穿透方案，可扩展为 SETNX 锁）
        Hospital hospital = cacheClient
                .getWithPassThrough(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            throw new BizException(ErrorCode.HOSPITAL_NOT_EXIST, "医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result queryWithLogicalExpire(Long id) {
        // [项目] CacheClient.getWithLogicalExpire() = 缓存击穿防护方案
        //   原理：数据永不过期（Redis 不设 TTL），逻辑过期后异步线程重建缓存
        //   优点：高并发下，过期瞬间不会打崩 DB
        Hospital hospital = cacheClient
                .getWithLogicalExpire(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            throw new BizException(ErrorCode.HOSPITAL_NOT_EXIST, "医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result updateHospital(Hospital hospital) {
        Long id = hospital.getId();
        if (id == null) {
            throw new BizException(ErrorCode.HOSPITAL_ID_REQUIRED, "医院id不能为空");
        }
        updateById(hospital);  // [MP] UPDATE hospital
        // [Redis] 更新数据库后删除缓存，下次查询时重新加载（Cache-Aside 模式）
        stringRedisTemplate.delete(CACHE_HOSPITAL_KEY + id);
        return Result.ok();
    }

    public void saveHospital2Redis(Long id, Long expireSeconds) {
        // [MP] 查 DB
        Hospital hospital = getById(id);
        // [项目] 写入逻辑过期缓存（供 getWithLogicalExpire 使用）
        cacheClient.setWithLogicalExpire(CACHE_HOSPITAL_KEY + id, hospital, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public Result queryPage(Integer current, String name, Long departmentId) {
        // [MP] query() = ChainQuery 链式查询
        //   eq(条件, 字段, 值) = 条件为 true 时拼接 WHERE
        //   like(条件, 字段, 值) = 条件为 true 时拼接 LIKE
        //   page(new Page<>(current, size)) = 分页查询
        Page<Hospital> page = query()
                .eq(departmentId != null, "department_id", departmentId)
                .like(StrUtil.isNotBlank(name), "name", name)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page);
    }

    // ===================== Redis GEO 附近医院搜索 =====================
    @Override
    public Result queryNearby(Double x, Double y, Integer distance) {
        // 1. [Redis GEO] Circle = 圆形搜索范围：中心点(x,y) + 半径(distance, 单位)
        Circle circle = new Circle(new Point(x, y), new Distance(distance, Metrics.KILOMETERS));
        // [Redis] opsForGeo().radius(key, circle) = GEORADIUS key lon lat distance km
        //   返回：匹配的成员 + 距离
        GeoResults<RedisGeoCommands.GeoLocation<String>> results =
                stringRedisTemplate.opsForGeo().radius(HOSPITAL_GEO_KEY, circle);

        if (results.getContent().isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        // 2. [Java] 提取医院 ID 和距离（LinkedHashMap 保持插入顺序=距离升序）
        Map<Long, Double> distanceMap = new LinkedHashMap<>();
        results.getContent().stream()
                .sorted(Comparator.comparing(r -> r.getDistance().getValue()))  // 按距离升序排列
                .forEach(r -> {
                    // GEO 中 name 存的是医院 ID 的字符串形式
                    Long id = Long.valueOf(r.getContent().getName());
                    distanceMap.put(id, r.getDistance().getValue());
                });

        // 3. [MP] lambdaQuery().in(Hospital::getId, id列表).list()
        //   = SELECT * FROM hospital WHERE id IN (id1, id2, ...)
        List<Hospital> list = lambdaQuery().in(Hospital::getId, new ArrayList<>(distanceMap.keySet())).list();

        // 4. [Java] Stream 收集为 Map<id, Hospital>，然后按 GEO 距离顺序组装返回
        Map<Long, Hospital> hospitalMap = list.stream()
                .collect(Collectors.toMap(Hospital::getId, h -> h));
        List<Hospital> ordered = new ArrayList<>(distanceMap.size());
        distanceMap.forEach((id, dist) -> {
            Hospital h = hospitalMap.get(id);
            if (h != null) {
                h.setDistance(dist);  // 将 GEO 距离设置到实体中
                ordered.add(h);
            }
        });

        return Result.ok(ordered);
    }
}
