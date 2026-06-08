package com.medqueue.controller;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.dto.Result;
import com.medqueue.entity.Hospital;
import com.medqueue.service.IHospitalService;
import com.medqueue.utils.SystemConstants;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/hospital")
public class HospitalController {

    @Resource
    public IHospitalService hospitalService;

    @GetMapping("/{id}")
    public Result queryHospitalById(@PathVariable("id") Long id) {
        return hospitalService.queryById(id);
    }

    @GetMapping("/{id}/pass-through")
    public Result queryWithPassThrough(@PathVariable("id") Long id) {
        return hospitalService.queryWithPassThrough(id);
    }

    @GetMapping("/{id}/mutex")
    public Result queryWithMutex(@PathVariable("id") Long id) {
        return hospitalService.queryWithMutex(id);
    }

    @GetMapping("/{id}/logical-expire")
    public Result queryWithLogicalExpire(@PathVariable("id") Long id) {
        return hospitalService.queryWithLogicalExpire(id);
    }

    @PostMapping
    public Result saveHospital(@RequestBody Hospital hospital) {
        hospitalService.save(hospital);
        return Result.ok(hospital.getId());
    }

    @PutMapping
    public Result updateHospital(@RequestBody Hospital hospital) {
        return hospitalService.updateHospital(hospital);
    }

    @GetMapping("/of/type")
    public Result queryHospitalByType(
            @RequestParam("typeId") Integer typeId,
            @RequestParam(value = "current", defaultValue = "1") Integer current
    ) {
        Page<Hospital> page = hospitalService.query()
                .eq("department_id", typeId)
                .page(new Page<>(current, SystemConstants.DEFAULT_PAGE_SIZE));
        return Result.ok(page);
    }

    @GetMapping("/of/name")
    public Result queryHospitalByName(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "current", defaultValue = "1") Integer current
    ) {
        Page<Hospital> page = hospitalService.query()
                .like(StrUtil.isNotBlank(name), "name", name)
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        return Result.ok(page);
    }

    @GetMapping("/page")
    public Result queryPage(
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "departmentId", required = false) Long departmentId
    ) {
        return hospitalService.queryPage(current, name, departmentId);
    }

    @GetMapping("/nearby")
    public Result queryNearby(
            @RequestParam("x") Double x,
            @RequestParam("y") Double y,
            @RequestParam(value = "distance", defaultValue = "5") Integer distance
    ) {
        return hospitalService.queryNearby(x, y, distance);
    }
}
