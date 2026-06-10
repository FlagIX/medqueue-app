package com.medqueue.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("tb_medical_review")
public class MedicalReview implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    private Long hospitalId;

    private Long doctorId;

    private Long userId;

    @TableField(exist = false)
    private String icon;

    @TableField(exist = false)
    private String name;

    @TableField(exist = false)
    @JsonProperty("like")
    private Boolean isLike;

    private String content;

    private Integer liked;

    private Integer rating;

    private Integer status;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
