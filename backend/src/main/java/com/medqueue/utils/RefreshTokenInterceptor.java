package com.medqueue.utils;

import cn.hutool.core.bean.BeanUtil;          // [Hutool] Bean工具：fillBeanWithMap() 属性填充
import cn.hutool.core.util.StrUtil;           // [Hutool] 字符串工具：isBlank() 判空
import com.medqueue.dto.UserDTO;
import org.springframework.data.redis.core.StringRedisTemplate;
// [Spring] HandlerInterceptor = Spring MVC 拦截器接口
//   preHandle() → 请求进入前执行
//   postHandle() → 请求处理后、视图渲染前
//   afterCompletion() → 请求结束后
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.LOGIN_USER_KEY;
import static com.medqueue.utils.RedisConstants.LOGIN_USER_TTL;

// [Spring] 拦截器 — 不实现 WebMvcConfigurer，在 MvcConfig 中手动 new 注册
//   order = 0：先于 LoginInterceptor 执行，负责取 Redis 存 ThreadLocal
public class RefreshTokenInterceptor implements HandlerInterceptor {

    // [Spring] 非 @Resource 注入，由 MvcConfig 通过构造器传入
    private StringRedisTemplate stringRedisTemplate;

    public RefreshTokenInterceptor(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    // [Spring] preHandle = 请求处理前调用
    //   request  = HTTP 请求对象（含请求头/参数/URI）
    //   response = HTTP 响应对象（可写状态码/Body）
    //   handler  = 处理此请求的 Controller 方法（HandlerMethod 对象）
    //   返回值 true=放行, false=拦截
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 从请求头获取 token
        // [Spring] request.getHeader("authorization") = 取 Authorization 请求头
        String token = request.getHeader("authorization");
        // [Hutool] StrUtil.isBlank(null/""/"   ") = true
        if (StrUtil.isBlank(token)) {
            return true;  // 无 token 也放行（由 LoginInterceptor 决定是否拦截）
        }
        // 2. 基于 token 查 Redis
        String key = LOGIN_USER_KEY + token;  // "login:token:f47ac10b..."
        // [Redis] opsForHash().entries(key) = HGETALL key，返回 Map<field, value>
        Map<Object, Object> userMap = stringRedisTemplate.opsForHash().entries(key);
        // 3. 判断用户是否存在（空 Map 表示 token 过期或无效）
        if (userMap.isEmpty()) {
            return true;  // 无用户也放行
        }
        // 5. [Hutool] fillBeanWithMap(map, bean, false) = Map → 对象
        //    false = 忽略大小写差异
        UserDTO userDTO = BeanUtil.fillBeanWithMap(userMap, new UserDTO(), false);
        // 6. 存在 → 保存用户到 ThreadLocal
        // [项目] UserHolder.saveUser() = ThreadLocal.set(userDTO)
        UserHolder.saveUser(userDTO);
        // 7. 刷新 token 有效期（每次请求都续期）
        // [Redis] expire(key, ttl, unit) = EXPIRE key ttl（滑动过期：续 25 天）
        stringRedisTemplate.expire(key, LOGIN_USER_TTL, TimeUnit.MINUTES);
        // 8. 放行
        return true;
    }

    // [Spring] afterCompletion = 请求结束后（视图渲染完成）
    //   ex = 处理过程中抛出的异常（无异常为 null）
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // [项目] 清除 ThreadLocal，防止内存泄漏
        UserHolder.removeUser();
    }
}
