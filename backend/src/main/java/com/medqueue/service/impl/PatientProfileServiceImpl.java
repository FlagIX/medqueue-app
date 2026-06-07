package com.medqueue.service.impl;

import com.medqueue.dto.Result;
import com.medqueue.entity.PatientProfile;
import com.medqueue.mapper.PatientProfileMapper;
import com.medqueue.service.IPatientProfileService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PatientProfileServiceImpl extends ServiceImpl<PatientProfileMapper, PatientProfile> implements IPatientProfileService {

    @Override
    public Result addProfile(PatientProfile profile, Long userId) {
        profile.setUserId(userId);
        profile.setCreateTime(LocalDateTime.now());
        profile.setUpdateTime(LocalDateTime.now());
        save(profile);
        return Result.ok(profile.getId());
    }

    @Override
    public Result queryMyProfiles(Long userId) {
        return Result.ok(lambdaQuery().eq(PatientProfile::getUserId, userId).list());
    }

    @Override
    public Result updateProfile(PatientProfile profile) {
        PatientProfile existing = getById(profile.getId());
        if (existing == null) {
            return Result.fail("就诊人不存在");
        }
        profile.setUserId(null).setCreateTime(null).setUpdateTime(LocalDateTime.now());
        updateById(profile);
        return Result.ok();
    }

    @Override
    public Result deleteProfile(Long id, Long userId) {
        PatientProfile existing = getById(id);
        if (existing == null) {
            return Result.fail("就诊人不存在");
        }
        if (!existing.getUserId().equals(userId)) {
            return Result.fail("无权删除该就诊人");
        }
        removeById(id);
        return Result.ok();
    }
}
