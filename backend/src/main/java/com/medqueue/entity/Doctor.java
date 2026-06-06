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
@TableName("tb_doctor")
public class Doctor implements Serializable {

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long hospitalId;

    private Long departmentId;

    private String name;

    private String title;

    private String avatar;

    private String introduction;

    private Integer score;

    private Integer appointmentCount;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
