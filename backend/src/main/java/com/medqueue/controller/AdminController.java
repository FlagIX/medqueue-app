package com.medqueue.controller;

import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/admin")
public class AdminController {

    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";
    private static final String ADMIN_TOKEN = "admin-token";

    @PostMapping("/login")
    public Result login(@RequestBody Map<String, String> params) {
        String username = params.get("username");
        String password = params.get("password");

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            log.info("管理员登录成功");
            return Result.ok(ADMIN_TOKEN);
        }
        return Result.fail(ErrorCode.UNAUTHORIZED, "账号或密码错误");
    }
}
