package com.medqueue.service.impl;

import com.medqueue.entity.ReviewComment;
import com.medqueue.mapper.ReviewCommentMapper;
import com.medqueue.service.IReviewCommentService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

@Service
public class ReviewCommentServiceImpl extends ServiceImpl<ReviewCommentMapper, ReviewComment> implements IReviewCommentService {

}
