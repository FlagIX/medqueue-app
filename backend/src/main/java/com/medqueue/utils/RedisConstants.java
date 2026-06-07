package com.medqueue.utils;

public class RedisConstants {
    public static final String LOGIN_CODE_KEY = "login:code:";
    public static final Long LOGIN_CODE_TTL = 2L;
    public static final String LOGIN_USER_KEY = "login:token:";
    public static final Long LOGIN_USER_TTL = 36000L;

    public static final Long CACHE_NULL_TTL = 2L;

    public static final Long CACHE_HOSPITAL_TTL = 30L;
    public static final String CACHE_HOSPITAL_KEY = "cache:hospital:";
    public static final Long CACHE_DEPARTMENT_TTL = 60L;
    public static final String CACHE_DEPARTMENT_KEY = "cache:department:type";

    public static final String LOCK_HOSPITAL_KEY = "lock:hospital:";
    public static final Long LOCK_HOSPITAL_TTL = 10L;

    public static final Long CACHE_DOCTOR_TTL = 30L;
    public static final String CACHE_DOCTOR_KEY = "cache:doctor:";

    public static final String APPOINTMENT_STOCK_KEY = "appointment:stock:";
    public static final String APPOINTMENT_ORDER_KEY = "appointment:order:";
    public static final String REVIEW_LIKED_KEY = "review:liked:";
    public static final String FOLLOW_FEED_KEY = "follow:feed:";
    public static final String HOSPITAL_GEO_KEY = "hospital:geo:";
    public static final String USER_SIGN_KEY = "user:sign:";
}
