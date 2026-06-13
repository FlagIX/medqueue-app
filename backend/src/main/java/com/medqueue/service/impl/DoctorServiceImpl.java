package com.medqueue.service.impl;

import cn.hutool.core.util.StrUtil;           // [Hutool] 字符串工具：isNotBlank()
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.medqueue.mapper.DoctorMapper;
import com.medqueue.service.IDoctorService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;          // [项目] 缓存工具类
import com.medqueue.utils.SystemConstants;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.CACHE_DOCTOR_KEY;
import static com.medqueue.utils.RedisConstants.CACHE_DOCTOR_TTL;

@Service
public class DoctorServiceImpl extends ServiceImpl<DoctorMapper, Doctor> implements IDoctorService {

    @Resource
    private CacheClient cacheClient;  // [项目] 缓存工具类（穿透防护）

    @Override
    public Result queryById(Long id) {
        // [项目] CacheClient.getWithPassThrough() = 多参数泛型方法
        //   参数：key, 返回类型, 主键ID, TTL, 单位, DB回调查询
        //   this::getById = [MP] 方法引用，相当于 id → getById(id)
        Doctor doctor = cacheClient
                .getWithPassThrough(CACHE_DOCTOR_KEY + id, Doctor.class, id, CACHE_DOCTOR_TTL, TimeUnit.MINUTES, this::getById);
        if (doctor == null) {
            throw new BizException(ErrorCode.DOCTOR_NOT_EXIST, "医生不存在");
        }
        return Result.ok(doctor);
    }

    @Override
    public Result queryByDepartment(Long departmentId, Integer current, Integer pageSize) {
        if (pageSize == null) pageSize = SystemConstants.DEFAULT_PAGE_SIZE;
        // [MP] query().eq().page(new Page<>()) = 链式查询 + 分页
        Page<Doctor> page = query()
                .eq("department_id", departmentId)
                .page(new Page<>(current, pageSize));
        return Result.ok(page);
    }

    @Override
    public Result queryByHospital(Long hospitalId, Integer current, Integer pageSize) {
        if (pageSize == null) pageSize = SystemConstants.DEFAULT_PAGE_SIZE;
        Page<Doctor> page = query()
                .eq("hospital_id", hospitalId)
                .page(new Page<>(current, pageSize));
        return Result.ok(page);
    }

    @Override
    public Result queryPage(Integer current, String name) {
        // [MP] .like(条件, 字段, 值) = 条件为 true 时拼接 LIKE '%值%'
        Page<Doctor> page = query()
                .like(StrUtil.isNotBlank(name), "name", name)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page);
    }
}
