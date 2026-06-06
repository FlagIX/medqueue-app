package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.Follow;
import com.medqueue.service.IFollowService;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/follow")
public class FollowController {

    @Resource
    private IFollowService followService;

    @PutMapping("/{id}/{type}")
    public Result follow(@PathVariable("id") Long followId, @PathVariable("type") Integer followType) {
        UserDTO user = UserHolder.getUser();
        Long userId = user.getId();
        Follow one = followService.query()
                .eq("user_id", userId)
                .eq("follow_id", followId)
                .eq("follow_type", followType)
                .one();
        if (one != null) {
            followService.removeById(one.getId());
            return Result.ok("已取消关注");
        }
        Follow follow = new Follow();
        follow.setUserId(userId);
        follow.setFollowId(followId);
        follow.setFollowType(followType);
        followService.save(follow);
        return Result.ok("已关注");
    }

    @GetMapping("/or/{id}/{type}")
    public Result isFollow(@PathVariable("id") Long followId, @PathVariable("type") Integer followType) {
        UserDTO user = UserHolder.getUser();
        int count = followService.query()
                .eq("user_id", user.getId())
                .eq("follow_id", followId)
                .eq("follow_type", followType)
                .count();
        return Result.ok(count > 0);
    }

    @GetMapping("/my/{type}")
    public Result queryMyFollows(@PathVariable("type") Integer followType) {
        UserDTO user = UserHolder.getUser();
        return Result.ok(followService.query()
                .eq("user_id", user.getId())
                .eq("follow_type", followType)
                .list());
    }
}
