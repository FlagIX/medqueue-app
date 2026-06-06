package com.medqueue.service.impl;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.DoctorSchedule;
import com.medqueue.entity.AppointmentRecord;
import com.medqueue.mapper.AppointmentRecordMapper;
import com.medqueue.service.IDoctorScheduleService;
import com.medqueue.service.IAppointmentRecordService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.RedisIdWorker;
import com.medqueue.utils.UserHolder;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.aop.framework.AopContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

import static com.medqueue.utils.RedisConstants.SECKILL_STOCK_KEY;

@Service
public class AppointmentRecordServiceImpl extends ServiceImpl<AppointmentRecordMapper, AppointmentRecord> implements IAppointmentRecordService {

    @Resource
    private IDoctorScheduleService doctorScheduleService;
    @Resource
    private RedisIdWorker redisIdWorker;
    @Resource
    private StringRedisTemplate stringRedisTemplate;
    @Resource
    private RedissonClient redissonClient;

    private BlockingQueue<AppointmentRecord> orderQueue = new ArrayBlockingQueue<>(1024 * 1024);

    private static final DefaultRedisScript<Long> SECKILL_SCRIPT;

    static {
        SECKILL_SCRIPT = new DefaultRedisScript<>();
        SECKILL_SCRIPT.setLocation(new ClassPathResource("seckill.lua"));
        SECKILL_SCRIPT.setResultType(Long.class);
    }

    @Override
    public Result bookAppointment(Long scheduleId) {
        UserDTO user = UserHolder.getUser();
        Long userId = user.getId();
        Long result = stringRedisTemplate.execute(
                SECKILL_SCRIPT,
                Arrays.asList(SECKILL_STOCK_KEY + scheduleId, "seckill:order:" + scheduleId),
                userId.toString()
        );
        int r = result.intValue();
        if (r != 0) {
            return Result.fail(r == 1 ? "号源不足" : "用户已预约，不可重复预约");
        }

        AppointmentRecord record = new AppointmentRecord();
        long orderId = redisIdWorker.nextId("order");
        record.setId(orderId);
        record.setUserId(userId);
        record.setScheduleId(scheduleId);

        orderQueue.add(record);

        return Result.ok(orderId);
    }

    @Transactional
    public Result createAppointmentRecord(Long scheduleId) {
        Long userId = UserHolder.getUser().getId();
        int count = query().eq("user_id", userId).eq("schedule_id", scheduleId).count();
        if (count > 0) {
            return Result.fail("用户已经预约过一次！");
        }
        boolean success = doctorScheduleService.update()
                .setSql("remain_count = remain_count - 1")
                .eq("schedule_id", scheduleId)
                .gt("remain_count", 0)
                .update();
        if (!success) {
            return Result.fail("号源不足");
        }
        AppointmentRecord record = new AppointmentRecord();
        long orderId = redisIdWorker.nextId("order");
        record.setId(orderId);
        record.setUserId(userId);
        record.setScheduleId(scheduleId);
        save(record);
        return Result.ok(orderId);
    }
}
