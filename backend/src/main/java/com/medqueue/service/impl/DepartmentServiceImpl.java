package com.medqueue.service.impl;

import cn.hutool.json.JSONUtil;
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
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result queryListWithCache() {
        String key = CACHE_DEPARTMENT_KEY;
        List<String> cacheList = stringRedisTemplate.opsForList().range(key, 0, -1);
        if (cacheList != null) {
            if (cacheList.isEmpty() || "_".equals(cacheList.get(0))) {
                throw new BizException(ErrorCode.DEPARTMENT_NOT_EXIST, "科室不存在");
            }
            List<Department> list = new ArrayList<>(cacheList.size());
            for (String json : cacheList) {
                list.add(JSONUtil.toBean(json, Department.class));
            }
            return Result.ok(list);
        }
        List<Department> dbList = query().orderByAsc("sort").list();
        if (dbList == null || dbList.isEmpty()) {
            stringRedisTemplate.opsForList().rightPushAll(key, "_");
            stringRedisTemplate.expire(key, CACHE_NULL_TTL, TimeUnit.MINUTES);
            throw new BizException(ErrorCode.DEPARTMENT_NOT_EXIST, "科室不存在");
        }
        List<String> jsonList = new ArrayList<>(dbList.size());
        for (Department department : dbList) {
            jsonList.add(JSONUtil.toJsonStr(department));
        }
        stringRedisTemplate.opsForList().rightPushAll(key, jsonList);
        long ttlWithJitter = (long) (CACHE_DEPARTMENT_TTL * (0.9 + 0.2 * Math.random()));
        stringRedisTemplate.expire(key, ttlWithJitter, TimeUnit.MINUTES);
        return Result.ok(dbList);
    }
}
