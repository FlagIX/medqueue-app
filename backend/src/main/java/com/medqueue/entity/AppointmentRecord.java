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
@TableName("tb_appointment_record")
public class AppointmentRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.INPUT)
    private Long id;

    private Long userId;

    private Long patientId;

    private Long doctorId;

    private Long scheduleId;

    private Long hospitalId;

    private Long feeId;

    private LocalDate appointDate;

    private String timeSlot;

    private Integer payType;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
