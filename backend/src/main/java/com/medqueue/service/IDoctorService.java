package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IDoctorService extends IService<Doctor> {

    Result queryById(Long id);

    Result queryByDepartment(Long departmentId, Integer current);

    Result queryByHospital(Long hospitalId, Integer current);

    Result queryPage(Integer current, String name);
}
