package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentRecord;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IAppointmentRecordService extends IService<AppointmentRecord> {

    Result bookAppointment(Long scheduleId);

    Result createAppointmentRecord(Long scheduleId);
}
