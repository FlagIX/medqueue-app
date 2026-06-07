package com.medqueue.service;

import com.medqueue.dto.Result;
import com.medqueue.entity.PatientProfile;
import com.baomidou.mybatisplus.extension.service.IService;

public interface IPatientProfileService extends IService<PatientProfile> {

    Result addProfile(PatientProfile profile, Long userId);

    Result queryMyProfiles(Long userId);

    Result updateProfile(PatientProfile profile);

    Result deleteProfile(Long id, Long userId);
}
