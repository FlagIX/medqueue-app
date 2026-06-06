package com.medqueue.service.impl;

import com.medqueue.entity.PatientProfile;
import com.medqueue.mapper.PatientProfileMapper;
import com.medqueue.service.IPatientProfileService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class PatientProfileServiceImpl extends ServiceImpl<PatientProfileMapper, PatientProfile> implements IPatientProfileService {

}
