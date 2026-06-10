package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.PatientProfile;
import com.medqueue.mapper.PatientProfileMapper;
import com.medqueue.service.IPatientProfileService;
import com.medqueue.utils.RegexUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PatientProfileServiceImpl extends ServiceImpl<PatientProfileMapper, PatientProfile> implements IPatientProfileService {

    @Override
    public Result addProfile(PatientProfile profile, Long userId) {
        if (RegexUtils.isIdCardInvalid(profile.getIdCard())) {
            throw new BizException(ErrorCode.ID_CARD_FORMAT_ERROR, "身份证格式错误");
        }
        Long count = lambdaQuery().eq(PatientProfile::getIdCard, profile.getIdCard()).count();
        if (count > 0) {
            throw new BizException(ErrorCode.PATIENT_ID_CARD_BOUND, "该身份证已被绑定，请核对后重试");
        }
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
            throw new BizException(ErrorCode.PATIENT_NOT_EXIST, "就诊人不存在");
        }
        if (profile.getIdCard() != null) {
            if (RegexUtils.isIdCardInvalid(profile.getIdCard())) {
                throw new BizException(ErrorCode.ID_CARD_FORMAT_ERROR, "身份证格式错误");
            }
            if (!profile.getIdCard().equals(existing.getIdCard())) {
                Long count = lambdaQuery().eq(PatientProfile::getIdCard, profile.getIdCard()).count();
                if (count > 0) {
                    throw new BizException(ErrorCode.PATIENT_ID_CARD_BOUND, "该身份证已被绑定，请核对后重试");
                }
            }
        }
        profile.setUserId(null).setCreateTime(null).setUpdateTime(LocalDateTime.now());
        updateById(profile);
        return Result.ok();
    }

    @Override
    public Result deleteProfile(Long id, Long userId) {
        PatientProfile existing = getById(id);
        if (existing == null) {
            throw new BizException(ErrorCode.PATIENT_NOT_EXIST, "就诊人不存在");
        }
        if (!existing.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.PATIENT_DELETE_FORBIDDEN, "无权删除该就诊人");
        }
        removeById(id);
        return Result.ok();
    }
}
