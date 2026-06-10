package com.medqueue.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.lang.UUID;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.LoginFormDTO;
import com.medqueue.dto.ProfileUpdateDTO;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.User;
import com.medqueue.entity.UserInfo;
import com.medqueue.mapper.UserMapper;
import com.medqueue.service.IUserInfoService;
import com.medqueue.service.IUserService;
import com.medqueue.utils.RedisConstants;
import com.medqueue.utils.RegexUtils;
import com.medqueue.utils.UserHolder;
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

    @Resource
    private IUserInfoService userInfoService;

    @Override
    public Result sendCode(String phone, HttpSession session) {
        if (RegexUtils.isPhoneInvalid(phone)) {
            throw new BizException(ErrorCode.PHONE_FORMAT_ERROR, "手机格式错误");
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
            throw new BizException(ErrorCode.PHONE_FORMAT_ERROR, "手机格式错误");
        }

        User user = query().eq("phone", phone).one();
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_EXIST, "用户不存在，请先注册");
        }

        String code = loginForm.getCode();
        if (code != null) {
            String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
            if (cacheCode == null || !cacheCode.equals(code)) {
                throw new BizException(ErrorCode.LOGIN_CODE_ERROR, "验证码错误");
            }
            stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);
        } else {
            String password = loginForm.getPassword();
            if (password == null || !BCrypt.checkpw(password, user.getPassword())) {
                throw new BizException(ErrorCode.LOGIN_PASSWORD_ERROR, "密码错误");
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
            throw new BizException(ErrorCode.PHONE_FORMAT_ERROR, "手机格式错误");
        }

        String password = loginForm.getPassword();
        if (password == null || password.length() < 6) {
            throw new BizException(ErrorCode.PASSWORD_FORMAT_ERROR, "密码长度不能少于6位");
        }

        String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
        String code = loginForm.getCode();
        if (cacheCode == null || !cacheCode.equals(code)) {
            throw new BizException(ErrorCode.LOGIN_CODE_ERROR, "验证码错误");
        }
        stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);

        User existing = query().eq("phone", phone).one();
        if (existing != null) {
            throw new BizException(ErrorCode.USER_ALREADY_EXIST, "该手机号已注册");
        }

        User user = new User();
        user.setPhone(phone);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        String nickName = loginForm.getNickName();
        if (nickName != null && !nickName.trim().isEmpty()) {
            user.setNickName(nickName.trim());
        } else {
            user.setNickName(USER_NICK_NAME_PREFIX + RandomUtil.randomString(10));
        }
        save(user);

        return Result.ok();
    }

    @Override
    public Result updateProfile(ProfileUpdateDTO dto) {
        UserDTO userDTO = UserHolder.getUser();
        if (userDTO == null) {
            throw new BizException(ErrorCode.UNAUTHORIZED, "请先登录");
        }
        Long userId = userDTO.getId();

        String nickName = dto.getNickName();
        if (nickName != null && !nickName.trim().isEmpty()) {
            nickName = nickName.trim();
            lambdaUpdate().set(User::getNickName, nickName).eq(User::getId, userId).update();
        }

        String icon = dto.getIcon();
        if (icon != null) {
            lambdaUpdate().set(User::getIcon, icon).eq(User::getId, userId).update();
        }

        UserInfo userInfo = userInfoService.getById(userId);
        if (userInfo == null) {
            userInfo = new UserInfo();
            userInfo.setUserId(userId);
        }
        if (dto.getCity() != null) userInfo.setCity(dto.getCity());
        if (dto.getIntroduce() != null) userInfo.setIntroduce(dto.getIntroduce());
        if (dto.getGender() != null) userInfo.setGender(dto.getGender());
        if (dto.getBirthday() != null) userInfo.setBirthday(dto.getBirthday());

        userInfoService.saveOrUpdate(userInfo);

        return Result.ok();
    }
}
