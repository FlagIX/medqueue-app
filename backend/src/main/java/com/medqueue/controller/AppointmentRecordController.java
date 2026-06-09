package com.medqueue.controller;

import com.medqueue.dto.AppointmentBookingDTO;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.service.IAppointmentRecordService;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/appointment")
public class AppointmentRecordController {

    @Resource
    private IAppointmentRecordService appointmentRecordService;

    @PostMapping
    public Result bookAppointment(@RequestBody AppointmentBookingDTO dto) {
        return appointmentRecordService.createAppointmentRecord(dto);
    }

    @GetMapping("/list")
    public Result queryUserRecords(
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Integer status) {
        UserDTO user = UserHolder.getUser();
        return appointmentRecordService.queryUserRecords(user.getId(), current, pageSize, status);
    }

    @PutMapping("/{id}/cancel")
    public Result cancelAppointment(@PathVariable("id") Long id) {
        UserDTO user = UserHolder.getUser();
        return appointmentRecordService.cancelAppointment(id, user.getId());
    }
}
