package com.medqueue.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.MedicalReview;
import com.medqueue.entity.User;
import com.medqueue.service.IMedicalReviewService;
import com.medqueue.service.IUserService;
import com.medqueue.utils.SystemConstants;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/review")
public class ReviewController {

    @Resource
    private IMedicalReviewService reviewService;
    @Resource
    private IUserService userService;

    @PostMapping
    public Result saveReview(@RequestBody MedicalReview review) {
        UserDTO user = UserHolder.getUser();
        review.setUserId(user.getId());
        reviewService.save(review);
        return Result.ok(review.getId());
    }

    @PutMapping("/like/{id}")
    public Result likeReview(@PathVariable("id") Long id) {
        reviewService.update()
                .setSql("liked = liked + 1").eq("id", id).update();
        return Result.ok();
    }

    @GetMapping("/of/me")
    public Result queryMyReview(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        UserDTO user = UserHolder.getUser();
        Page<MedicalReview> page = reviewService.query()
                .eq("user_id", user.getId()).page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        List<MedicalReview> records = page.getRecords();
        return Result.ok(records);
    }

    @GetMapping("/page")
    public Result queryPage(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        Page<MedicalReview> page = reviewService.query()
                .orderByDesc("create_time")
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        List<MedicalReview> records = page.getRecords();
        records.forEach(review -> {
            User user = userService.getById(review.getUserId());
            if (user != null) {
                review.setName(user.getNickName());
                review.setIcon(user.getIcon());
            }
        });
        return Result.ok(records);
    }

    @GetMapping("/hot")
    public Result queryHotReview(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        Page<MedicalReview> page = reviewService.query()
                .orderByDesc("liked")
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        List<MedicalReview> records = page.getRecords();
        records.forEach(review -> {
            Long userId = review.getUserId();
            User user = userService.getById(userId);
            review.setName(user.getNickName());
            review.setIcon(user.getIcon());
        });
        return Result.ok(records);
    }
}
