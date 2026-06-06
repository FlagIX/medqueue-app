package com.medqueue.mapper;

import com.medqueue.entity.DoctorSchedule;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDate;
import java.util.List;

public interface DoctorScheduleMapper extends BaseMapper<DoctorSchedule> {

    List<DoctorSchedule> querySchedules(@Param("doctorId") Long doctorId, @Param("date") LocalDate date);

    List<DoctorSchedule> queryAvailableSchedules(@Param("doctorId") Long doctorId,
                                                  @Param("beginDate") LocalDate beginDate,
                                                  @Param("endDate") LocalDate endDate);
}
