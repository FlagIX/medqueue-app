package com.medqueue.mapper;

import com.medqueue.entity.MedicalReview;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface MedicalReviewMapper extends BaseMapper<MedicalReview> {

    List<MedicalReview> queryReviewsByHospital(@Param("hospitalId") Long hospitalId, Page<MedicalReview> page);

    List<MedicalReview> queryReviewsByDoctor(@Param("doctorId") Long doctorId, Page<MedicalReview> page);
}
