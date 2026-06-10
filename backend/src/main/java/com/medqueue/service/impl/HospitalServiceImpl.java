package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.medqueue.mapper.HospitalMapper;
import com.medqueue.service.IHospitalService;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;
import com.medqueue.utils.SystemConstants;
import org.springframework.data.geo.Circle;
import org.springframework.data.geo.Distance;
import org.springframework.data.geo.GeoResults;
import org.springframework.data.geo.Metrics;
import org.springframework.data.geo.Point;
import org.springframework.data.redis.connection.RedisGeoCommands;
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
    private StringRedisTemplate stringRedisTemplate;
    @Resource
    private CacheClient cacheClient;

    @Override
    public Result queryById(Long id) {
        Hospital hospital = cacheClient
                .getWithPassThrough(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            throw new BizException(ErrorCode.HOSPITAL_NOT_EXIST, "医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result queryWithPassThrough(Long id) {
        return queryById(id);
    }

    @Override
    public Result queryWithMutex(Long id) {
        Hospital hospital = cacheClient
                .getWithPassThrough(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            throw new BizException(ErrorCode.HOSPITAL_NOT_EXIST, "医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result queryWithLogicalExpire(Long id) {
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
        updateById(hospital);
        stringRedisTemplate.delete(CACHE_HOSPITAL_KEY + id);
        return Result.ok();
    }

    public void saveHospital2Redis(Long id, Long expireSeconds) {
        Hospital hospital = getById(id);
        cacheClient.setWithLogicalExpire(CACHE_HOSPITAL_KEY + id, hospital, expireSeconds, TimeUnit.SECONDS);
    }

    @Override
    public Result queryPage(Integer current, String name, Long departmentId) {
        Page<Hospital> page = query()
                .eq(departmentId != null, "department_id", departmentId)
                .like(StrUtil.isNotBlank(name), "name", name)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page);
    }

    @Override
    public Result queryNearby(Double x, Double y, Integer distance) {
        // 1. 查询指定范围内的医院 GEO 信息（含距离）
        Circle circle = new Circle(new Point(x, y), new Distance(distance, Metrics.KILOMETERS));
        GeoResults<RedisGeoCommands.GeoLocation<String>> results =
                stringRedisTemplate.opsForGeo().radius(HOSPITAL_GEO_KEY, circle);

        if (results.getContent().isEmpty()) {
            return Result.ok(Collections.emptyList());
        }

        // 2. 提取医院 ID 和对应的距离（按距离升序）
        Map<Long, Double> distanceMap = new LinkedHashMap<>();
        results.getContent().stream()
                .sorted(Comparator.comparing(r -> r.getDistance().getValue()))
                .forEach(r -> {
                    Long id = Long.valueOf(r.getContent().getName());
                    distanceMap.put(id, r.getDistance().getValue());
                });

        // 3. 根据 ID 查询医院详情（保持距离排序）
        List<Hospital> list = lambdaQuery().in(Hospital::getId, new ArrayList<>(distanceMap.keySet())).list();

        // 4. 填充 distance 并按距离排序
        Map<Long, Hospital> hospitalMap = list.stream()
                .collect(Collectors.toMap(Hospital::getId, h -> h));
        List<Hospital> ordered = new ArrayList<>(distanceMap.size());
        distanceMap.forEach((id, dist) -> {
            Hospital h = hospitalMap.get(id);
            if (h != null) {
                h.setDistance(dist);
                ordered.add(h);
            }
        });

        return Result.ok(ordered);
    }
}
