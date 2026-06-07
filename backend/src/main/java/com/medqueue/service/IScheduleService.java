package com.medqueue.service;

import com.medqueue.dto.Result;

public interface IScheduleService {

    Result syncAllSchedules();

    Result syncSchedule(Long scheduleId);
}
