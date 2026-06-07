package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IHospitalService extends IService<Hospital> {

    Result queryById(Long id);

    Result queryWithPassThrough(Long id);

    Result queryWithMutex(Long id);

    Result queryWithLogicalExpire(Long id);

    Result updateHospital(Hospital hospital);

    Result queryPage(Integer current, String name);

    Result queryNearby(Double x, Double y, Integer distance);
}
