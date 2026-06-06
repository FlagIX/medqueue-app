package com.medqueue.service.impl;

import com.medqueue.entity.Doctor;
import com.medqueue.mapper.DoctorMapper;
import com.medqueue.service.IDoctorService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class DoctorServiceImpl extends ServiceImpl<DoctorMapper, Doctor> implements IDoctorService {

}
