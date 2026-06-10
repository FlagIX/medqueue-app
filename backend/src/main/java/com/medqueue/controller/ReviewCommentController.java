package com.medqueue.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.ReviewComment;
import com.medqueue.service.IReviewCommentService;
import com.medqueue.utils.SystemConstants;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/review-comment")
public class ReviewCommentController {

    @Resource
    private IReviewCommentService reviewCommentService;

    @PostMapping
    public Result addComment(@RequestBody ReviewComment comment) {
        UserDTO user = UserHolder.getUser();
        comment.setUserId(user.getId());
        reviewCommentService.save(comment);
        return Result.ok(comment.getId());
    }

    @GetMapping("/of/{reviewId}")
    public Result queryCommentsOfReview(
            @PathVariable("reviewId") Long reviewId,
            @RequestParam(value = "current", defaultValue = "1") Integer current,
            @RequestParam(value = "pageSize", defaultValue = "10") Integer pageSize) {
        Page<ReviewComment> page = reviewCommentService.query()
                .eq("review_id", reviewId)
                .orderByDesc("create_time")
                .page(new Page<>(current, Math.min(pageSize, SystemConstants.MAX_PAGE_SIZE)));
        return Result.ok(page);
    }
}
