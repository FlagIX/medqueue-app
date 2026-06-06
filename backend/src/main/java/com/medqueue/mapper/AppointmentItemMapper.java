package com.medqueue.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.medqueue.entity.AppointmentItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface AppointmentItemMapper extends BaseMapper<AppointmentItem> {

    List<AppointmentItem> queryItemsOfHospital(@Param("hospitalId") Long hospitalId);
}
