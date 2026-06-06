package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.DoctorSchedule;
import com.baomidou.mybatisplus.extension.service.IService;

import java.time.LocalDate;

public interface IDoctorScheduleService extends IService<DoctorSchedule> {

    Result querySchedules(Long doctorId, LocalDate date);

    Result queryAvailableSchedules(Long doctorId, LocalDate beginDate, LocalDate endDate);
}
