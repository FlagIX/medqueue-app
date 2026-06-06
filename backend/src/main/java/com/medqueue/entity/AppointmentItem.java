package com.medqueue.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("tb_appointment_item")
public class AppointmentItem implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long hospitalId;

    private String title;

    private Long fee;

    private Integer type;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
