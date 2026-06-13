package com.medqueue.utils;

import com.medqueue.dto.UserDTO;
// [Spring] HandlerInterceptor = Spring MVC 拦截器
//   两个拦截器设计：
//     RefreshTokenInterceptor (order=0) → 先执行，负责取 Redis 存 ThreadLocal
//     LoginInterceptor (order=1)        → 后执行，检查 ThreadLocal 有无用户
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // [项目] UserHolder.getUser() = 从 ThreadLocal 取用户
        //   RefreshTokenInterceptor 已在 order=0 时存入
        if (UserHolder.getUser() == null) {
            // [Spring] response.setStatus(401) = HTTP 401 Unauthorized
            response.setStatus(401);
            return false;  // 拦截，不进入 Controller
        }
        return true;  // 有用户，放行
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // [项目] 清除 ThreadLocal（与 RefreshTokenInterceptor 重复，双重保障）
        UserHolder.removeUser();
    }
}
