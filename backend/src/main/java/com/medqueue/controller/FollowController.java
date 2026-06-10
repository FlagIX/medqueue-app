package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.Doctor;
import com.medqueue.entity.Follow;
import com.medqueue.entity.Hospital;
import com.medqueue.service.IDoctorService;
import com.medqueue.service.IFollowService;
import com.medqueue.service.IHospitalService;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/follow")
public class FollowController {

    @Resource
    private IFollowService followService;

    @Resource
    private IHospitalService hospitalService;

    @Resource
    private IDoctorService doctorService;

    @PostMapping("/{id}")
    public Result follow(@PathVariable("id") Long followId,
                         @RequestParam(value = "type", defaultValue = "0") Integer followType) {
        UserDTO user = UserHolder.getUser();
        Follow one = followService.query()
                .eq("user_id", user.getId())
                .eq("follow_id", followId)
                .eq("follow_type", followType)
                .one();
        if (one != null) {
            return Result.ok("已关注");
        }
        Follow follow = new Follow();
        follow.setUserId(user.getId());
        follow.setFollowId(followId);
        follow.setFollowType(followType);
        followService.save(follow);
        return Result.ok("已关注");
    }

    @DeleteMapping("/{id}")
    public Result unfollow(@PathVariable("id") Long followId,
                           @RequestParam(value = "type", defaultValue = "0") Integer followType) {
        UserDTO user = UserHolder.getUser();
        followService.lambdaUpdate()
                .eq(Follow::getUserId, user.getId())
                .eq(Follow::getFollowId, followId)
                .eq(Follow::getFollowType, followType)
                .remove();
        return Result.ok("已取消关注");
    }

    @GetMapping("/or/{id}/{type}")
    public Result isFollow(@PathVariable("id") Long followId, @PathVariable("type") Integer followType) {
        UserDTO user = UserHolder.getUser();
        long count = followService.query()
                .eq("user_id", user.getId())
                .eq("follow_id", followId)
                .eq("follow_type", followType)
                .count();
        return Result.ok(count > 0);
    }

    @GetMapping("/list")
    public Result queryMyFollows(@RequestParam(value = "type", defaultValue = "0") Integer followType) {
        UserDTO user = UserHolder.getUser();
        List<Follow> follows = followService.query()
                .eq("user_id", user.getId())
                .eq("follow_type", followType)
                .list();

        if (follows.isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("records", Collections.emptyList());
            result.put("total", 0L);
            return Result.ok(result);
        }

        // 收集医院ID和医生ID，分别批量查询
        List<Long> hospitalIds = new ArrayList<>();
        List<Long> doctorIds = new ArrayList<>();
        for (Follow f : follows) {
            if (f.getFollowType() == 1) {
                hospitalIds.add(f.getFollowId());
            } else if (f.getFollowType() == 2) {
                doctorIds.add(f.getFollowId());
            }
        }

        Map<Long, Hospital> hospitalMap = new HashMap<>();
        Map<Long, Doctor> doctorMap = new HashMap<>();

        if (!hospitalIds.isEmpty()) {
            hospitalMap = hospitalService.listByIds(hospitalIds).stream()
                    .collect(Collectors.toMap(Hospital::getId, h -> h));
        }
        if (!doctorIds.isEmpty()) {
            doctorMap = doctorService.listByIds(doctorIds).stream()
                    .collect(Collectors.toMap(Doctor::getId, d -> d));
        }

        List<Map<String, Object>> items = new ArrayList<>();
        for (Follow f : follows) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", f.getId());
            item.put("followId", f.getFollowId());
            item.put("followType", f.getFollowType());
            item.put("createTime", f.getCreateTime());
            if (f.getFollowType() == 1) {
                item.put("hospital", hospitalMap.get(f.getFollowId()));
            } else if (f.getFollowType() == 2) {
                item.put("doctor", doctorMap.get(f.getFollowId()));
            }
            items.add(item);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", items);
        result.put("total", (long) items.size());
        return Result.ok(result);
    }
}
