package com.medqueue.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class AppointmentRecordDTO {
    private Long id;
    private Long userId;
    private Long patientId;
    private Long doctorId;
    private Long scheduleId;
    private Long hospitalId;
    private Long feeId;
    private Integer status;
    private LocalDate appointDate;
    private String timeSlot;
    private Integer payType;
    private LocalDateTime createTime;

    private String doctorName;
    private String doctorTitle;
    private String hospitalName;
    private String patientName;
    private String feeTitle;
}
