package com.medqueue.utils;

import cn.hutool.core.util.BooleanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;

@Slf4j
@Component
public class CacheClient {

    private final StringRedisTemplate stringRedisTemplate;

    private static final ExecutorService CACHE_REBUILD_EXECUTOR = Executors.newFixedThreadPool(10);

    public CacheClient(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    // 方法1：设置带TTL的缓存（添加随机抖动防雪崩）
    public void set(String key, Object value, Long time, TimeUnit unit) {
        long ttlWithJitter = (long) (time * (0.9 + 0.2 * Math.random()));
        stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(value), ttlWithJitter, unit);
    }

    // 方法2：设置带逻辑过期时间的缓存
    public void setWithLogicalExpire(String key, Object value, Long time, TimeUnit unit) {
        RedisData redisData = new RedisData();
        redisData.setData(value);
        redisData.setExpireTime(LocalDateTime.now().plusSeconds(unit.toSeconds(time)));
        stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(redisData));
    }

    // 方法3：查询缓存，利用缓存空值解决缓存穿透
    public <R, ID> R getWithPassThrough(String key, Class<R> type, ID id, Long time, TimeUnit unit,
                                        Function<ID, R> dbFallback) {
        // 1.从redis查询缓存
        String json = stringRedisTemplate.opsForValue().get(key);
        // 2.判断是否存在
        if (StrUtil.isNotBlank(json)) {
            return JSONUtil.toBean(json, type);
        }
        // 判断是否是空值
        if (json != null) {
            return null;
        }
        // 3.缓存不存在，查询数据库
        R result = dbFallback.apply(id);
        // 4.数据库也不存在，缓存空值
        if (result == null) {
            stringRedisTemplate.opsForValue().set(key, "", time, unit);
            return null;
        }
        // 5.数据库存在，写入缓存
        this.set(key, result, time, unit);
        return result;
    }

    // 方法4：查询缓存，利用逻辑过期解决缓存击穿
    public <R, ID> R getWithLogicalExpire(String key, Class<R> type, ID id, Long time, TimeUnit unit,
                                          Function<ID, R> dbFallback) {
        // 1.从redis查询缓存
        String json = stringRedisTemplate.opsForValue().get(key);
        // 2.判断是否存在
        if (StrUtil.isBlank(json)) {
            return null;
        }
        // 3.命中，反序列化
        RedisData redisData = JSONUtil.toBean(json, RedisData.class);
        R result = JSONUtil.toBean(JSONUtil.toJsonStr(redisData.getData()), type);
        LocalDateTime expireTime = redisData.getExpireTime();
        // 4.判断是否过期
        if (expireTime.isAfter(LocalDateTime.now())) {
            return result;
        }
        // 5.已过期，尝试获取锁重建缓存
        String lockKey = "lock:" + key;
        if (trylock(lockKey)) {
            CACHE_REBUILD_EXECUTOR.submit(() -> {
                try {
                    R newResult = dbFallback.apply(id);
                    this.setWithLogicalExpire(key, newResult, time, unit);
                } finally {
                    unlock(lockKey);
                }
            });
        }
        // 6.返回过期数据
        return result;
    }

    private boolean trylock(String key) {
        Boolean flag = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", 10, TimeUnit.SECONDS);
        return BooleanUtil.isTrue(flag);
    }

    private void unlock(String key) {
        stringRedisTemplate.delete(key);
    }
}
