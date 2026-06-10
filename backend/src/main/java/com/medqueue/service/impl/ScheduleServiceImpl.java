package com.medqueue.service.impl;

import com.medqueue.dto.Result;
import com.medqueue.entity.DoctorSchedule;
import com.medqueue.mapper.DoctorScheduleMapper;
import com.medqueue.service.IScheduleService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import static com.medqueue.utils.RedisConstants.APPOINTMENT_ORDER_KEY;
import static com.medqueue.utils.RedisConstants.APPOINTMENT_STOCK_KEY;

@Service
public class ScheduleServiceImpl implements IScheduleService {

    private static final Logger log = LoggerFactory.getLogger(ScheduleServiceImpl.class);

    @Resource
    private DoctorScheduleMapper doctorScheduleMapper;
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @PostConstruct
    public void init() {
        log.info("开始同步排班号源到 Redis...（异步）");
        CompletableFuture.runAsync(() -> {
            try {
                Result result = syncAllSchedules();
                log.info("排班号源同步完成：{}", result.getData());
            } catch (Exception e) {
                log.error("排班号源同步异常", e);
            }
        });
    }

    @Override
    public Result syncAllSchedules() {
        QueryWrapper<DoctorSchedule> wrapper = new QueryWrapper<>();
        wrapper.ge("date", LocalDate.now())
                .gt("remain_count", 0);
        List<DoctorSchedule> schedules = doctorScheduleMapper.selectList(wrapper);

        for (DoctorSchedule s : schedules) {
            String stockKey = APPOINTMENT_STOCK_KEY + s.getScheduleId();
            String orderKey = APPOINTMENT_ORDER_KEY + s.getScheduleId();

            stringRedisTemplate.opsForValue().set(stockKey, s.getRemainCount().toString());
            stringRedisTemplate.delete(orderKey);
        }

        log.info("已同步 {} 个排班号源", schedules.size());
        return Result.ok(schedules.size());
    }

    @Override
    public Result syncSchedule(Long scheduleId) {
        DoctorSchedule schedule = doctorScheduleMapper.selectById(scheduleId);
        if (schedule == null) {
            return Result.fail("排班不存在");
        }

        String stockKey = APPOINTMENT_STOCK_KEY + scheduleId;
        String orderKey = APPOINTMENT_ORDER_KEY + scheduleId;

        if (schedule.getRemainCount() > 0) {
            stringRedisTemplate.opsForValue().set(stockKey, schedule.getRemainCount().toString());
        } else {
            stringRedisTemplate.delete(stockKey);
        }
        stringRedisTemplate.delete(orderKey);

        return Result.ok(scheduleId);
    }
}
