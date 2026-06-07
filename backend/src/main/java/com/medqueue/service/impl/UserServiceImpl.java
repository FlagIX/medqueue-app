package com.medqueue.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.lang.UUID;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.dto.LoginFormDTO;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.User;
import com.medqueue.mapper.UserMapper;
import com.medqueue.service.IUserService;
import com.medqueue.utils.RedisConstants;
import com.medqueue.utils.RegexUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.*;
import static com.medqueue.utils.SystemConstants.USER_NICK_NAME_PREFIX;

@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result sendCode(String phone, HttpSession session) {
        if (RegexUtils.isPhoneInvalid(phone)) {
            return Result.fail("手机格式错误");
        }
        String code = RandomUtil.randomNumbers(6);
        stringRedisTemplate.opsForValue().set(LOGIN_CODE_KEY + phone, code, LOGIN_CODE_TTL, TimeUnit.MINUTES);
        log.debug("发送验证码成功,验证码:{}", code);
        return Result.ok();
    }

    @Override
    public Result login(LoginFormDTO loginForm, HttpSession session) {
        String phone = loginForm.getPhone();
        if (RegexUtils.isPhoneInvalid(phone)) {
            return Result.fail("手机格式错误");
        }

        User user = query().eq("phone", phone).one();
        if (user == null) {
            return Result.fail("用户不存在，请先注册");
        }

        String code = loginForm.getCode();
        if (code != null) {
            String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
            if (cacheCode == null || !cacheCode.equals(code)) {
                return Result.fail("验证码错误");
            }
            stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);
        } else {
            String password = loginForm.getPassword();
            if (password == null || !BCrypt.checkpw(password, user.getPassword())) {
                return Result.fail("密码错误");
            }
        }

        String token = UUID.randomUUID().toString(true);
        UserDTO userDTO = BeanUtil.copyProperties(user, UserDTO.class);
        Map<String, Object> userMap = BeanUtil.beanToMap(userDTO);
        Map<String, String> userMapStr = new HashMap<>();
        for (Map.Entry<String, Object> entry : userMap.entrySet()) {
            userMapStr.put(entry.getKey(), entry.getValue() == null ? "" : entry.getValue().toString());
        }
        String tokenKey = LOGIN_USER_KEY + token;
        stringRedisTemplate.opsForHash().putAll(tokenKey, userMapStr);
        stringRedisTemplate.expire(tokenKey, RedisConstants.LOGIN_USER_TTL, TimeUnit.MINUTES);

        return Result.ok(token);
    }

    @Override
    public Result register(LoginFormDTO loginForm) {
        String phone = loginForm.getPhone();
        if (RegexUtils.isPhoneInvalid(phone)) {
            return Result.fail("手机格式错误");
        }

        String password = loginForm.getPassword();
        if (password == null || password.length() < 6) {
            return Result.fail("密码长度不能少于6位");
        }

        String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
        String code = loginForm.getCode();
        if (cacheCode == null || !cacheCode.equals(code)) {
            return Result.fail("验证码错误");
        }
        stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);

        User existing = query().eq("phone", phone).one();
        if (existing != null) {
            return Result.fail("该手机号已注册");
        }

        User user = new User();
        user.setPhone(phone);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setNickName(USER_NICK_NAME_PREFIX + RandomUtil.randomString(10));
        save(user);

        return Result.ok();
    }
}
