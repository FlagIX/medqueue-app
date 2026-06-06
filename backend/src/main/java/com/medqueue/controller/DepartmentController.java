package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.service.IDepartmentService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/department")
public class DepartmentController {
    @Resource
    private IDepartmentService departmentService;

    @GetMapping("list")
    public Result queryList() {
        return departmentService.queryListWithCache();
    }
}
