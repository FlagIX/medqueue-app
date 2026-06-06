package com.medqueue.service.impl;

import cn.hutool.core.util.BooleanUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.medqueue.dto.Result;
import com.medqueue.entity.Shop;
import com.medqueue.mapper.ShopMapper;
import com.medqueue.service.IShopService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;
import com.medqueue.utils.RedisConstants;
import com.medqueue.utils.RedisData;
import io.netty.util.internal.StringUtil;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.time.LocalDateTime;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.*;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author 虎哥
 * @since 2021-12-22
 */
@Service
public class ShopServiceImpl extends ServiceImpl<ShopMapper, Shop> implements IShopService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;
    @Resource
    private CacheClient cacheClient;

    @Override
    public Result queryById(Long id) {
        //缓存穿透
        Shop shop = cacheClient
                .getWithPassThrough(CACHE_SHOP_KEY, Shop.class, id, CACHE_SHOP_TTL, TimeUnit.MINUTES, this::getById);

        //用互斥锁解决缓存击穿
        //Shop shop = queryWithMutex(id);

        //用逻辑过期解决缓存击穿
        //Shop shop = queryWithLogicalExpire(id);
        if (shop == null) {
            return Result.fail("店铺不存在");
        }
        //7.返回
        return Result.ok(shop);
    }

    // 线程池，用于异步重建缓存
    private static final ExecutorService CACHE_REBUILD_EXECUTOR = Executors.newFixedThreadPool(10);

    public Shop queryWithLogicalExpire(Long id) {
        String key = CACHE_SHOP_KEY + id;
        // 1.从redis查询商铺缓存
        String shopJSON = stringRedisTemplate.opsForValue().get(key);
        // 2.判断是否存在
        if (StrUtil.isBlank(shopJSON)) {
            // 未命中，直接返回null（逻辑过期方案要求缓存预热，不存在说明数据未预热）
            return null;
        }
        // 3.命中，反序列化为RedisData
        RedisData redisData = JSONUtil.toBean(shopJSON, RedisData.class);
        Shop shop = JSONUtil.toBean(JSONUtil.toJsonStr(redisData.getData()), Shop.class);
        LocalDateTime expireTime = redisData.getExpireTime();
        // 4.判断是否逻辑过期
        if (expireTime.isAfter(LocalDateTime.now())) {
            // 5.未过期，直接返回缓存数据
            return shop;
        }
        // 6.已过期，需要缓存重建
        String lockKey = LOCK_SHOP_KEY + id;
        boolean isLock = trylock(lockKey);
        if (isLock) {
            // 获取锁成功，开启异步线程重建缓存
            CACHE_REBUILD_EXECUTOR.submit(() -> {
                try {
                    saveShop2Redis(id, 30L * 60);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                } finally {
                    unlock(lockKey);
                }
            });
        }
        // 7.无论是否获取锁，都返回过期数据（保证高可用）
        return shop;
    }

    public Shop queryWithMutex(Long id) {
        String key = CACHE_SHOP_KEY + id;
        //1.从redis查询商铺缓存
        String shopJSON = stringRedisTemplate.opsForValue().get(key);
        //2,判断是否存在
        if (StrUtil.isNotBlank(shopJSON)) {
            //3.存在，直接返回
            Shop shop = JSONUtil.toBean(shopJSON, Shop.class);
            return shop;
        }
        //判断是否是空值
        if (shopJSON != null) {
            return null;
        }
        //实现缓存重建
        //获取互斥锁
        String lockKey = LOCK_SHOP_KEY + id;
        Shop shop = null;
        try {
            int maxRetry = 20;
            while (!trylock(lockKey)) {
                if (--maxRetry <= 0) {
                    return null;
                }
                Thread.sleep(50);
            }
            //二次检查缓存，避免重建期间其他线程已经写入
            shopJSON = stringRedisTemplate.opsForValue().get(key);
            if (StrUtil.isNotBlank(shopJSON)) {
                return JSONUtil.toBean(shopJSON, Shop.class);
            }
            if (shopJSON != null) {
                return null;
            }
            //成功，根据id查询数据库
            shop = getById(id);
            //5.不存在，返回错误
            if (shop == null) {
                //将空值写入redis
                stringRedisTemplate.opsForValue().set(key, "", CACHE_NULL_TTL, TimeUnit.MINUTES);
                //返回错误信息
                return null;
            }
            //6.存在，写入redis
            stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(shop), CACHE_SHOP_TTL, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        } finally {
            //释放锁
            unlock(lockKey);
        }
        //7.返回
        return shop;
    }

    public Shop queryWithPassThrough(Long id) {
        String key = CACHE_SHOP_KEY + id;
        //1.从redis查询商铺缓存
        String shopJSON = stringRedisTemplate.opsForValue().get(key);
        //2,判断是否存在
        if (StrUtil.isNotBlank(shopJSON)) {
            //3.存在，直接返回
            Shop shop = JSONUtil.toBean(shopJSON, Shop.class);
            return shop;
        }
        //判断是否是空值
        if (shopJSON != null) {
            return null;
        }
        //4,不存在，根据id查询数据库
        Shop shop = getById(id);
        //5.不存在，返回错误
        if (shop == null) {
            //将空值写入redis
            stringRedisTemplate.opsForValue().set(key, "", CACHE_NULL_TTL, TimeUnit.MINUTES);
            //返回错误信息
            return null;
        }
        //6.存在，写入redis
        stringRedisTemplate.opsForValue().set(key, JSONUtil.toJsonStr(shop), CACHE_SHOP_TTL, TimeUnit.MINUTES);
        //7.返回
        return shop;
    }

    @Override
    public Result updateShop(Shop shop) {
        Long id = shop.getId();
        if (id == null) {
            return Result.fail("店铺id不能为空");
        }
        //修改数据库
        updateById(shop);
        //删除缓存
        stringRedisTemplate.delete(CACHE_SHOP_KEY + id);
        return Result.ok();
    }

    private void saveShop2Redis(Long id, Long expireSeconds) {
        //查询店铺数据
        Shop shop = getById(id);
        //封装逻辑过期时间
        RedisData redisData = new RedisData();
        redisData.setData(shop);
        redisData.setExpireTime(LocalDateTime.now().plusSeconds(expireSeconds));
        //写入redis
        stringRedisTemplate.opsForValue().set(CACHE_SHOP_KEY + id, JSONUtil.toJsonStr(redisData));
    }

    private boolean trylock(String key) {
        Boolean flag = stringRedisTemplate.opsForValue().setIfAbsent(key, "1", 10, TimeUnit.SECONDS);
        return BooleanUtil.isTrue(flag);
    }

    private void unlock(String key) {
        stringRedisTemplate.delete(key);
    }
}
