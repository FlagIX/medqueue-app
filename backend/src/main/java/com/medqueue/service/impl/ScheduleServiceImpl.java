package com.medqueue.service.impl;

import com.medqueue.common.BizException;
import com.medqueue.common.ErrorCode;
import com.medqueue.dto.Result;
import com.medqueue.entity.DoctorSchedule;
import com.medqueue.mapper.DoctorScheduleMapper;
import com.medqueue.service.IScheduleService;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;  // [MP] 条件构造器（传统方式）
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.event.ApplicationReadyEvent;  // [Spring] 应用启动完成事件
import org.springframework.context.event.EventListener;                // [Spring] 事件监听
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.util.List;

import static com.medqueue.utils.RedisConstants.APPOINTMENT_ORDER_KEY;
import static com.medqueue.utils.RedisConstants.APPOINTMENT_STOCK_KEY;

@Service
public class ScheduleServiceImpl implements IScheduleService {

    private static final Logger log = LoggerFactory.getLogger(ScheduleServiceImpl.class);

    @Resource
    private DoctorScheduleMapper doctorScheduleMapper;  // [MP] 直接注入 Mapper（不使用 ServiceImpl）
    @Resource
    private StringRedisTemplate stringRedisTemplate;    // [Spring] Redis 操作模板

    // ===================== 启动时初始化：同步数据库号源到 Redis =====================
    // [Spring] @EventListener(ApplicationReadyEvent.class)
    //   → Spring 容器初始化完毕、应用准备就绪后自动执行一次
    //   作用：将数据库中的排班号源同步到 Redis，供预约时 Lua 脚本扣库存
    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        log.info("开始同步排班号源到 Redis...");
        try {
            Result result = syncAllSchedules();
            log.info("排班号源同步完成：{}", result.getData());
        } catch (Exception e) {
            log.error("排班号源同步异常", e);
        }
    }

    @Override
    public Result syncAllSchedules() {
        // [MP] QueryWrapper = 传统条件构造器（非 Lambda 方式）
        QueryWrapper<DoctorSchedule> wrapper = new QueryWrapper<>();
        wrapper.ge("date", LocalDate.now())     // WHERE date >= 今天
                .gt("remain_count", 0);          // AND remain_count > 0（有号源）
        List<DoctorSchedule> schedules = doctorScheduleMapper.selectList(wrapper);  // [MP] 查询列表

        for (DoctorSchedule s : schedules) {
            String stockKey = APPOINTMENT_STOCK_KEY + s.getScheduleId();  // "appointment:stock:{id}"
            String orderKey = APPOINTMENT_ORDER_KEY + s.getScheduleId();  // "appointment:order:{id}"

            // [Redis] opsForValue().set(key, value) = SET key value
            stringRedisTemplate.opsForValue().set(stockKey, s.getRemainCount().toString());
            // [Redis] delete(key) = DEL key（清空旧的预约记录 Set）
            stringRedisTemplate.delete(orderKey);
        }

        log.info("已同步 {} 个排班号源", schedules.size());
        return Result.ok(schedules.size());
    }

    @Override
    public Result syncSchedule(Long scheduleId) {
        // [MP] selectById = 根据主键查一条记录
        DoctorSchedule schedule = doctorScheduleMapper.selectById(scheduleId);
        if (schedule == null) {
            throw new BizException(ErrorCode.SCHEDULE_NOT_EXIST, "排班不存在");
        }

        String stockKey = APPOINTMENT_STOCK_KEY + scheduleId;
        String orderKey = APPOINTMENT_ORDER_KEY + scheduleId;

        if (schedule.getRemainCount() > 0) {
            // [Redis] 更新库存
            stringRedisTemplate.opsForValue().set(stockKey, schedule.getRemainCount().toString());
        } else {
            // [Redis] 无号源则删除 key
            stringRedisTemplate.delete(stockKey);
        }
        stringRedisTemplate.delete(orderKey);  // [Redis] 清空预约记录

        return Result.ok(scheduleId);
    }
}
