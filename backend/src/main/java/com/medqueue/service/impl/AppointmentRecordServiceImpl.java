package com.medqueue.service.impl;

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
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.RedisIdWorker;
import com.medqueue.utils.UserHolder;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static com.medqueue.utils.RedisConstants.APPOINTMENT_ORDER_KEY;
import static com.medqueue.utils.RedisConstants.APPOINTMENT_STOCK_KEY;

@Service
public class AppointmentRecordServiceImpl extends ServiceImpl<AppointmentRecordMapper, AppointmentRecord> implements IAppointmentRecordService {

    @Resource
    private IDoctorScheduleService doctorScheduleService;
    @Resource
    private IDoctorService doctorService;
    @Resource
    private IHospitalService hospitalService;
    @Resource
    private IPatientProfileService patientProfileService;
    @Resource
    private IAppointmentItemService appointmentItemService;
    @Resource
    private RedisIdWorker redisIdWorker;
    @Resource
    private StringRedisTemplate stringRedisTemplate;
    private final BlockingQueue<AppointmentRecord> queue = new ArrayBlockingQueue<>(1024 * 1024);

    private static final DefaultRedisScript<Long> APPOINTMENT_SCRIPT;

    static {
        APPOINTMENT_SCRIPT = new DefaultRedisScript<>();
        APPOINTMENT_SCRIPT.setLocation(new ClassPathResource("appointment.lua"));
        APPOINTMENT_SCRIPT.setResultType(Long.class);
    }

    @PostConstruct
    public void initConsumer() {
        ExecutorService consumer = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "appointment-queue-consumer");
            t.setDaemon(true);
            return t;
        });
        consumer.execute(() -> {
            while (true) {
                try {
                    AppointmentRecord record = queue.take();
                    save(record);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                } catch (Exception e) {
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
        if (dto.getScheduleId() == null || dto.getPatientId() == null) {
            return Result.fail("参数错误");
        }

        UserDTO user = UserHolder.getUser();

        DoctorSchedule schedule = doctorScheduleService.getById(dto.getScheduleId());
        if (schedule == null) {
            return Result.fail("排班不存在");
        }

        Doctor doctor = doctorService.getById(dto.getDoctorId());
        if (doctor == null) {
            return Result.fail("医生不存在");
        }

        Long result = stringRedisTemplate.execute(
                APPOINTMENT_SCRIPT,
                Arrays.asList(APPOINTMENT_STOCK_KEY + dto.getScheduleId(),
                        APPOINTMENT_ORDER_KEY + dto.getScheduleId()),
                user.getId().toString()
        );
        int r = result.intValue();
        if (r != 0) {
            return Result.fail(r == 1 ? "号源不足" : "用户已预约，不可重复预约");
        }

        long orderId = redisIdWorker.nextId("appointment");
        AppointmentRecord record = new AppointmentRecord();
        record.setId(orderId);
        record.setUserId(user.getId());
        record.setPatientId(dto.getPatientId());
        record.setDoctorId(dto.getDoctorId());
        record.setScheduleId(dto.getScheduleId());
        record.setHospitalId(doctor.getHospitalId());
        record.setFeeId(schedule.getFeeId());
        record.setAppointDate(LocalDate.parse(dto.getDate()));
        record.setTimeSlot(dto.getTimeSlot());
        record.setStatus(1);
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());

        queue.add(record);

        return Result.ok(orderId);
    }

    // ==================== REFERENCE: 分布式锁+同步写库备选方案 ====================
    // 如需切换为分布式锁方案，取消注释此方法，并将 Controller 中的调用改为 createAppointmentRecord
    // 同时确保 RedissonClient、@Transactional 等依赖可用
    // @Override
    // @Transactional
    // public Result createAppointmentRecord(AppointmentBookingDTO dto) {
    //     if (dto.getScheduleId() == null || dto.getPatientId() == null) {
    //         return Result.fail("参数错误");
    //     }
    //
    //     Long userId = UserHolder.getUser().getId();
    //     RLock lock = redissonClient.getLock("lock:appointment:" + dto.getScheduleId());
    //     try {
    //         lock.lock();
    //         long count = lambdaQuery()
    //                 .eq(AppointmentRecord::getUserId, userId)
    //                 .eq(AppointmentRecord::getScheduleId, dto.getScheduleId())
    //                 .count();
    //         if (count > 0) {
    //             return Result.fail("用户已预约，不可重复预约");
    //         }
    //
    //         boolean success = doctorScheduleService.update()
    //                 .setSql("remain_count = remain_count - 1")
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
    //         lock.unlock();
    //     }
    // }

    @Override
    public Result queryDetail(Long id, Long userId) {
        AppointmentRecord record = getById(id);
        if (record == null) {
            return Result.fail("预约记录不存在");
        }
        if (!record.getUserId().equals(userId)) {
            return Result.fail("无权查看该记录");
        }

        Map<String, Object> detail = new HashMap<>();
        detail.put("id", record.getId());
        detail.put("appointDate", record.getAppointDate());
        detail.put("timeSlot", record.getTimeSlot());
        detail.put("status", record.getStatus());
        detail.put("createTime", record.getCreateTime());

        // 关联查询医院
        if (record.getHospitalId() != null) {
            Hospital hospital = hospitalService.getById(record.getHospitalId());
            detail.put("hospitalName", hospital != null ? hospital.getName() : null);
        }
        // 关联查询医生
        if (record.getDoctorId() != null) {
            Doctor doctor = doctorService.getById(record.getDoctorId());
            if (doctor != null) {
                detail.put("doctorName", doctor.getName());
                detail.put("doctorTitle", doctor.getTitle());
            }
        }
        // 关联查询就诊人
        if (record.getPatientId() != null) {
            PatientProfile patient = patientProfileService.getById(record.getPatientId());
            detail.put("patientName", patient != null ? patient.getName() : null);
        }
        // 关联查询费用项
        if (record.getFeeId() != null) {
            AppointmentItem fee = appointmentItemService.getById(record.getFeeId());
            detail.put("feeTitle", fee != null ? fee.getTitle() : null);
            detail.put("fee", fee != null ? fee.getFee() : null);
        }

        return Result.ok(detail);
    }

    @Override
    public Result queryUserRecords(Long userId, Integer current, Integer pageSize, Integer status) {
        Page<AppointmentRecord> page = lambdaQuery()
                .eq(AppointmentRecord::getUserId, userId)
                .eq(status != null && status > 0, AppointmentRecord::getStatus, status)
                .orderByDesc(AppointmentRecord::getCreateTime)
                .page(new Page<>(current, pageSize));
        return Result.ok(page);
    }

    @Override
    @Transactional
    public Result cancelAppointment(Long id, Long userId) {
        AppointmentRecord record = getById(id);
        if (record == null) {
            return Result.fail("预约记录不存在");
        }
        if (!record.getUserId().equals(userId)) {
            return Result.fail("无权取消该预约");
        }
        if (record.getStatus() != 1) {
            return Result.fail("当前状态不可取消");
        }

        record.setStatus(3);
        record.setUpdateTime(LocalDateTime.now());
        updateById(record);

        doctorScheduleService.update()
                .setSql("remain_count = remain_count + 1")
                .eq("schedule_id", record.getScheduleId())
                .update();

        return Result.ok();
    }
}
