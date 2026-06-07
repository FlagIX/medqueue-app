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
        return appointmentRecordService.bookAppointment(dto);
    }

    @GetMapping("/list")
    public Result queryUserRecords() {
        UserDTO user = UserHolder.getUser();
        return appointmentRecordService.queryUserRecords(user.getId());
    }

    @PutMapping("/{id}/cancel")
    public Result cancelAppointment(@PathVariable("id") Long id) {
        UserDTO user = UserHolder.getUser();
        return appointmentRecordService.cancelAppointment(id, user.getId());
    }
}
