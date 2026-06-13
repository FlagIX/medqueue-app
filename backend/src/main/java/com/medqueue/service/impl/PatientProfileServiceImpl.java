package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.PatientProfile;
import com.medqueue.mapper.PatientProfileMapper;
import com.medqueue.service.IPatientProfileService;
import com.medqueue.utils.RegexUtils;               // [项目] 正则校验工具（手机号/身份证）
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;   // [MP] CRUD 基类
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PatientProfileServiceImpl extends ServiceImpl<PatientProfileMapper, PatientProfile> implements IPatientProfileService {

    @Override
    public Result addProfile(PatientProfile profile, Long userId) {
        // [项目] RegexUtils.isIdCardInvalid() = 身份证号正则校验
        if (RegexUtils.isIdCardInvalid(profile.getIdCard())) {
            throw new BizException(ErrorCode.ID_CARD_FORMAT_ERROR, "身份证格式错误");
        }
        // [MP] lambdaQuery().eq(实体::get字段, 值).count() = SELECT COUNT(*) WHERE 字段 = 值
        Long count = lambdaQuery().eq(PatientProfile::getIdCard, profile.getIdCard()).count();
        if (count > 0) {
            throw new BizException(ErrorCode.PATIENT_ID_CARD_BOUND, "该身份证已被绑定，请核对后重试");
        }
        profile.setUserId(userId);
        profile.setCreateTime(LocalDateTime.now());
        profile.setUpdateTime(LocalDateTime.now());
        save(profile);  // [MP] INSERT
        return Result.ok(profile.getId());
    }

    @Override
    public Result queryMyProfiles(Long userId) {
        // [MP] lambdaQuery().eq(字段, 值).list() = SELECT * WHERE user_id = ?
        return Result.ok(lambdaQuery().eq(PatientProfile::getUserId, userId).list());
    }

    @Override
    public Result updateProfile(PatientProfile profile) {
        // [MP] getById(id) = 查原有记录
        PatientProfile existing = getById(profile.getId());
        if (existing == null) {
            throw new BizException(ErrorCode.PATIENT_NOT_EXIST, "就诊人不存在");
        }
        if (profile.getIdCard() != null) {
            if (RegexUtils.isIdCardInvalid(profile.getIdCard())) {
                throw new BizException(ErrorCode.ID_CARD_FORMAT_ERROR, "身份证格式错误");
            }
            // 如果改了身份证号，检查新号是否已被绑定
            if (!profile.getIdCard().equals(existing.getIdCard())) {
                Long count = lambdaQuery().eq(PatientProfile::getIdCard, profile.getIdCard()).count();
                if (count > 0) {
                    throw new BizException(ErrorCode.PATIENT_ID_CARD_BOUND, "该身份证已被绑定，请核对后重试");
                }
            }
        }
        // [MP] @Accessors(chain = true) → setter 返回 this，支持链式调用
        profile.setUserId(null).setCreateTime(null).setUpdateTime(LocalDateTime.now());
        updateById(profile);  // [MP] UPDATE
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
        removeById(id);  // [MP] DELETE FROM patient_profile WHERE id = ?
        return Result.ok();
    }
}
