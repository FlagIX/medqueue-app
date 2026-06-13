package com.medqueue.utils;

import cn.hutool.core.util.BooleanUtil;     // [Hutool] 布尔工具：isTrue(Boolean) 安全判断
import cn.hutool.core.util.StrUtil;        // [Hutool] 字符串工具：isBlank/isNotBlank
import cn.hutool.json.JSONUtil;             // [Hutool] JSON工具：toJsonStr(obj)/toBean(json, class)
import lombok.extern.slf4j.Slf4j;           // [Lombok] 自动生成 log 字段
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;         // [Java] 函数式接口：R apply(T t)，用于回调查询数据库

@Slf4j                                    // [Lombok] 自动生成 log 字段
@Component                                // [Spring] 声明为 Spring Bean，单例
public class CacheClient {

    // [Spring] 构造器注入（无 @Autowired，Spring 自动识别单个构造器）
    //   private final = 依赖不可变，推荐的最佳实践
    private final StringRedisTemplate stringRedisTemplate;

    // [Java] Executors.newFixedThreadPool(10) = 固定10线程的线程池
    //   用于异步重建缓存（逻辑过期方案）
    private static final ExecutorService CACHE_REBUILD_EXECUTOR = Executors.newFixedThreadPool(10);

    // [Spring] 构造器注入：Spring 自动传入 StringRedisTemplate
    public CacheClient(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    // ===================== 缓存写入策略 =====================

    // 方法1：设置带 TTL 的缓存（添加随机抖动防雪崩）
    // [Redis] opsForValue().set(key, value, ttl, unit) = SET key value EX ttl
    public void set(String key, Object value, Long time, TimeUnit unit) {
        // [Java] Math.random() = [0,1) 随机浮点数
        //   ttlWithJitter = time * [0.9, 1.1)，同一时刻过期的 key 错开
        long ttlWithJitter = (long) (time * (0.9 + 0.2 * Math.random()));
        // [Hutool] JSONUtil.toJsonStr(value) = 对象 → JSON 字符串
        stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(value), ttlWithJitter, unit);
    }

    // 方法2：设置带逻辑过期时间的缓存
    //   ⭐ 解决缓存击穿：数据本身不过期（Redis 永不过期），内部维护过期时间
    //   优点：缓存永不主动删除，过期后由后台线程异步更新
    public void setWithLogicalExpire(String key, Object value, Long time, TimeUnit unit) {
        // [项目] RedisData = 自定义包装类：{data, expireTime}
        RedisData redisData = new RedisData();
        redisData.setData(value);
        // [Java] LocalDateTime.now().plusSeconds(...) = 当前时间 + 逻辑过期时长
        redisData.setExpireTime(LocalDateTime.now().plusSeconds(unit.toSeconds(time)));
        // [Redis] 写入 JSON，不设 Redis TTL（永不过期）
        stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(redisData));
    }

    // ===================== 缓存读取策略 =====================

    // 方法3：查询缓存，利用缓存空值解决缓存穿透
    //   ⭐ 缓存穿透：查不到的数据每次都穿透到 DB
    //   解决：查不到也缓存空值 ""，下次直接返回 null
    // [Java] 泛型方法 <R, ID>：R=返回类型, ID=主键类型
    //   Function<ID, R> = 函数式接口：传入 ID，返回 R，即 dbFallback 回调
    public <R, ID> R getWithPassThrough(String key, Class<R> type, ID id, Long time, TimeUnit unit,
                                        Function<ID, R> dbFallback) {
        // 1. 从 Redis 查询缓存
        // [Redis] opsForValue().get(key) = GET key，返回 JSON 字符串或 null
        String json = stringRedisTemplate.opsForValue().get(key);
        // 2. 缓存命中（非空字符串）
        // [Hutool] StrUtil.isNotBlank(str) = !(null || "" || 全是空白)
        if (StrUtil.isNotBlank(json)) {
            // [Hutool] JSONUtil.toBean(json, type) = JSON 字符串 → Java 对象
            return JSONUtil.toBean(json, type);
        }
        // 判断是否是缓存空值（"" 但不是 null）
        if (json != null) {
            return null;  // 缓存了空值 → 直接返回 null，不查 DB
        }
        // 3. 缓存不存在，查数据库
        // [Java] Function.apply(id) = 执行回调，即调用传入的 this::getById
        R result = dbFallback.apply(id);
        // 4. 数据库也不存在 → 缓存空值防穿透
        if (result == null) {
            // [Redis] 缓存空字符串，设置过期时间
            stringRedisTemplate.opsForValue().set(key, "", time, unit);
            return null;
        }
        // 5. 数据库存在 → 写入缓存
        this.set(key, result, time, unit);
        return result;
    }

    // 方法4：查询缓存，利用逻辑过期解决缓存击穿
    //   ⭐ 缓存击穿：热点 key 过期瞬间，大量请求同时打到 DB
    //   解决：数据永不过期，过期后由后台线程异步重建缓存
    //   [Java] 泛型方法，Function 回调用于查 DB
    public <R, ID> R getWithLogicalExpire(String key, Class<R> type, ID id, Long time, TimeUnit unit,
                                          Function<ID, R> dbFallback) {
        // 1. 从 Redis 查询缓存
        String json = stringRedisTemplate.opsForValue().get(key);
        // 2. 缓存不存在
        if (StrUtil.isBlank(json)) {
            return null;
        }
        // 3. 命中，反序列化
        //   [Hutool] JSONUtil.toBean(json, RedisData.class) → 先拿到包装对象
        RedisData redisData = JSONUtil.toBean(json, RedisData.class);
        //   [Hutool] redisData.getData() 是 Object，再转成目标类型 R
        R result = JSONUtil.toBean(JSONUtil.toJsonStr(redisData.getData()), type);
        LocalDateTime expireTime = redisData.getExpireTime();
        // 4. 判断逻辑是否过期
        if (expireTime.isAfter(LocalDateTime.now())) {
            return result;  // 未过期，直接返回
        }
        // 5. 已过期 → 尝试获取分布式锁（互斥锁），后台重建缓存
        String lockKey = "lock:" + key;
        if (trylock(lockKey)) {  // [Redis] SETNX 成功
            // [Java] 提交到线程池异步重建，不阻塞当前线程
            CACHE_REBUILD_EXECUTOR.submit(() -> {
                try {
                    R newResult = dbFallback.apply(id);  // 查 DB
                    this.setWithLogicalExpire(key, newResult, time, unit);  // 写缓存
                } finally {
                    unlock(lockKey);  // 释放锁
                }
            });
        }
        // 6. 拿到锁的线程去重建缓存，没拿到的直接返回过期数据
        //    牺牲短暂的一致性，保证高可用
        return result;
    }

    // ===================== 分布式锁工具 =====================

    // 获取锁（互斥锁）
    // [Redis] setIfAbsent(key, value, ttl, unit) = SET key value NX EX ttl
    //   NX = 不存在才设置（即 SETNX 命令）
    private boolean trylock(String key) {
        Boolean flag = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", 10, TimeUnit.SECONDS);
        // [Hutool] BooleanUtil.isTrue(Boolean) = 安全判断，避免 Boolean 拆箱空指针
        return BooleanUtil.isTrue(flag);
    }

    // 释放锁
    // [Redis] delete(key) = DEL key
    private void unlock(String key) {
        stringRedisTemplate.delete(key);
    }
}
