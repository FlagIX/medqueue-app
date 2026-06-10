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
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static com.medqueue.utils.RedisConstants.REVIEW_LIKED_KEY;

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

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @PutMapping("/like/{id}")
    public Result likeReview(@PathVariable("id") Long id) {
        UserDTO user = UserHolder.getUser();
        if (user == null) {
            return Result.fail("请先登录");
        }
        String key = REVIEW_LIKED_KEY + id;
        String userId = user.getId().toString();
        Boolean isLiked = stringRedisTemplate.opsForSet().isMember(key, userId);
        if (Boolean.TRUE.equals(isLiked)) {
            // 已赞 → 取消赞
            stringRedisTemplate.opsForSet().remove(key, userId);
            reviewService.update().setSql("liked = liked - 1").eq("id", id).gt("liked", 0).update();
            return Result.ok("取消点赞");
        } else {
            // 未赞 → 点赞
            stringRedisTemplate.opsForSet().add(key, userId);
            reviewService.update().setSql("liked = liked + 1").eq("id", id).update();
            return Result.ok("点赞成功");
        }
    }

    @GetMapping("/of/me")
    public Result queryMyReview(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        UserDTO user = UserHolder.getUser();
        Page<MedicalReview> page = reviewService.query()
                .eq("user_id", user.getId()).page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        return Result.ok(page);
    }

    @GetMapping("/page")
    public Result queryPage(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        Page<MedicalReview> page = reviewService.query()
                .orderByDesc("create_time")
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        List<MedicalReview> records = page.getRecords();
        if (!records.isEmpty()) {
            List<Long> userIds = records.stream()
                    .map(MedicalReview::getUserId)
                    .distinct()
                    .collect(Collectors.toList());
            Map<Long, User> userMap = userService.listByIds(userIds).stream()
                    .collect(Collectors.toMap(User::getId, u -> u));
            records.forEach(review -> {
                User u = userMap.get(review.getUserId());
                if (u != null) {
                    review.setName(u.getNickName());
                    review.setIcon(u.getIcon());
                }
            });
        }
        return Result.ok(page);
    }

    @GetMapping("/hot")
    public Result queryHotReview(@RequestParam(value = "current", defaultValue = "1") Integer current) {
        Page<MedicalReview> page = reviewService.query()
                .orderByDesc("liked")
                .page(new Page<>(current, SystemConstants.MAX_PAGE_SIZE));
        List<MedicalReview> records = page.getRecords();
        if (!records.isEmpty()) {
            List<Long> userIds = records.stream()
                    .map(MedicalReview::getUserId)
                    .distinct()
                    .collect(Collectors.toList());
            Map<Long, User> userMap = userService.listByIds(userIds).stream()
                    .collect(Collectors.toMap(User::getId, u -> u));
            records.forEach(review -> {
                User u = userMap.get(review.getUserId());
                if (u != null) {
                    review.setName(u.getNickName());
                    review.setIcon(u.getIcon());
                }
            });
        }
        return Result.ok(page);
    }
}
