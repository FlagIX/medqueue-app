package com.medqueue.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medqueue.entity.AppointmentItem;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface AppointmentItemMapper extends BaseMapper<AppointmentItem> {

    @Select("SELECT * FROM tb_appointment_item WHERE hospital_id = #{hospitalId}")
    List<AppointmentItem> queryItemsOfHospital(@Param("hospitalId") Long hospitalId);
}
