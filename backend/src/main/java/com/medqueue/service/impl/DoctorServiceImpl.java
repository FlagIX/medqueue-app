package com.medqueue.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.medqueue.mapper.DoctorMapper;
import com.medqueue.service.IDoctorService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.CacheClient;
import com.medqueue.utils.SystemConstants;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.CACHE_DOCTOR_KEY;
import static com.medqueue.utils.RedisConstants.CACHE_DOCTOR_TTL;

@Service
public class DoctorServiceImpl extends ServiceImpl<DoctorMapper, Doctor> implements IDoctorService {

    @Resource
    private CacheClient cacheClient;

    @Override
    public Result queryById(Long id) {
        Doctor doctor = cacheClient
                .getWithPassThrough(CACHE_DOCTOR_KEY + id, Doctor.class, id, CACHE_DOCTOR_TTL, TimeUnit.MINUTES, this::getById);
        if (doctor == null) {
            return Result.fail("医生不存在");
        }
        return Result.ok(doctor);
    }

    @Override
    public Result queryByDepartment(Long departmentId, Integer current, Integer pageSize) {
        if (pageSize == null) pageSize = SystemConstants.DEFAULT_PAGE_SIZE;
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
        Page<Doctor> page = query()
                .like(StrUtil.isNotBlank(name), "name", name)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page);
    }
}
