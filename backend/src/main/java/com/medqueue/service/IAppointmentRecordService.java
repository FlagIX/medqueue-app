package com.medqueue.service;

import com.medqueue.dto.AppointmentBookingDTO;
import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentRecord;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IAppointmentRecordService extends IService<AppointmentRecord> {

    Result bookAppointment(AppointmentBookingDTO dto);

    // REFERENCE: 分布式锁+同步写库备选方案，实现已在 impl 中注释保留
    Result createAppointmentRecord(AppointmentBookingDTO dto);

    Result queryUserRecords(Long userId, Integer current, Integer pageSize, Integer status);

    Result cancelAppointment(Long id, Long userId);
}
