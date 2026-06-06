package com.medqueue.mapper;

import com.medqueue.entity.Hospital;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

public interface HospitalMapper extends BaseMapper<Hospital> {

    int countByDepartment(@Param("departmentId") Long departmentId);
}
