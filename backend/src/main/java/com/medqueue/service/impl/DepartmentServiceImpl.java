package com.medqueue.service.impl;

import cn.hutool.json.JSONUtil;               // [Hutool] JSON工具：toBean()/toJsonStr()
import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.Department;
import com.medqueue.mapper.DepartmentMapper;
import com.medqueue.service.IDepartmentService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.RedisConstants;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.CACHE_DEPARTMENT_KEY;
import static com.medqueue.utils.RedisConstants.CACHE_DEPARTMENT_TTL;
import static com.medqueue.utils.RedisConstants.CACHE_NULL_TTL;

@Service
public class DepartmentServiceImpl extends ServiceImpl<DepartmentMapper, Department> implements IDepartmentService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;  // [Spring] Redis 操作模板

    // ===================== Redis List 缓存科室列表 =====================
    @Override
    public Result queryListWithCache() {
        String key = CACHE_DEPARTMENT_KEY;  // "cache:department:type"

        // 1. [Redis] opsForList().range(key, 0, -1) = LRANGE key 0 -1（取全部元素）
        List<String> cacheList = stringRedisTemplate.opsForList().range(key, 0, -1);
        if (cacheList != null) {
            // 缓存命中
            if (cacheList.isEmpty() || "_".equals(cacheList.get(0))) {
                // 空值缓存（"_" = 标记空缓存，防穿透）
                throw new BizException(ErrorCode.DEPARTMENT_NOT_EXIST, "科室不存在");
            }
            // [Hutool] JSONUtil.toBean(json, Department.class) = JSON → 对象
            List<Department> list = new ArrayList<>(cacheList.size());
            for (String json : cacheList) {
                list.add(JSONUtil.toBean(json, Department.class));
            }
            return Result.ok(list);
        }

        // 2. 缓存未命中，查数据库
        // [MP] query().orderByAsc("sort").list() = SELECT * FROM department ORDER BY sort ASC
        List<Department> dbList = query().orderByAsc("sort").list();
        if (dbList == null || dbList.isEmpty()) {
            // 数据库也没有 → 缓存空值防穿透
            // [Redis] rightPushAll(key, "_") = RPUSH key _ （插入一个空标记）
            stringRedisTemplate.opsForList().rightPushAll(key, "_");
            // [Redis] expire(key, ttl) = 设置短暂过期时间
            stringRedisTemplate.expire(key, CACHE_NULL_TTL, TimeUnit.MINUTES);
            throw new BizException(ErrorCode.DEPARTMENT_NOT_EXIST, "科室不存在");
        }

        // 3. 数据库有数据 → 写入 Redis List
        List<String> jsonList = new ArrayList<>(dbList.size());
        for (Department department : dbList) {
            // [Hutool] JSONUtil.toJsonStr(obj) = Java 对象 → JSON 字符串
            jsonList.add(JSONUtil.toJsonStr(department));
        }
        // [Redis] rightPushAll(key, list) = RPUSH key val1 val2 val3 ...（批量右推）
        stringRedisTemplate.opsForList().rightPushAll(key, jsonList);
        // [Java] 随机抖动：CACHE_DEPARTMENT_TTL * [0.9, 1.1)，防缓存雪崩
        long ttlWithJitter = (long) (CACHE_DEPARTMENT_TTL * (0.9 + 0.2 * Math.random()));
        stringRedisTemplate.expire(key, ttlWithJitter, TimeUnit.MINUTES);

        return Result.ok(dbList);
    }
}
