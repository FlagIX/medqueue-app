package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentItem;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IAppointmentItemService extends IService<AppointmentItem> {

    Result queryItemsOfHospital(Long hospitalId);
}
