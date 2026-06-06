package com.medqueue.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("tb_doctor_schedule")
public class DoctorSchedule implements Serializable {

    @TableId(value = "schedule_id", type = IdType.INPUT)
    private Long scheduleId;

    private Long doctorId;

    private LocalDate date;

    private String timeSlot;

    private Integer totalCount;

    private Integer remainCount;

    private Long feeId;

    private LocalDateTime beginTime;

    private LocalDateTime endTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
