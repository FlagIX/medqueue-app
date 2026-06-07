package com.medqueue.service;

import com.medqueue.dto.AppointmentBookingDTO;
import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentRecord;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IAppointmentRecordService extends IService<AppointmentRecord> {

    Result bookAppointment(AppointmentBookingDTO dto);

    Result createAppointmentRecord(AppointmentBookingDTO dto);

    Result queryUserRecords(Long userId);

    Result cancelAppointment(Long id, Long userId);
}
