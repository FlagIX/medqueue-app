
<p align="center">
  <h1 align="center">🏥 MedQueue 医疗预约挂号平台</h1>
  <p align="center">
    基于 Spring Boot + Vue 3 的在线医疗预约挂号系统
    <br />
    支持医院/医生信息查询、号源管理、在线预约挂号、就医评价等核心功能
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Java-17-blue" alt="Java 17"/>
  <img src="https://img.shields.io/badge/Spring%20Boot-2.7.18-brightgreen" alt="Spring Boot 2.7.18"/>
  <img src="https://img.shields.io/badge/MyBatis%20Plus-3.5.3-blueviolet" alt="MyBatis Plus 3.5.3"/>
  <img src="https://img.shields.io/badge/Redis-7.0-red" alt="Redis 7.0"/>
  <img src="https://img.shields.io/badge/MySQL-8.0-orange" alt="MySQL 8.0"/>
  <img src="https://img.shields.io/badge/Vue-3.5-brightgreen" alt="Vue 3.5"/>
  <img src="https://img.shields.io/badge/Vite-8.0-yellow" alt="Vite 8.0"/>
</p>

---

## 📋 功能模块

| 模块 | 功能 | 说明 |
|------|------|------|
| 👤 **用户** | 手机验证码登录/密码登录、注册、Token 认证、登出（清除 Redis Token） | 支持密码+验证码双模式 |
| 🏥 **医院** | 医院 CRUD、科室筛选分页、Redis 三级缓存（穿透/击穿处理）、GEO 附近搜索 | 按距离排序，返回距离字段 |
| 📋 **科室** | 科室列表（Redis List 缓存） | 带排序，空值缓存防穿透 |
| 👨‍⚕️ **医生** | 医生信息、按医院/科室筛选、排班查询 | 支持未来 7 天号源查看 |
| 📅 **预约挂号** | Redis+Lua 原子扣号源、异步写库、防重复预约、取消预约号源回退 | ⭐ **核心亮点** |
| 💰 **费用标准** | 挂号费用类型管理（普通号/专家号/特需号） | 按医院配置 |
| 👥 **就诊人** | 就诊人 CRUD、身份证校验、防重复绑定 | 支持多就诊人管理 |
| ⭐ **评价** | 发表评价、分页查看、Redis Set 点赞/取消点赞 | Toggle 操作 |
| ❤️ **关注** | 关注/取消关注医院或医生、关注列表 | 支持多种关注类型 |

## ✨ 项目亮点

### 1️⃣ Redis+Lua 原子扣号源防超卖

高并发预约场景下，通过 Lua 脚本保证扣减号源和判断重复预约的**原子性操作**，从根本上避免超卖问题。

```lua
-- 预约扣号源 Lua 脚本（简化）
local stock = redis.call('get', KEYS[1])
if stock == nil or stock <= 0 then return 1 end   -- 号源不足
local isMember = redis.call('sismember', KEYS[2], ARGV[1])
if isMember == 1 then return 2 end                -- 重复预约
redis.call('incrby', KEYS[1], -1)                 -- 扣减号源
redis.call('sadd', KEYS[2], ARGV[1])              -- 记录预约用户
return 0                                           -- 预约成功
```

预约成功后通过**异步 BlockingQueue 写库**，减轻数据库写入压力，提升接口响应速度。

### 2️⃣ 三级缓存策略

采用**缓存穿透 + 缓存击穿双重防护**策略：

- **缓存穿透防御**：查询不存在的数据时，缓存空值（短 TTL），避免恶意请求穿透到数据库
- **缓存击穿防御**：热点数据采用**逻辑过期 + 互斥锁**方案，保证高并发下仅一个线程重建缓存，其他请求返回旧数据

### 3️⃣ Redis GEO 附近医院搜索

利用 Redis GEO 数据结构存储医院经纬度，实现**基于地理位置的医院搜索**，按距离排序并返回距离字段。

### 4️⃣ Redisson 分布式锁

在取消预约等需要事务一致性的场景下，使用 Redisson 分布式锁确保**并发安全**，防止号源回退出现数据不一致。

### 5️⃣ 全局 ID 生成器

类雪花算法实现全局唯一 ID 生成器：**时间戳（41位）+ Redis 自增序列（23位）**，支持按天分 Key，保证 ID 趋势递增。

### 6️⃣ 统一业务异常体系

全局 `BizException` + `ErrorCode` 细粒度错误码（28 个），覆盖认证授权、参数校验、业务拒绝等场景，前端可根据 code 编程化处理。

## 🛠 技术栈

### 后端

| 技术 | 版本 | 用途 |
|------|------|------|
| Java | 17 | 开发语言 |
| Spring Boot | 2.7.18 | 框架 |
| MyBatis Plus | 3.5.3.1 | ORM |
| MySQL | 8.0 | 关系型数据库 |
| Redis | 7.0 (Lettuce + pool2) | 缓存/分布式锁/原子操作 |
| Redisson | 3.22.0 | 分布式锁 |
| Lombok | 1.18.30 | 代码简化 |
| Hutool | 5.7.17 | 工具类库 |

### 前端

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.5.34 | 框架 |
| Vite | 8.0 | 构建工具 |
| Element Plus | 2.14.1 | UI 组件库 |
| Pinia | 3.0.4 | 状态管理 |
| Axios | 1.17.0 | HTTP 请求 |
| Vue Router | 4.6.4 | 路由 |

## 🚀 快速启动

### 前置依赖

- **Java 17** + Maven
- **MySQL 8.0**（本地 `localhost:3306`）
- **Redis 7.0**（本地 `localhost:6379`）

### 1️⃣ 初始化数据库

```bash
# 创建数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS medqueue DEFAULT CHARSET utf8mb4;"

# 导入表结构和示例数据
mysql -u root -p medqueue < backend/src/main/resources/db/medqueue.sql
```

### 2️⃣ 启动 Redis

```bash
redis-server
```

### 3️⃣ 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端运行在 `http://localhost:8081`

### 4️⃣ 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端运行在 `http://localhost:3000`

### 5️⃣ 访问项目

- 用户端：`http://localhost:3000`
- 管理端：`http://localhost:3000/admin/login`

### 测试账号

| 角色 | 手机号/账号 | 密码 |
|------|------------|------|
| 普通用户 | 13686869696 | 验证码登录（控制台查看） |
| 管理员 | admin | admin123 |

## 📁 项目结构

```
medqueue/
├── backend/                          # Spring Boot 后端
│   └── src/main/java/com/medqueue/
│       ├── common/                   # 通用（BizException, ErrorCode）
│       ├── config/                   # 配置（MyBatis, Redis, MVC, 异常处理）
│       ├── controller/               # REST 接口
│       ├── dto/                      # 数据传输对象
│       ├── entity/                   # 数据库实体
│       ├── mapper/                   # MyBatis Mapper
│       ├── service/                  # 业务接口 & 实现
│       └── utils/                    # 工具类（缓存、ID 生成、拦截器）
├── frontend/                         # Vue 3 前端
│   └── src/
│       ├── api/                      # API 封装
│       ├── components/               # 公共组件
│       ├── router/                   # 路由
│       ├── stores/                   # Pinia 状态管理
│       ├── utils/                    # 工具函数
│       └── views/                    # 页面（user/ + admin/）
└── docs/                             # 文档
```

## 📄 数据库设计

| 表名 | 说明 | 关键字段 |
|------|------|---------|
| `tb_user` | 用户表 | phone, password, nick_name |
| `tb_user_info` | 用户扩展信息 | city, introduce, gender, birthday |
| `tb_hospital` | 医院表 | name, level, x/y(经纬度), score |
| `tb_department` | 科室表 | name, sort |
| `tb_doctor` | 医生表 | name, title, hospital_id, department_id |
| `tb_doctor_schedule` | 排班表 | doctor_id, date, time_slot, total/remain_count |
| `tb_appointment_record` | 预约记录 | user/patient/doctor/schedule_id, status |
| `tb_appointment_item` | 费用标准 | title, fee(分), type(普通/专家/特需) |
| `tb_medical_review` | 评价表 | user/hospital/doctor_id, rating, content |
| `tb_follow` | 关注表 | user_id, follow_id, follow_type |
| `tb_patient_profile` | 就诊人表 | name, id_card, phone, relation |
