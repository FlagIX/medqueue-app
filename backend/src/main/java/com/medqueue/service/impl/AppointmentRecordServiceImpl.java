package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.AppointmentBookingDTO;
import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.AppointmentRecord;
import com.medqueue.entity.Doctor;
import com.medqueue.entity.DoctorSchedule;
import com.medqueue.entity.Hospital;
import com.medqueue.entity.PatientProfile;
import com.medqueue.entity.AppointmentItem;
import com.medqueue.mapper.AppointmentRecordMapper;
import com.medqueue.service.IAppointmentItemService;
import com.medqueue.service.IDoctorScheduleService;
import com.medqueue.service.IDoctorService;
import com.medqueue.service.IHospitalService;
import com.medqueue.service.IPatientProfileService;
import com.medqueue.service.IAppointmentRecordService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;   // [MP] ServiceImpl 基类
import com.medqueue.utils.RedisIdWorker;    // [项目] 全局 ID 生成器（类雪花算法）
import com.medqueue.utils.UserHolder;        // [项目] ThreadLocal 获取当前用户
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;  // [MP] 分页模型
import org.springframework.core.io.ClassPathResource;  // [Spring] 读取 classpath 下的 Lua 脚本文件
import org.springframework.data.redis.core.StringRedisTemplate;       // [Spring] Redis 操作模板
import org.springframework.data.redis.core.script.DefaultRedisScript; // [Spring] Redis Lua 脚本封装
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;       // [Spring] 声明式事务
import javax.annotation.PostConstruct;   // [J2EE] 构造完成后执行初始化方法
import javax.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;  // [Java] 有界阻塞队列：线程安全的生产者-消费者模式
import java.util.concurrent.BlockingQueue;        // [Java] 阻塞队列接口：take() 阻塞等待，add() 入队
import java.util.concurrent.ExecutorService;       // [Java] 线程池接口
import java.util.concurrent.Executors;               // [Java] 线程池工厂：newSingleThreadExecutor()

import static com.medqueue.utils.RedisConstants.APPOINTMENT_ORDER_KEY;  // [项目] Redis 预约订单 Set key
import static com.medqueue.utils.RedisConstants.APPOINTMENT_STOCK_KEY;  // [项目] Redis 号源库存 key

@Service
public class AppointmentRecordServiceImpl extends ServiceImpl<AppointmentRecordMapper, AppointmentRecord> implements IAppointmentRecordService {
    // [MP] ServiceImpl 继承 → 自带 save()/getById()/updateById()/lambdaQuery() 等

    @Resource
    private IDoctorScheduleService doctorScheduleService;  // [Spring] 排班服务
    @Resource
    private IDoctorService doctorService;                  // [Spring] 医生服务
    @Resource
    private IHospitalService hospitalService;              // [Spring] 医院服务
    @Resource
    private IPatientProfileService patientProfileService;  // [Spring] 就诊人服务
    @Resource
    private IAppointmentItemService appointmentItemService; // [Spring] 费用项服务
    @Resource
    private RedisIdWorker redisIdWorker;    // [项目] 全局 ID 生成器：时间戳 + Redis 自增序列
    @Resource
    private StringRedisTemplate stringRedisTemplate;     // [Spring] Redis 操作模板
    // [Java] BlockingQueue = 阻塞队列，用于异步写库（生产者-消费者模式）
    //   容量 1024 * 1024 = 约 100 万条排队上限
    private final BlockingQueue<AppointmentRecord> queue = new ArrayBlockingQueue<>(1024 * 1024);

    // ===================== Redis Lua 脚本加载 =====================
    // [Spring] DefaultRedisScript<Long> = Lua 脚本封装，返回类型为 Long
    private static final DefaultRedisScript<Long> APPOINTMENT_SCRIPT;

    static {
        APPOINTMENT_SCRIPT = new DefaultRedisScript<>();
        // [Spring] ClassPathResource = 从 classpath（resources/）下加载文件
        APPOINTMENT_SCRIPT.setLocation(new ClassPathResource("appointment.lua"));
        // [Spring] 指定返回值类型 → Redis 返回的 Long 自动转换
        APPOINTMENT_SCRIPT.setResultType(Long.class);
    }

    // [Spring] @PostConstruct = 依赖注入完成后自动执行（初始化方法）
    @PostConstruct
    public void initConsumer() {
        // [Java] Executors.newSingleThreadExecutor() = 单线程线程池
        //   保证任务按 FIFO 顺序执行，不会并发写库
        ExecutorService consumer = Executors.newSingleThreadExecutor(r -> {
            // [Java] 自定义线程名：方便定位问题
            Thread t = new Thread(r, "appointment-queue-consumer");
            t.setDaemon(true);  // [Java] 守护线程 → JVM 退出时自动结束
            return t;
        });
        consumer.execute(() -> {
            while (true) {
                try {
                    // [Java] BlockingQueue.take() = 队列为空时阻塞等待，有元素时取出
                    AppointmentRecord record = queue.take();
                    save(record);  // [MP] save() = INSERT 预约记录到数据库
                } catch (InterruptedException e) {
                    // [Java] 线程中断时退出循环
                    Thread.currentThread().interrupt();
                    break;
                } catch (Exception e) {
                    // [Java] 写库异常时等待 1 秒后重试
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException ex) {
                        Thread.currentThread().interrupt();
                        break;
                    }
                }
            }
        });
    }

    @Override
    public Result bookAppointment(AppointmentBookingDTO dto) {
        // --- 参数校验 ---
        if (dto.getScheduleId() == null || dto.getPatientId() == null) {
            throw new BizException(ErrorCode.APPOINTMENT_PARAM_ERROR, "参数错误");
        }

        // [项目] UserHolder.getUser() = 从 ThreadLocal 获取当前登录用户
        UserDTO user = UserHolder.getUser();

        // [MP] getById(id) = 根据排班 ID 查 DoctorSchedule
        DoctorSchedule schedule = doctorScheduleService.getById(dto.getScheduleId());
        if (schedule == null) {
            throw new BizException(ErrorCode.SCHEDULE_NOT_EXIST, "排班不存在");
        }

        // [MP] getById(id) = 根据医生 ID 查 Doctor
        Doctor doctor = doctorService.getById(dto.getDoctorId());
        if (doctor == null) {
            throw new BizException(ErrorCode.DOCTOR_NOT_EXIST, "医生不存在");
        }

        // ===================== ⭐ 核心：Redis + Lua 原子扣号源 =====================
        // [Spring] stringRedisTemplate.execute(脚本, keys, args) 执行 Lua 脚本
        //   keys[0] = 号源库存 key："appointment:stock:{scheduleId}"
        //   keys[1] = 已预约 Set key："appointment:order:{scheduleId}"
        //   args[0] = 用户 ID（String）
        //   脚本返回：0=成功 1=号源不足 2=重复预约
        Long result = stringRedisTemplate.execute(
                APPOINTMENT_SCRIPT,
                Arrays.asList(
                        APPOINTMENT_STOCK_KEY + dto.getScheduleId(),
                        APPOINTMENT_ORDER_KEY + dto.getScheduleId()
                ),
                user.getId().toString()
        );
        int r = result.intValue();
        if (r == 1) {
            throw new BizException(ErrorCode.APPOINTMENT_STOCK_SHORTAGE, "号源不足");
        }
        if (r == 2) {
            throw new BizException(ErrorCode.APPOINTMENT_DUPLICATE, "用户已预约，不可重复预约");
        }

        // [项目] RedisIdWorker.nextId("appointment") = 生成全局唯一订单 ID
        //   类雪花算法：时间戳(32bit) | 序列号(32bit)
        long orderId = redisIdWorker.nextId("appointment");
        AppointmentRecord record = new AppointmentRecord();
        record.setId(orderId);
        record.setUserId(user.getId());
        record.setPatientId(dto.getPatientId());
        record.setDoctorId(dto.getDoctorId());
        record.setScheduleId(dto.getScheduleId());
        record.setHospitalId(doctor.getHospitalId());
        record.setFeeId(schedule.getFeeId());
        // [Java] LocalDate.parse() = 字符串 "2026-06-13" → LocalDate
        record.setAppointDate(LocalDate.parse(dto.getDate()));
        record.setTimeSlot(dto.getTimeSlot());
        record.setStatus(1);  // 1=已预约
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());

        // [Java] BlockingQueue.add() = 入队，由消费者线程异步写入数据库
        //   好处：扣号源（Redis）和写订单（DB）分离，扣库存成功立即返回
        queue.add(record);

        return Result.ok(orderId);
    }

    // ==================== REFERENCE: 分布式锁+同步写库备选方案 ====================
    // 如需切换为分布式锁方案，取消注释此方法，并将 Controller 中的调用改为 createAppointmentRecord
    // 同时确保 RedissonClient、@Transactional 等依赖可用
    // 该方案使用 [Redisson] RLock 分布式锁替代 Redis+Lua 原子扣号源
    // @Override
    // @Transactional                                // [Spring] 数据库事务包裹
    // public Result createAppointmentRecord(AppointmentBookingDTO dto) {
    //     if (dto.getScheduleId() == null || dto.getPatientId() == null) {
    //         return Result.fail("参数错误");
    //     }
    //
    //     Long userId = UserHolder.getUser().getId();
    //     RLock lock = redissonClient.getLock("lock:appointment:" + dto.getScheduleId());  // [Redisson] 分布式锁
    //     try {
    //         lock.lock();   // [Redisson] 阻塞等待锁
    //         long count = lambdaQuery()
    //                 .eq(AppointmentRecord::getUserId, userId)
    //                 .eq(AppointmentRecord::getScheduleId, dto.getScheduleId())
    //                 .count();
    //         if (count > 0) {
    //             return Result.fail("用户已预约，不可重复预约");
    //         }
    //
    //         boolean success = doctorScheduleService.update()
    //                 .setSql("remain_count = remain_count - 1")   // [MP] SET remain_count = remain_count - 1
    //                 .eq("schedule_id", dto.getScheduleId())
    //                 .gt("remain_count", 0)
    //                 .update();
    //         if (!success) {
    //             return Result.fail("号源不足");
    //         }
    //
    //         DoctorSchedule schedule = doctorScheduleService.getById(dto.getScheduleId());
    //         Doctor doctor = doctorService.getById(dto.getDoctorId());
    //
    //         long orderId = redisIdWorker.nextId("appointment");
    //         AppointmentRecord record = new AppointmentRecord();
    //         record.setId(orderId);
    //         record.setUserId(userId);
    //         record.setPatientId(dto.getPatientId());
    //         record.setDoctorId(dto.getDoctorId());
    //         record.setScheduleId(dto.getScheduleId());
    //         record.setHospitalId(doctor != null ? doctor.getHospitalId() : null);
    //         record.setFeeId(schedule != null ? schedule.getFeeId() : null);
    //         record.setAppointDate(LocalDate.parse(dto.getDate()));
    //         record.setTimeSlot(dto.getTimeSlot());
    //         record.setStatus(1);
    //         record.setCreateTime(LocalDateTime.now());
    //         record.setUpdateTime(LocalDateTime.now());
    //         save(record);
    //
    //         return Result.ok(orderId);
    //     } finally {
    //         lock.unlock();  // [Redisson] 释放锁
    //     }
    // }

    @Override
    public Result queryDetail(Long id, Long userId) {
        // [MP] getById(id) = SELECT * FROM appointment_record WHERE id = ?
        AppointmentRecord record = getById(id);
        if (record == null) {
            throw new BizException(ErrorCode.APPOINTMENT_NOT_EXIST, "预约记录不存在");
        }
        // 权限校验：只能查看自己的预约
        if (!record.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.APPOINTMENT_VIEW_FORBIDDEN, "无权查看该记录");
        }

        // [Java] 手动组装返回的 Map（非 DTO，灵活拼接）
        Map<String, Object> detail = new HashMap<>();
        detail.put("id", record.getId());
        detail.put("appointDate", record.getAppointDate());
        detail.put("timeSlot", record.getTimeSlot());
        detail.put("status", record.getStatus());
        detail.put("createTime", record.getCreateTime());

        // [MP] 关联查询医院名称（一对一）
        if (record.getHospitalId() != null) {
            Hospital hospital = hospitalService.getById(record.getHospitalId());
            detail.put("hospitalName", hospital != null ? hospital.getName() : null);
        }
        // [MP] 关联查询医生
        if (record.getDoctorId() != null) {
            Doctor doctor = doctorService.getById(record.getDoctorId());
            if (doctor != null) {
                detail.put("doctorName", doctor.getName());
                detail.put("doctorTitle", doctor.getTitle());
            }
        }
        // [MP] 关联查询就诊人
        if (record.getPatientId() != null) {
            PatientProfile patient = patientProfileService.getById(record.getPatientId());
            detail.put("patientName", patient != null ? patient.getName() : null);
        }
        // [MP] 关联查询费用项
        if (record.getFeeId() != null) {
            AppointmentItem fee = appointmentItemService.getById(record.getFeeId());
            detail.put("feeTitle", fee != null ? fee.getTitle() : null);
            detail.put("fee", fee != null ? fee.getFee() : null);
        }

        return Result.ok(detail);
    }

    @Override
    public Result queryUserRecords(Long userId, Integer current, Integer pageSize, Integer status) {
        // [MP] lambdaQuery() = LambdaQueryChainWrapper 类型安全的链式查询
        //   .eq(条件, 实体::get字段, 值) = WHERE 字段 = 值（条件为 true 时才拼接）
        //   .orderByDesc(实体::get字段)  = ORDER BY 字段 DESC
        //   .page(new Page<>(current, pageSize)) = 分页查询，自动计算 total
        Page<AppointmentRecord> page = lambdaQuery()
                .eq(AppointmentRecord::getUserId, userId)
                .eq(status != null && status > 0, AppointmentRecord::getStatus, status)
                .orderByDesc(AppointmentRecord::getCreateTime)
                .page(new Page<>(current, pageSize));
        return Result.ok(page);
    }

    @Override
    @Transactional   // [Spring] 开启声明式事务：方法内所有 DB 操作要么全成功要么全回滚
    public Result cancelAppointment(Long id, Long userId) {
        // [MP] getById(id) = SELECT * FROM appointment_record WHERE id = ?
        AppointmentRecord record = getById(id);
        if (record == null) {
            throw new BizException(ErrorCode.APPOINTMENT_NOT_EXIST, "预约记录不存在");
        }
        // 校验：只能取消自己的预约
        if (!record.getUserId().equals(userId)) {
            throw new BizException(ErrorCode.APPOINTMENT_CANCEL_FORBIDDEN, "无权取消该预约");
        }
        // 校验：只有状态为 1（已预约）才能取消
        if (record.getStatus() != 1) {
            throw new BizException(ErrorCode.APPOINTMENT_CANCEL_FORBIDDEN, "当前状态不可取消");
        }

        // 步骤1：更新订单状态为 3（已取消）
        record.setStatus(3);
        record.setUpdateTime(LocalDateTime.now());
        updateById(record);  // [MP] UPDATE appointment_record SET status=3 WHERE id=?

        // 步骤2：回退号源（remain_count + 1）
        // [MP] update() = UpdateChainWrapper 链式更新
        //   .setSql(sql片段) = SET remain_count = remain_count + 1
        //   .eq(字段, 值)    = WHERE schedule_id = ?
        //   .update()        = 执行 UPDATE
        doctorScheduleService.update()
                .setSql("remain_count = remain_count + 1")
                .eq("schedule_id", record.getScheduleId())
                .update();

        return Result.ok();
    }
}
