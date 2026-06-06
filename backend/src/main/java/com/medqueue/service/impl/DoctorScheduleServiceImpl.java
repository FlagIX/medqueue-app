package com.medqueue.service.impl;

import com.medqueue.dto.Result;
import com.medqueue.entity.DoctorSchedule;
import com.medqueue.mapper.DoctorScheduleMapper;
import com.medqueue.service.IDoctorScheduleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.util.List;

@Service
public class DoctorScheduleServiceImpl extends ServiceImpl<DoctorScheduleMapper, DoctorSchedule> implements IDoctorScheduleService {

    @Resource
    private DoctorScheduleMapper doctorScheduleMapper;

    @Override
    public Result querySchedules(Long doctorId, LocalDate date) {
        if (doctorId == null || date == null) {
            return Result.fail("参数错误");
        }
        List<DoctorSchedule> list = doctorScheduleMapper.querySchedules(doctorId, date);
        return Result.ok(list);
    }

    @Override
    public Result queryAvailableSchedules(Long doctorId, LocalDate beginDate, LocalDate endDate) {
        if (doctorId == null || beginDate == null || endDate == null) {
            return Result.fail("参数错误");
        }
        List<DoctorSchedule> list = doctorScheduleMapper.queryAvailableSchedules(doctorId, beginDate, endDate);
        return Result.ok(list);
    }
}
