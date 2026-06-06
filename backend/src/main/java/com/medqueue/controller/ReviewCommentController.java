package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.ReviewComment;
import com.medqueue.service.IReviewCommentService;
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
    public Result queryCommentsOfReview(@PathVariable("reviewId") Long reviewId) {
        return Result.ok(reviewCommentService.query()
                .eq("review_id", reviewId)
                .orderByDesc("create_time")
                .list());
    }
}
