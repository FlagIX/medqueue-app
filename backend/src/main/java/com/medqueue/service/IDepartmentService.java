package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.Department;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IDepartmentService extends IService<Department> {

    Result queryTypeListWithCache();
}
