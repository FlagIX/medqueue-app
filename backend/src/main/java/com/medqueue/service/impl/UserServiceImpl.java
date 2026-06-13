package com.medqueue.service.impl;

import cn.hutool.core.bean.BeanUtil;       // [Hutool] Bean工具：属性拷贝、对象↔Map
import cn.hutool.core.lang.UUID;              // [Hutool] 增强UUID：支持去横线 toString(true)
import cn.hutool.core.util.RandomUtil;        // [Hutool] 随机工具：随机数字/字符串
import cn.hutool.crypto.digest.BCrypt;        // [Hutool] BCrypt加密工具：密码哈希+校验

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
// [MP] ServiceImpl<Mapper, Entity> 标准继承
//   → 提供 baseMapper、save()、updateById()、lambdaQuery()、query().eq() 等内置方法

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;          // [项目] 错误码枚举
import com.medqueue.dto.LoginFormDTO;
import com.medqueue.dto.ProfileUpdateDTO;
import com.medqueue.dto.Result;                  // [项目] 统一响应包装：Result.ok() / Result.fail()
import com.medqueue.dto.UserDTO;                       // [项目] 数据传输对象：只暴露 id/nickName/icon
import com.medqueue.entity.User;                         // [MP] 数据库实体，对应 tb_user 表
import com.medqueue.entity.UserInfo;
import com.medqueue.mapper.UserMapper;
import com.medqueue.service.IUserInfoService;       // [Spring] 服务接口，调用其他 Service 的 CRUD
import com.medqueue.service.IUserService;
import com.medqueue.utils.RedisConstants;
import com.medqueue.utils.RegexUtils;               // [项目] 正则校验工具
import com.medqueue.utils.UserHolder;                // [项目] ThreadLocal 封装：获取当前登录用户
import lombok.extern.slf4j.Slf4j;                   // [Lombok] @Slf4j → 自动生成 log 字段
import org.springframework.data.redis.core.StringRedisTemplate;
// [Spring] StringRedisTemplate = Redis 操作模板（所有 value 为 String 类型）
import org.springframework.stereotype.Service;
// [Spring] @Service 注解 → 声明此类为 Spring Bean，注册到容器

import javax.annotation.Resource;               // [Spring/J2EE] @Resource = 按名称/类型注入 Bean
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static com.medqueue.utils.RedisConstants.*; // [项目] 静态导入 Redis Key 和 TTL 常量
import static com.medqueue.utils.SystemConstants.USER_NICK_NAME_PREFIX;

@Slf4j                                    // [Lombok] 自动生成 private Logger log = LoggerFactory.getLogger(getClass())
@Service                                  // [Spring] 声明为 Spring Bean，注册到容器
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {
    // [MP] ServiceImpl<Mapper, Entity> 继承 → 自带 CRUD 方法：
    //   query() → ChainQuery 链式查询
    //   lambdaQuery() → 类型安全的 Lambda 查询
    //   lambdaUpdate() → 类型安全的 Lambda 更新
    //   save()/updateById()/getById()/removeById() 等

    @Resource                              // [Spring] @Resource 字段注入
    private StringRedisTemplate stringRedisTemplate;
    // [Spring] StringRedisTemplate → 操作 Redis，所有序列化方式为 String
    //   opsForValue()  → SET/GET 字符串
    //   opsForHash()   → HSET/HGET/HGETALL 哈希
    //   opsForList()   → LPUSH/LRANGE 列表
    //   opsForGeo()    → GEOADD/GEORADIUS 地理位置

    @Resource
    private IUserInfoService userInfoService;   // [Spring] 注入另一个 Service，用于操作 user_info 表

    @Override
    public Result sendCode(String phone, HttpSession session) {
        // [项目] RegexUtils = 自定义正则校验工具类
        if (RegexUtils.isPhoneInvalid(phone)) {
            // [项目] BizException = 业务异常 → 全局异常处理器捕获并包装为 Result.fail()
            throw new BizException(ErrorCode.PHONE_FORMAT_ERROR, "手机格式错误");
        }
        // [Hutool] RandomUtil.randomNumbers(n) = 生成 n 位纯数字随机字符串
        String code = RandomUtil.randomNumbers(6);
        // [Redis] opsForValue().set(key, value, ttl, unit) = SET key value EX ttl
        //   key  = "login:code:138xxxx"
        //   ttl  = 2 分钟（LOGIN_CODE_TTL）
        stringRedisTemplate.opsForValue().set(LOGIN_CODE_KEY + phone, code, LOGIN_CODE_TTL, TimeUnit.MINUTES);
        log.debug("发送验证码成功,验证码:{}", code);  // [Lombok] 自动注入的 log 字段
        return Result.ok();                // [项目] 统一响应：{success: true, data: null}
    }

    @Override
    public Result login(LoginFormDTO loginForm, HttpSession session) {
        String phone = loginForm.getPhone();
        if (RegexUtils.isPhoneInvalid(phone)) {
            throw new BizException(ErrorCode.PHONE_FORMAT_ERROR, "手机格式错误");
        }

        // [MP] query() = ChainQuery<User> 链式查询
        //   eq("phone", phone) = WHERE phone = ?
        //   one() = 查询一条记录，多于一条抛异常
        User user = query().eq("phone", phone).one();
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_EXIST, "用户不存在，请先注册");
        }

        // --- 双模式登录：验证码登录 或 密码登录 ---
        String code = loginForm.getCode();
        if (code != null) {
            // --- 模式一：验证码登录 ---
            // [Redis] opsForValue().get(key) = GET key
            String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
            if (cacheCode == null || !cacheCode.equals(code)) {
                throw new BizException(ErrorCode.LOGIN_CODE_ERROR, "验证码错误");
            }
            // [Redis] delete(key) = DEL key，用完即删（一次性验证码）
            stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);
        } else {
            // --- 模式二：密码登录 ---
            String password = loginForm.getPassword();
            // [Hutool] BCrypt.checkpw(明文, 哈希) = 校验密码是否匹配
            if (password == null || !BCrypt.checkpw(password, user.getPassword())) {
                throw new BizException(ErrorCode.LOGIN_PASSWORD_ERROR, "密码错误");
            }
        }

        // ===================== 生成 Token 并写入 Redis =====================
        // [Hutool] UUID.randomUUID().toString(true) = 32 位去横线 UUID
        String token = UUID.randomUUID().toString(true);
        // [Hutool] BeanUtil.copyProperties(源对象, 目标类.class) = 按同名同类型字段拷贝
        //   作用：User(含password/phone) → UserDTO(id/nickName/icon) 过滤敏感字段
        UserDTO userDTO = BeanUtil.copyProperties(user, UserDTO.class);
        // [Hutool] BeanUtil.beanToMap(dto) = 对象转 Map<字段名, 字段值>
        //   中间格式，方便写入 Redis Hash
        Map<String, Object> userMap = BeanUtil.beanToMap(userDTO);
        // [Java] Redis Hash 的 value 必须是 String，再做一层类型转换
        Map<String, String> userMapStr = new HashMap<>();
        for (Map.Entry<String, Object> entry : userMap.entrySet()) {
            // 三元表达式：null → "" 防止空指针
            userMapStr.put(entry.getKey(), entry.getValue() == null ? "" : entry.getValue().toString());
        }
        String tokenKey = LOGIN_USER_KEY + token;  // key = "login:token:f47ac10b..."
        // [Redis] opsForHash().putAll(key, map) = HMSET key field1 val1 field2 val2 ...
        stringRedisTemplate.opsForHash().putAll(tokenKey, userMapStr);
        // [Redis] expire(key, ttl, unit) = EXPIRE key ttl（25天自动过期）
        stringRedisTemplate.expire(tokenKey, RedisConstants.LOGIN_USER_TTL, TimeUnit.MINUTES);

        return Result.ok(token);           // [项目] 返回 token 给前端
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

        // [Redis] 校验验证码
        String cacheCode = stringRedisTemplate.opsForValue().get(LOGIN_CODE_KEY + phone);
        String code = loginForm.getCode();
        if (cacheCode == null || !cacheCode.equals(code)) {
            throw new BizException(ErrorCode.LOGIN_CODE_ERROR, "验证码错误");
        }
        stringRedisTemplate.delete(LOGIN_CODE_KEY + phone);  // [Redis] 用完即删

        // [MP] 检查手机号是否已注册
        User existing = query().eq("phone", phone).one();
        if (existing != null) {
            throw new BizException(ErrorCode.USER_ALREADY_EXIST, "该手机号已注册");
        }

        User user = new User();
        user.setPhone(phone);
        // [Hutool] BCrypt.hashpw(明文, BCrypt.gensalt()) = 生成加盐哈希密码
        //   gensalt() = 自动生成随机盐，每次结果不同
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        String nickName = loginForm.getNickName();
        if (nickName != null && !nickName.trim().isEmpty()) {
            user.setNickName(nickName.trim());
        } else {
            // [Hutool] RandomUtil.randomString(10) = 随机10位字母数字
            user.setNickName(USER_NICK_NAME_PREFIX + RandomUtil.randomString(10));
        }
        save(user);                          // [MP] save() = INSERT 到 tb_user

        return Result.ok();
    }

    @Override
    public Result updateProfile(ProfileUpdateDTO dto) {
        // [项目] UserHolder.getUser() = 从 ThreadLocal 获取当前登录用户
        UserDTO userDTO = UserHolder.getUser();
        if (userDTO == null) {
            throw new BizException(ErrorCode.UNAUTHORIZED, "请先登录");
        }
        Long userId = userDTO.getId();

        // --- 更新 tb_user 表（昵称和头像）---
        String nickName = dto.getNickName();
        if (nickName != null && !nickName.trim().isEmpty()) {
            nickName = nickName.trim();
            // [MP] lambdaUpdate() = LambdaUpdateChainWrapper
            //   .set(User::getNickName, value) = SET nick_name = value
            //   .eq(User::getId, id)          = WHERE id = ?
            //   .update()                     = 执行 UPDATE
            lambdaUpdate().set(User::getNickName, nickName).eq(User::getId, userId).update();
        }

        String icon = dto.getIcon();
        if (icon != null) {
            lambdaUpdate().set(User::getIcon, icon).eq(User::getId, userId).update();
        }

        // --- 更新 tb_user_info 表（详细信息）---
        // [MP] getById(id) = SELECT * FROM tb_user_info WHERE id = ?
        UserInfo userInfo = userInfoService.getById(userId);
        if (userInfo == null) {
            userInfo = new UserInfo();
            userInfo.setUserId(userId);
        }
        if (dto.getCity() != null) userInfo.setCity(dto.getCity());
        if (dto.getIntroduce() != null) userInfo.setIntroduce(dto.getIntroduce());
        if (dto.getGender() != null) userInfo.setGender(dto.getGender());
        if (dto.getBirthday() != null) userInfo.setBirthday(dto.getBirthday());

        // [MP] saveOrUpdate = 存在则 UPDATE，不存在则 INSERT（根据主键判断）
        userInfoService.saveOrUpdate(userInfo);

        return Result.ok();
    }
}
