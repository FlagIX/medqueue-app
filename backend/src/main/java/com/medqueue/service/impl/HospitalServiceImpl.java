package com.medqueue.service.impl;

import cn.hutool.core.util.BooleanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.medqueue.mapper.HospitalMapper;
import com.medqueue.service.IHospitalService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;
import com.medqueue.utils.RedisConstants;
import com.medqueue.utils.RedisData;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.time.LocalDateTime;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
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
                .getWithPassThrough(CACHE_HOSPITAL_KEY, Hospital.class, id, CACHE_HOSPITAL_TTL, TimeUnit.MINUTES, this::getById);
        if (hospital == null) {
            return Result.fail("医院不存在");
        }
        return Result.ok(hospital);
    }

    private static final ExecutorService CACHE_REBUILD_EXECUTOR = Executors.newFixedThreadPool(10);

    public Hospital queryWithLogicalExpire(Long id) {
        String key = CACHE_HOSPITAL_KEY + id;
        String hospitalJSON = stringRedisTemplate.opsForValue().get(key);
        if (StrUtil.isBlank(hospitalJSON)) {
            return null;
        }
        RedisData redisData = JSONUtil.toBean(hospitalJSON, RedisData.class);
        Hospital hospital = JSONUtil.toBean(JSONUtil.toJsonStr(redisData.getData()), Hospital.class);
        LocalDateTime expireTime = redisData.getExpireTime();
        if (expireTime.isAfter(LocalDateTime.now())) {
            return hospital;
        }
        String lockKey = LOCK_HOSPITAL_KEY + id;
        boolean isLock = trylock(lockKey);
        if (isLock) {
            CACHE_REBUILD_EXECUTOR.submit(() -> {
                try {
                    saveHospital2Redis(id, 30L * 60);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                } finally {
                    unlock(lockKey);
                }
            });
        }
        return hospital;
    }

    public Hospital queryWithMutex(Long id) {
        String key = CACHE_HOSPITAL_KEY + id;
        String hospitalJSON = stringRedisTemplate.opsForValue().get(key);
        if (StrUtil.isNotBlank(hospitalJSON)) {
            return JSONUtil.toBean(hospitalJSON, Hospital.class);
        }
        if (hospitalJSON != null) {
            return null;
        }
        String lockKey = LOCK_HOSPITAL_KEY + id;
        Hospital hospital = null;
        try {
            int maxRetry = 20;
            while (!trylock(lockKey)) {
                if (--maxRetry <= 0) {
                    return null;
                }
                Thread.sleep(50);
            }
            hospitalJSON = stringRedisTemplate.opsForValue().get(key);
            if (StrUtil.isNotBlank(hospitalJSON)) {
                return JSONUtil.toBean(hospitalJSON, Hospital.class);
            }
            if (hospitalJSON != null) {
                return null;
            }
            hospital = getById(id);
            if (hospital == null) {
                stringRedisTemplate.opsForValue().set(key, "", CACHE_NULL_TTL, TimeUnit.MINUTES);
                return null;
            }
            stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(hospital), CACHE_HOSPITAL_TTL, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } finally {
            unlock(lockKey);
        }
        return hospital;
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

    private void saveHospital2Redis(Long id, Long expireSeconds) {
        Hospital hospital = getById(id);
        RedisData redisData = new RedisData();
        redisData.setData(hospital);
        redisData.setExpireTime(LocalDateTime.now().plusSeconds(expireSeconds));
        stringRedisTemplate.opsForValue().set(CACHE_HOSPITAL_KEY + id, JSONUtil.toJsonStr(redisData));
    }

    private boolean trylock(String key) {
        Boolean flag = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", 10, TimeUnit.SECONDS);
        return BooleanUtil.isTrue(flag);
    }

    private void unlock(String key) {
        stringRedisTemplate.delete(key);
    }
}
