package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.medqueue.service.IDoctorService;
import com.medqueue.service.IDoctorScheduleService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.LocalDate;

@RestController
@RequestMapping("/doctor")
public class DoctorController {

    @Resource
    private IDoctorService doctorService;

    @Resource
    private IDoctorScheduleService doctorScheduleService;

    @GetMapping("/{id}")
    public Result queryDoctorById(@PathVariable("id") Long id) {
        return doctorService.queryById(id);
    }

    @GetMapping("/of/department")
    public Result queryDoctorByDepartment(
            @RequestParam("departmentId") Long departmentId,
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "pageSize", required = false) Integer pageSize) {
        return doctorService.queryByDepartment(departmentId, current, pageSize);
    }

    @GetMapping("/of/hospital")
    public Result queryDoctorByHospital(
            @RequestParam("hospitalId") Long hospitalId,
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "pageSize", required = false) Integer pageSize) {
        return doctorService.queryByHospital(hospitalId, current, pageSize);
    }

    @GetMapping("/page")
    public Result queryDoctorPage(
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "name", required = false) String name
    ) {
        return doctorService.queryPage(current, name);
    }

    @GetMapping("/{id}/schedule")
    public Result querySchedule(
            @PathVariable("id") Long doctorId,
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date
    ) {
        return doctorScheduleService.querySchedules(doctorId, date);
    }

    @GetMapping("/{id}/schedule/available")
    public Result queryAvailableSchedules(
            @PathVariable("id") Long doctorId,
            @RequestParam("beginDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate beginDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate
    ) {
        return doctorScheduleService.queryAvailableSchedules(doctorId, beginDate, endDate);
    }

    @PostMapping
    public Result addDoctor(@RequestBody Doctor doctor) {
        doctorService.save(doctor);
        return Result.ok(doctor.getId());
    }

    @PutMapping
    public Result updateDoctor(@RequestBody Doctor doctor) {
        doctorService.updateById(doctor);
        return Result.ok();
    }
}
