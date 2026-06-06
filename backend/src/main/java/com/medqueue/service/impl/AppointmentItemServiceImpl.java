package com.medqueue.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentItem;
import com.medqueue.mapper.AppointmentItemMapper;
import com.medqueue.service.IAppointmentItemService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class AppointmentItemServiceImpl extends ServiceImpl<AppointmentItemMapper, AppointmentItem> implements IAppointmentItemService {

    @Override
    public Result queryItemsOfHospital(Long hospitalId) {
        List<AppointmentItem> items = getBaseMapper().queryItemsOfHospital(hospitalId);
        return Result.ok(items);
    }

    @Override
    public void addAppointmentItem(AppointmentItem item) {
        save(item);
    }
}
