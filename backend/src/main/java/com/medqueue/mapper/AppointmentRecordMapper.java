package com.medqueue.mapper;

import com.medqueue.dto.AppointmentRecordDTO;
import com.medqueue.entity.AppointmentRecord;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AppointmentRecordMapper extends BaseMapper<AppointmentRecord> {

    List<AppointmentRecordDTO> queryUserRecords(@Param("userId") Long userId);

    AppointmentRecordDTO queryRecordDetail(@Param("id") Long id);

    int countByUserAndSchedule(@Param("userId") Long userId, @Param("scheduleId") Long scheduleId);
}
