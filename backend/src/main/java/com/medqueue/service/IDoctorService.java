package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IDoctorService extends IService<Doctor> {

    Result queryById(Long id);

    Result queryByDepartment(Long departmentId, Integer current, Integer pageSize);

    Result queryByHospital(Long hospitalId, Integer current, Integer pageSize);

    Result queryPage(Integer current, String name);
}
