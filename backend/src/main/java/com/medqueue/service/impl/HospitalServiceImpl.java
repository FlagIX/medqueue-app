package com.medqueue.service.impl;

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
import java.util.Collections;
import java.util.List;
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
            return Result.fail("医院不存在");
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
            return Result.fail("医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result queryWithLogicalExpire(Long id) {
        Hospital hospital = cacheClient
                .getWithLogicalExpire(CACHE_HOSPITAL_KEY + id, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            return Result.fail("医院不存在");
        }
        return Result.ok(hospital);
    }

    @Override
    public Result updateHospital(Hospital hospital) {
        Long id = hospital.getId();
        if (id == null) {
            return Result.fail("医院id不能为空");
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
        Circle circle = new Circle(new Point(x, y), new Distance(distance, Metrics.KILOMETERS));
        GeoResults<RedisGeoCommands.GeoLocation<String>> results =
                stringRedisTemplate.opsForGeo().radius(HOSPITAL_GEO_KEY, circle);
        List<Long> ids = results.getContent().stream()
                .map(r -> Long.valueOf(r.getContent().getName()))
                .collect(Collectors.toList());
        if (ids.isEmpty()) {
            return Result.ok(Collections.emptyList());
        }
        List<Hospital> list = lambdaQuery().in(Hospital::getId, ids).list();
        return Result.ok(list);
    }
}
