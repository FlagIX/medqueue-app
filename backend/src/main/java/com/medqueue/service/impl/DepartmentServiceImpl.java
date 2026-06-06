package com.medqueue.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
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

import static com.medqueue.utils.RedisConstants.CACHE_DEPARTMENT_KEY;

@Service
public class DepartmentServiceImpl extends ServiceImpl<DepartmentMapper, Department> implements IDepartmentService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result queryTypeListWithCache() {
        String key = CACHE_DEPARTMENT_KEY;
        List<String> typeJsonList = stringRedisTemplate.opsForList().range(key, 0, -1);
        if (typeJsonList != null && !typeJsonList.isEmpty()) {
            List<Department> typeList = new ArrayList<>();
            for (String JSON : typeJsonList) {
                typeList.add(JSONUtil.toBean(JSON, Department.class));
            }
            return Result.ok(typeList);
        }
        List<Department> typeList = query().orderByAsc("sort").list();
        if (typeList == null || typeList.isEmpty()) {
            return Result.fail("科室类型不存在");
        }
        List<String> jsonList = new ArrayList<>();
        for (Department department : typeList) {
            jsonList.add(JSONUtil.toJsonStr(department));
        }
        stringRedisTemplate.opsForList().rightPushAll(key, jsonList);
        return Result.ok(typeList);
    }
}
