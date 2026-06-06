package com.medqueue.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.dto.Result;
import com.medqueue.entity.Doctor;
import com.medqueue.service.IDoctorService;
import com.medqueue.utils.SystemConstants;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/doctor")
public class DoctorController {

    @Resource
    private IDoctorService doctorService;

    @GetMapping("/{id}")
    public Result queryDoctorById(@PathVariable("id") Long id) {
        Doctor doctor = doctorService.getById(id);
        if (doctor == null) {
            return Result.fail("医生不存在");
        }
        return Result.ok(doctor);
    }

    @GetMapping("/of/department")
    public Result queryDoctorByDepartment(
            @RequestParam("departmentId") Long departmentId,
            @RequestParam(value = "current", defaultValue = "1") Integer current
    ) {
        Page<Doctor> page = doctorService.query()
                .eq("department_id", departmentId)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page.getRecords());
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
