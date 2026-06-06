package com.medqueue.service.impl;

import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.medqueue.mapper.HospitalMapper;
import com.medqueue.service.IHospitalService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.util.concurrent.TimeUnit;

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
}
