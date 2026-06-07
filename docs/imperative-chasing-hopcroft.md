# MedQueue 医疗预约挂号平台 — 项目设计文档

> 基于 hm-dianping（大众点评克隆）魔改的全新项目，用于大三找实习的简历项目

---

## 一、项目概述

### 定位
一个基于 Spring Boot 的医疗预约挂号平台后端，提供医院/医生信息查询、号源管理、在线预约挂号、就医评价等核心功能。

### 技术栈
- Spring Boot 2.7.18 + MyBatis Plus 3.5.3.1 + MySQL 8.0 + Redis + Redisson
- Java 17，Lombok 1.18.30，Hutool

### 简历卖点
1. **Redis+Lua 原子扣号源防超卖** — 高并发预约场景下的库存准确性保证
2. **三级缓存策略** — 缓存穿透（空值缓存）、缓存击穿（逻辑过期/互斥锁）
3. **Redis GEO 附近医院搜索** — 基于地理位置的医院查询
4. **Redisson 分布式锁** — 分布式环境下防重复预约
5. **全局 ID 生成器** — 类雪花算法，时间戳+Redis自增序列

---

## 二、包结构

```
com.medqueue
├── controller/
│   ├── HospitalController.java        — 医院相关接口
│   ├── DepartmentController.java      — 科室查询接口
│   ├── DoctorController.java          — 医生信息/排班接口
│   ├── AppointmentController.java     — 预约挂号接口（核心）
│   ├── AppointmentItemController.java — 挂号费用标准管理
│   ├── PatientProfileController.java  — 就诊人管理接口
│   ├── ReviewController.java          — 就医评价接口
│   ├── FollowController.java          — 关注医院/医生接口
│   ├── UserController.java            — 用户登录注册
│   └── UploadController.java          — 图片上传
├── service/           — 业务接口层
│   ├── IHospitalService.java
│   ├── IDepartmentService.java
│   ├── IDoctorService.java
│   ├── IAppointmentService.java
│   ├── IAppointmentItemService.java
│   ├── IPatientProfileService.java
│   ├── IReviewService.java
│   └── IFollowService.java
├── service/impl/      — 业务实现层
├── mapper/            — MyBatis Plus Mapper
├── entity/            — 数据库实体
├── dto/               — 数据传输对象（Result, LoginFormDTO, ScrollResult, UserDTO）
├── config/            — 配置类
├── utils/             — 工具类（CacheClient, RedisIdWorker, 拦截器等）
└── resources/
    ├── mapper/        — XML 映射文件
    ├── lua/           — Redis Lua 脚本
    └── db/            — SQL 初始化脚本
```

---

## 三、数据库设计

### 3.1 tb_hospital（医院 — 原 tb_shop）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键，自增 |
| name | varchar(128) | 医院名称 |
| department_id | bigint | 所属科室分类ID |
| images | varchar(1024) | 医院图片 |
| area | varchar(64) | 区域（如"浦东新区"） |
| address | varchar(256) | 详细地址 |
| x | double | 经度 |
| y | double | 纬度 |
| level | varchar(16) | 医院等级（三甲/三乙/二甲/社区医院等） |
| phone | varchar(16) | 联系电话 |
| open_hours | varchar(32) | 就诊时间 |
| score | int | 评分（1-50，即0.1-5.0分） |
| review_count | int | 评价数 |
| create_time | datetime | 创建时间 |
| update_time | datetime | 更新时间 |

### 3.2 tb_department（科室 — 原 tb_shop_type）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| name | varchar(32) | 科室名称（内科/外科/儿科/妇产科等） |
| icon | varchar(256) | 图标 |
| sort | int | 排序号 |
| create_time | datetime | 创建时间 |
| update_time | datetime | 更新时间 |

### 3.3 tb_doctor（医生 — 新增）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| hospital_id | bigint | 所属医院ID |
| department_id | bigint | 所属科室ID |
| name | varchar(32) | 医生姓名 |
| title | varchar(32) | 职称（主任医师/副主任医师/主治医师/住院医师） |
| avatar | varchar(256) | 头像URL |
| introduction | text | 医生简介 |
| score | int | 评分 |
| appointment_count | int | 累计挂号数 |
| create_time | datetime | |
| update_time | datetime | |

### 3.4 tb_appointment_item（挂号费用标准 — 原 tb_voucher）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| hospital_id | bigint | 医院ID |
| title | varchar(32) | 标题（普通号/专家号/特需号） |
| fee | bigint | 费用（单位：分） |
| type | tinyint | 类型（1普通/2专家/3特需） |
| status | tinyint | 状态（1启用/0停用） |
| create_time | datetime | |
| update_time | datetime | |

### 3.5 tb_doctor_schedule（医生排班 — 原 tb_seckill_voucher）

| 字段 | 类型 | 说明 |
|------|------|------|
| schedule_id | bigint PK | 排班ID |
| doctor_id | bigint | 医生ID |
| date | date | 出诊日期 |
| time_slot | varchar(8) | 时段（上午/下午/晚班） |
| total_count | int | 总号源数 |
| remain_count | int | 剩余号源数 |
| fee_id | bigint | 费用标准ID |
| begin_time | datetime | 预约开始时间 |
| end_time | datetime | 预约结束时间 |
| create_time | datetime | |
| update_time | datetime | |

### 3.6 tb_appointment_record（挂号记录 — 原 tb_voucher_order）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 订单号（Redis ID生成器） |
| user_id | bigint | 用户ID |
| patient_id | bigint | 就诊人ID |
| doctor_id | bigint | 医生ID |
| schedule_id | bigint | 排班ID |
| hospital_id | bigint | 医院ID |
| fee_id | bigint | 费用标准ID |
| status | tinyint | 状态（1待就诊/2已就诊/3已取消/4已过期） |
| appoint_date | date | 预约日期 |
| time_slot | varchar(8) | 预约时段 |
| pay_type | tinyint | 支付方式（1余额/2支付宝/3微信） |
| create_time | datetime | |
| update_time | datetime | |

### 3.7 tb_patient_profile（就诊人 — 新增）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| user_id | bigint | 用户ID |
| name | varchar(32) | 就诊人姓名 |
| id_card | varchar(18) | 身份证号 |
| phone | varchar(11) | 手机号 |
| relation | varchar(16) | 关系（本人/配偶/父母/子女/其他） |
| create_time | datetime | |
| update_time | datetime | |

### 3.8 tb_medical_review（就医评价 — 原 tb_blog）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| hospital_id | bigint | 医院ID |
| doctor_id | bigint | 医生ID |
| user_id | bigint | 用户ID |
| rating | int | 评分（1-50） |
| content | text | 评价内容 |
| liked | int | 点赞数 |
| status | tinyint | 状态（1正常/0隐藏） |
| create_time | datetime | |
| update_time | datetime | |

### 3.9 tb_follow（关注 — 原 tb_follow）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | bigint PK | 主键 |
| user_id | bigint | 用户ID |
| follow_id | bigint | 关注对象ID（医院ID或医生ID） |
| follow_type | tinyint | 类型（0医院/1医生） |
| create_time | datetime | |

### 其他表（复用）
- `tb_user` — 用户表，不变
- `tb_user_info` — 用户扩展信息，不变
- `tb_review_comment`（原 tb_blog_comments）— 评价回复

---

## 四、核心业务流程

### 4.1 预约挂号流程（核心亮点）

```
用户操作流程：
  浏览科室 → 查看医院 → 选择医生 → 查看排班 → 选择时段 → 选择就诊人 → 确认预约

技术实现：
                                   ┌─────────────────────────┐
                                   │  Redis Lua 脚本         │
                                   │  ① HGET schedule:{id}   │
                                   │     检查 remain > 0     │
                                   │  ② SISMEMBER            │
                                   │     schedule:booked:{id} │
                                   │     检查是否已预约      │
                                   │  ③ HINCRBY remain -1   │
                                   │  ④ SADD booked {userId} │
                                   └──────┬──────────────────┘
                                          │
                                  返回结果码
                                  0=成功 / 1=号源不足 / 2=重复预约
                                          │
                                   ┌──────┴──────┐
                                   │  结果=0?    │
                                   └──────┬──────┘
                                          │ 是
                                   ┌──────┴──────┐
                                   │  订单入队     │
                                   │  BlockingQueue│
                                   │  → 异步写DB  │
                                   └─────────────┘
```

**防超卖原理**：Redis 单线程执行 Lua 脚本，保证检查库存和扣减的原子性。

**Redis Key 设计**：
- `schedule:remain:{scheduleId}` → Hash，存排班信息+剩余号源
- `schedule:booked:{scheduleId}` → Set，已预约的用户ID集合

### 4.2 附近医院搜索

```
启动时/新增医院时：
  GEOADD hospital:geo {x} {y} {hospitalId}

查询附近医院：
  GEORADIUS hospital:geo {lng} {lat} {radius} km WITHDIST
  → 获取医院ID列表 + 距离
  → 查询数据库补充医院详情
```

### 4.3 三级缓存策略（复用 CacheClient）

**医院详情缓存**：
- 查询：`cache:shop:{id}` → `cache:hospital:{id}`
- 穿透保护：缓存空值 2分钟
- 击穿保护：逻辑过期方案（高可用，返回旧数据 + 异步刷新）

### 4.4 取消预约 + 号源回退

```
PUT /api/appointment/{id}/cancel
  → 验证订单属于当前用户
  → 验证订单状态为"待就诊"
  → Redis Lua 原子操作：回退号源 + 移除预约记录
  → 更新数据库状态为"已取消"
```

### 4.5 就医评价

```
发表评价：
  POST /api/review
  → 查询是否已就诊（未就诊不能评价）
  → 写入 tb_medical_review
  → 更新 tb_hospital 的 score（加权平均）和 review_count

评价列表：
  GET /api/review/page?hospitalId={id}&current=1
  → 分页查询 + 填充用户昵称/头像

点赞：
  PUT /api/review/like/{id}
  → Redis Set 记录点赞用户 → 防重复点赞 → 更新数据库
```

### 4.6 关注医院/医生

```
关注：POST /api/follow/{id}?type=0
  → Redis SADD 用户关注集合（用于快速判断是否已关注）
  → DB 写入 tb_follow

取关：DELETE /api/follow/{id}?type=0
  → Redis SREM + DB 删除

关注列表：GET /api/follow/list?type=0&current=1
  → 分页查询 + 医院/医生信息填充
```

---

## 五、API 接口总览

### 医院
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/hospital/{id} | 医院详情（Redis三级缓存） |
| GET | /api/hospital/page | 分页查询（按科室/名称） |
| GET | /api/hospital/nearby | 附近医院（Redis GEO） |
| PUT | /api/hospital | 更新医院信息 |

### 科室
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/department/list | 科室列表（Redis List缓存） |

### 医生
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /api/doctor/page | 医生列表（按医院/科室） |
| GET | /api/doctor/{id} | 医生详情 |
| GET | /api/doctor/{id}/schedule | 医生排班视图 |

### 预约
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/appointment | 创建预约（Redis+Lua核心） |
| GET | /api/appointment/list | 我的预约列表 |
| PUT | /api/appointment/{id}/cancel | 取消预约 |

### 就诊人
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/patient | 添加就诊人 |
| GET | /api/patient/list | 就诊人列表 |
| DELETE | /api/patient/{id} | 删除就诊人 |

### 评价
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/review | 发表评价 |
| GET | /api/review/page | 评价列表 |
| PUT | /api/review/like/{id} | 点赞 |

### 关注
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/follow/{id} | 关注 |
| DELETE | /api/follow/{id} | 取关 |
| GET | /api/follow/list | 关注列表 |

### 用户
| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /api/user/code | 发送验证码 |
| POST | /api/user/login | 登录 |
| POST | /api/user/logout | 登出 |
| GET | /api/user/me | 当前用户信息 |

---

## 六、Redis Key 设计

| Key | 类型 | 用途 | TTL |
|-----|------|------|-----|
| `login:code:{phone}` | String | 登录验证码 | 2min |
| `login:token:{token}` | Hash | 用户登录态 | 30天 |
| `cache:hospital:{id}` | String | 医院详情（JSON） | 30min |
| `cache:department:list` | List | 科室列表 | 30天 |
| `schedule:remain:{id}` | Hash | 排班号源 | 排班结束 |
| `schedule:booked:{id}` | Set | 已预约用户 | 排班结束 |
| `hospital:geo` | GEO | 医院坐标 | 永久 |
| `review:liked:{id}` | Set | 评价点赞用户 | 永久 |
| `follow:user:{userId}:type:{type}` | Set | 用户关注集 | 永久 |
| `lock:schedule:{id}` | String | 分布式锁 | 10s |

---

## 七、分阶段实施

### Phase 1 — 基础平台（MVP）

**目标**：把现有功能迁移到医疗场景，核心预约流程跑通

| 顺序 | 内容 | 说明 |
|------|------|------|
| 1 | 新建 medqueue 数据库，导入 SQL | 所有新表的建表语句 |
| 2 | IDE一键重构包名 `com.hmdp` → `com.medqueue` | 全部文件统一换包名 |
| 3 | 修改 `application.yaml` | 数据库名、Redis配置 |
| 4 | 重命名实体类 | Shop→Hospital, ShopType→Department, Voucher→AppointmentItem, SeckillVoucher→DoctorSchedule, VoucherOrder→AppointmentRecord, Blog→MedicalReview |
| 5 | 新增实体 | Doctor, PatientProfile |
| 6 | 修改实体字段 | 按上面数据库设计调整字段 |
| 7 | 修改 Mapper + XML | 对应实体变更 |
| 8 | 修改 Service 层 | ShopServiceImpl→HospitalServiceImpl（含缓存）, ShopTypeServiceImpl→DepartmentServiceImpl, VoucherOrderServiceImpl→AppointmentServiceImpl（预约核心逻辑） |
| 9 | 新增 Service | DoctorServiceImpl, PatientProfileServiceImpl |
| 10 | 修改 Controller | 对应改名，新增 DoctorController, PatientProfileController |
| 11 | 改造 Lua 脚本 | seckill.lua→appointment.lua, 调整 Key 名 |
| 12 | 修改常量类 | RedisConstants 调整 Key 名称 |
| 13 | 修改拦截器配置 | MvcConfig 调整路径白名单 |
| 14 | 启动验证 | 完整跑通预约流程 |

### Phase 2 — 增强功能

| 顺序 | 内容 |
|------|------|
| 1 | Redis GEO 附近医院搜索 |
| 2 | 就医评价（ReviewService 补全 BlogService 空壳） |
| 3 | 关注医院（FollowService 补全） |
| 4 | 取消预约 + 号源回退 |
| 5 | 评价点赞（防重复点赞 Redis Set） |

### Phase 3 — 收尾

| 顺序 | 内容 |
|------|------|
| 1 | 用户登出功能 |
| 2 | 全局异常完善 |
| 3 | 整体接口测试 |

---

## 八、启动方式

```bash
# 前置依赖
MySQL localhost:3306, 数据库 medqueue（Connector/J 8.0.33, driver: com.mysql.cj.jdbc.Driver）
Redis localhost:6379, database 2, password: 123456

# 后端启动（跳过测试）
cd backend && mvn spring-boot:run

# 前端启动
cd frontend && npm run dev

# 端口
后端 8081，前端 3000（Vite 代理 /api → localhost:8081）
```

---

## 九、面试准备提示

面试官可能会问的问题：

1. **预约挂号怎么防超卖？**
   → Redis Lua 脚本原子扣减号源，单线程执行保证无竞态条件

2. **为什么不用 MySQL 行锁？**
   → 行锁在高并发下性能瓶颈明显，Redis 内存操作吞吐量高一个数量级

3. **异步写库丢数据怎么办？**
   → BlockingQueue + 消费者线程，可在消费者加重试机制 + 异常日志告警

4. **医院缓存怎么设计的？**
   → 三级策略：空值缓存防穿透、逻辑过期防击穿、互斥锁兜底

5. **附近医院怎么实现的？**
   → Redis GEO 数据结构，`GEORADIUS` 命令按距离排序
