package com.medqueue.dto;

import lombok.Data;

@Data
public class AppointmentBookingDTO {
    private Long doctorId;
    private Long scheduleId;
    private Long patientId;
    private String date;
    private String timeSlot;
}
