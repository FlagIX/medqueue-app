# MedQueue 医疗预约挂号平台

本文档为 Claude Code 提供项目指导。

## 项目概述

基于 hm-dianping（大众点评克隆）魔改的医疗预约挂号平台后端，用于大三找实习的简历项目。提供医院/医生信息查询、号源管理、在线预约挂号、就医评价等核心功能。

## 构建与运行

```bash
# 后端构建（跳过测试）
cd backend && mvn clean package -DskipTests

# 后端运行（需要本地 MySQL + Redis）
cd backend && mvn spring-boot:run

# 前端运行
cd frontend && npm run dev
```

## 前置依赖

- **Java 8**（source/target 1.8）
- **MySQL** `localhost:3306`，数据库 `medqueue`
- **Redis** `localhost:6379`，database 1（用作缓存和登录态存储）
- 应用运行在 **8081 端口**

## 技术栈

- Spring Boot 2.3.12.RELEASE
- MyBatis Plus 3.4.3（分页插件）
- MySQL 5.x（connector 5.1.47）
- Redis（Lettuce 客户端 + commons-pool2 连接池）
- Redisson 3.22.0（分布式锁）
- Lombok、Hutool 5.7.17

## 项目结构

```
medqueue/
├── backend/           ← Spring Boot 后端
│   └── src/main/java/com/medqueue/
│       ├── controller/  → REST 接口
│       ├── service/     → 业务接口
│       ├── service/impl/→ 业务实现
│       ├── mapper/      → MyBatis Plus Mapper
│       ├── entity/      → 数据库实体
│       ├── dto/         → 数据传输对象
│       ├── config/      → 配置类
│       └── utils/       → 工具类
├── frontend/          ← Vue 3 前端
│   └── src/
│       ├── views/      → 页面
│       ├── components/ → 公共组件
│       ├── api/        → 接口封装
│       ├── router/     → 路由
│       └── stores/     → 状态管理
└── docs/              ← 文档
```

**关键约定：**
- 所有 API 响应使用统一 `Result` 包装类（`Result.ok()`、`Result.fail()`）
- 实体使用 MyBatis Plus 注解（`@TableName`、`@TableId`）
- Service 接口继承 `IService<Entity>`，实现类继承 `ServiceImpl<Mapper, Entity>`
- Mapper 继承 `BaseMapper<Entity>`
- 复杂 SQL 使用 XML 映射文件，位于 `src/main/resources/mapper/`

## 业务模块

| 模块 | Controller | Service | 说明 |
|------|-----------|---------|------|
| 用户 | UserController | IUserService | 手机验证码登录、Token认证 |
| 就诊人 | PatientProfileController | IPatientProfileService | 就诊人管理（新增） |
| 医院 | HospitalController | IHospitalService | 医院CRUD、Redis缓存、GEO附近搜索 |
| 科室 | DepartmentController | IDepartmentService | 科室列表（Redis缓存） |
| 医生 | DoctorController | IDoctorService | 医生信息、排班查询（新增） |
| 预约 | AppointmentController | IAppointmentService | Redis+Lua原子扣号源、异步写库 |
| 费用标准 | AppointmentItemController | IAppointmentItemService | 挂号费用类型管理 |
| 评价 | ReviewController | IReviewService | 就医评价、评分、点赞 |
| 关注 | FollowController | IFollowService | 关注医院/医生 |

## 项目亮点

1. **Redis+Lua 原子扣号源防超卖** — 高并发预约场景下的库存准确性保证
2. **三级缓存策略** — 缓存穿透（空值缓存）、缓存击穿（逻辑过期/互斥锁）
3. **Redis GEO 附近医院搜索** — 基于地理位置的医院查询
4. **Redisson 分布式锁** — 分布式环境下防重复预约
5. **全局 ID 生成器** — 类雪花算法，时间戳+Redis自增序列

## Agent 行为准则

请严格遵守 `docs/imperative-chasing-hopcroft.md` 中定义的编码原则，特别是：

1. **编码前思考** — 明确说明假设，呈现多种解释，困惑时停下来询问
2. **简洁优先** — 用最少的代码解决问题，不创建过度抽象，不为不可能发生的场景做错误处理
3. **精准修改** — 只碰必须碰的，不清理未造成的混乱，每行修改都可追溯到用户请求
4. **目标驱动执行** — 定义可验证的成功标准，循环验证直到达成

## 文档

参见 `docs/` 目录：
- `docs/requirements-analysis.md` — 需求分析表
- `docs/task-plan.md` — 任务计划完成时间表
- `docs/imperative-chasing-hopcroft.md` — 编码原则（Agent 行为准则）
- `docs/AGENTS.md` — Agent 协作规范
