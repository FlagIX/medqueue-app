package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.entity.AppointmentItem;
import com.medqueue.service.IAppointmentItemService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/appointment-item")
public class AppointmentItemController {

    @Resource
    private IAppointmentItemService appointmentItemService;

    @PostMapping
    public Result addAppointmentItem(@RequestBody AppointmentItem item) {
        appointmentItemService.save(item);
        return Result.ok(item.getId());
    }

    @GetMapping("/list/{hospitalId}")
    public Result queryItemsOfHospital(@PathVariable("hospitalId") Long hospitalId) {
        return appointmentItemService.queryItemsOfHospital(hospitalId);
    }
}
