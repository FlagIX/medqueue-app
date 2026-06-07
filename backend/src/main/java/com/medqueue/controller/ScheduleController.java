package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.service.IScheduleService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/schedule")
public class ScheduleController {

    @Resource
    private IScheduleService scheduleService;

    @PostMapping("/sync")
    public Result syncAll() {
        return scheduleService.syncAllSchedules();
    }

    @PostMapping("/{id}/sync")
    public Result syncOne(@PathVariable("id") Long scheduleId) {
        return scheduleService.syncSchedule(scheduleId);
    }
}
