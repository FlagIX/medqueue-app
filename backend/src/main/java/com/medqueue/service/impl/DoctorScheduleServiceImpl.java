package com.medqueue.service.impl;

import com.medqueue.entity.DoctorSchedule;
import com.medqueue.mapper.DoctorScheduleMapper;
import com.medqueue.service.IDoctorScheduleService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class DoctorScheduleServiceImpl extends ServiceImpl<DoctorScheduleMapper, DoctorSchedule> implements IDoctorScheduleService {

}
