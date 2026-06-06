# MedQueue 医疗预约挂号平台 — 任务计划完成时间表

## Phase 1 — 基础平台（MVP，约11天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 1.1 | 新建 medqueue 数据库，编写全部建表 SQL | `src/main/resources/db/medqueue.sql` | 1天 | 无 |
| 1.2 | IDE全局重构包名 com.hmdp → com.medqueue | 全部文件 | 0.5天 | 无 |
| 1.3 | 修改 application.yaml（数据库名、Redis配置） | `src/main/resources/application.yaml` | 0.5天 | 1.1 |
| 1.4 | 实体类重命名+字段调整：Hospital/Department/AppointmentItem/DoctorSchedule/AppointmentRecord/MedicalReview | `entity/` 6个文件 | 1天 | 1.1, 1.2 |
| 1.5 | 新增实体 Doctor, PatientProfile | `entity/Doctor.java`, `entity/PatientProfile.java` | 0.5天 | 1.4 |
| 1.6 | Mapper接口 + XML映射文件调整 | `mapper/` 6个文件 + `resources/mapper/` | 0.5天 | 1.4, 1.5 |
| 1.7 | 改造 HospitalServiceImpl（原ShopServiceImpl，含三级缓存策略） | `service/impl/HospitalServiceImpl.java` | 1天 | 1.4, 1.6 |
| 1.8 | 实现 DepartmentServiceImpl（原ShopTypeServiceImpl，Redis List缓存） | `service/impl/DepartmentServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 1.9 | 实现 DoctorServiceImpl（按医院/科室查询医生） | `service/impl/DoctorServiceImpl.java` | 0.5天 | 1.5, 1.6 |
| 1.10 | 实现 PatientProfileServiceImpl（就诊人CRUD） | `service/impl/PatientProfileServiceImpl.java` | 0.5天 | 1.5, 1.6 |
| 1.11 | 改造 AppointmentServiceImpl（原VoucherOrderServiceImpl，核心预约逻辑） | `service/impl/AppointmentServiceImpl.java` | 1.5天 | 1.4, 1.6 |
| 1.12 | 改造 Lua 脚本（seckill.lua → appointment.lua，修改Key名） | `resources/lua/appointment.lua` | 0.5天 | 1.11 |
| 1.13 | 改造排班初始化（原VoucherServiceImpl，同步号源到Redis） | `service/impl/ScheduleServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 1.14 | 改造/新增Controller + 调整MvcConfig拦截器路径 | `controller/` + `config/MvcConfig.java` | 1天 | 1.7~1.13 |
| 1.15 | 调整常量类（RedisConstants Key名称）+ SystemConstants上传路径 | `utils/RedisConstants.java`, `utils/SystemConstants.java` | 0.5天 | 1.4 |
| 1.16 | Phase 1 整体联调测试 | — | 1天 | 1.14, 1.15 |

## Phase 2 — 增强功能（约4.5天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 2.1 | Redis GEO 附近医院搜索 | `service/impl/HospitalServiceImpl.java` | 1天 | 1.7 |
| 2.2 | 就医评价发表+列表（ReviewServiceImpl补全） | `service/impl/ReviewServiceImpl.java` | 1天 | 1.4, 1.6 |
| 2.3 | 取消预约+号源回退Lua | `service/impl/AppointmentServiceImpl.java` + Lua | 0.5天 | 1.11, 1.12 |
| 2.4 | 关注功能补全（FollowServiceImpl） | `service/impl/FollowServiceImpl.java` | 0.5天 | 1.4, 1.6 |
| 2.5 | 评价点赞（Redis Set防重复） | `service/impl/ReviewServiceImpl.java` | 0.5天 | 2.2 |
| 2.6 | Phase 2 整体联调测试 | — | 1天 | 2.1~2.5 |

## Phase 3 — 收尾（约2天）

| 序号 | 任务内容 | 涉及文件 | 预估时间 | 前置依赖 |
|------|----------|----------|----------|---------|
| 3.1 | 用户登出（清除Redis Token） | `UserController.java`, `UserServiceImpl.java` | 0.5天 | 1.2 |
| 3.2 | 全局异常完善（业务异常码） | `config/WebExceptionAdvice.java` | 0.5天 | 无 |
| 3.3 | 最终全量接口测试 | — | 1天 | 3.1, 3.2 |

---

## 总计

| 阶段 | 天数 |
|------|------|
| Phase 1 — 基础平台 | ~11天 |
| Phase 2 — 增强功能 | ~4.5天 |
| Phase 3 — 收尾 | ~2天 |
| **总计** | **~17.5天** |
