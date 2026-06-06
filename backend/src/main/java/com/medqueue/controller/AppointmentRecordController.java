package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.service.IAppointmentRecordService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/appointment-record")
public class AppointmentRecordController {
    @Resource
    private IAppointmentRecordService appointmentRecordService;

    @PostMapping("book/{id}")
    public Result bookAppointment(@PathVariable("id") Long scheduleId) {
        return appointmentRecordService.bookAppointment(scheduleId);
    }
}
