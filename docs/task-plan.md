# MedQueue 医疗预约挂号平台 — 任务计划完成时间表

## Phase 1 — 基础平台（MVP，约11天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 1.1 | 设计并新建 medqueue 数据库，编写全部建表 SQL | `src/main/resources/db/medqueue.sql` | 1天 | 无 |
| 1.2 | 项目环境搭建 | — | 0.5天 | 无 |
| 1.3 | 配置 application.yaml（数据源、Redis） | `src/main/resources/application.yaml` | 0.5天 | 1.1 |
| 1.4 | 编写实体类 Hospital/Department/AppointmentItem/DoctorSchedule/AppointmentRecord/MedicalReview | `entity/` 6个文件 | 1天 | 1.1 |
| 1.5 | 新增实体 Doctor, PatientProfile | `entity/Doctor.java`, `entity/PatientProfile.java` | 0.5天 | 1.4 |
| 1.6 | Mapper接口 + XML映射文件 | `mapper/` + `resources/mapper/` | 0.5天 | 1.4, 1.5 |
| 1.7 | 实现 HospitalServiceImpl（含三级缓存策略） | `service/impl/HospitalServiceImpl.java` | 1天 | 1.4, 1.6 |
| 1.8 | 实现 DepartmentServiceImpl（Redis List缓存） | `service/impl/DepartmentServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 1.9 | 实现 DoctorServiceImpl（按医院/科室查询医生） | `service/impl/DoctorServiceImpl.java` | 0.5天 | 1.5, 1.6 |
| 1.10 | 实现 PatientProfileServiceImpl（就诊人CRUD） | `service/impl/PatientProfileServiceImpl.java` | 0.5天 | 1.5, 1.6 |
| 1.11 | 实现预约核心逻辑（Redis+Lua原子扣号源+异步写库） | `service/impl/AppointmentRecordServiceImpl.java` | 1.5天 | 1.4, 1.6 |
| 1.12 | 编写预约扣号源 Lua 脚本 | `resources/appointment.lua` | 0.5天 | 1.11 |
| 1.13 | 实现排班初始化（启动时同步号源到Redis） | `service/impl/ScheduleServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 1.14 | 编写 Controller + 配置MvcConfig拦截器路径 | `controller/` + `config/MvcConfig.java` | 1天 | 1.7~1.13 |
| 1.15 | 配置常量类 + 上传路径 | `utils/RedisConstants.java`, `utils/SystemConstants.java` | 0.5天 | 1.4 |
| 1.16 | Phase 1 整体联调测试 | — | 1天 | 1.14, 1.15 |

## Phase 2 — 增强功能（约4.5天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 2.1 | Redis GEO 附近医院搜索 | `service/impl/HospitalServiceImpl.java` | 1天 | 1.7 |
| 2.2 | 就医评价发表+列表 | `service/impl/MedicalReviewServiceImpl.java` | 1天 | 1.4, 1.6 |
| 2.3 | 取消预约+号源回退 | `service/impl/AppointmentRecordServiceImpl.java` | 0.5天 | 1.11, 1.12 |
| 2.4 | 关注功能实现 | `service/impl/FollowServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 2.5 | 评价点赞（Redis Set防重复） | `controller/ReviewController.java` | 0.5天 | 2.2 |
| 2.6 | Phase 2 整体联调测试 | — | 1天 | 2.1~2.5 |

## Phase 3 — 收尾（约2天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 3.1 | 用户登出（清除Redis Token） | `UserController.java` | 0.5天 | — |
| 3.2 | 全局异常体系（BizException + ErrorCode） | `config/WebExceptionAdvice.java`, `common/` | 0.5天 | 无 |
| 3.3 | 最终全量接口测试 | — | 1天 | 3.1, 3.2 |

## Phase 4 — 前后端联调修复（约2天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 |
|------|----------|----------|----------|
| 4.1 | 拦截器路径修复：补充公开端点排除 | `config/MvcConfig.java` | 0.3天 |
| 4.2 | 分页接口修复：返回完整 Page 对象 | `HospitalServiceImpl`, `DoctorServiceImpl`, `ReviewController`, `HospitalController` | 0.5天 |
| 4.3 | AppointmentRecordController 支持分页 + status 过滤 | `AppointmentRecordController`, `IAppointmentRecordService`, `AppointmentRecordServiceImpl` | 0.3天 |
| 4.4 | FollowController 返回关联医院/医生数据 | `FollowController` | 0.3天 |
| 4.5 | 前端补充缺失 API 方法 + 修复调用 | `api/`, `views/` | 0.3天 |

---

## 总计

| 阶段 | 天数 |
|------|------|
| Phase 1 — 基础平台 | ~11天 |
| Phase 2 — 增强功能 | ~4.5天 |
| Phase 3 — 收尾 | ~2天 |
| Phase 4 — 前后端联调修复 | ~2天 |
| **总计** | **~19.5天** |
