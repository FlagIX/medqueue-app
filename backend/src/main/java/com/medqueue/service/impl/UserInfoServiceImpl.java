package com.medqueue.service.impl;

import com.medqueue.entity.UserInfo;
import com.medqueue.mapper.UserInfoMapper;
import com.medqueue.service.IUserInfoService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class UserInfoServiceImpl extends ServiceImpl<UserInfoMapper, UserInfo> implements IUserInfoService {

}
