package com.medqueue.service.impl;

import com.medqueue.entity.Follow;
import com.medqueue.mapper.FollowMapper;
import com.medqueue.service.IFollowService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class FollowServiceImpl extends ServiceImpl<FollowMapper, Follow> implements IFollowService {

}
