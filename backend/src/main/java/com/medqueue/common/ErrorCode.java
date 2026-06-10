package com.medqueue.common;

/**
 * 业务错误码定义
 * 1xxx=系统通用  2xxx=认证授权  3xxx=参数校验
 * 4xxx=用户/就诊人  5xxx=医院/科室/医生  6xxx=预约/文件
 */
public class ErrorCode {

    // ========== 1xxx 系统通用 ==========
    public static final int SUCCESS = 200;
    public static final int SYSTEM_ERROR = 1000;
    public static final int NOT_FOUND = 1001;

    // ========== 2xxx 认证授权 ==========
    public static final int UNAUTHORIZED = 2001;
    public static final int LOGIN_CODE_ERROR = 2002;
    public static final int LOGIN_PASSWORD_ERROR = 2003;
    public static final int USER_NOT_EXIST = 2004;
    public static final int USER_ALREADY_EXIST = 2005;
    public static final int PHONE_FORMAT_ERROR = 2006;

    // ========== 3xxx 参数校验 ==========
    public static final int PARAM_ERROR = 3000;
    public static final int PARAM_FORMAT_ERROR = 3001;
    public static final int ID_CARD_FORMAT_ERROR = 3002;
    public static final int PASSWORD_FORMAT_ERROR = 3003;

    // ========== 4xxx 用户/就诊人 ==========
    public static final int PATIENT_NOT_EXIST = 4001;
    public static final int PATIENT_ID_CARD_BOUND = 4002;
    public static final int PATIENT_DELETE_FORBIDDEN = 4003;

    // ========== 5xxx 医院/科室/医生 ==========
    public static final int HOSPITAL_NOT_EXIST = 5001;
    public static final int HOSPITAL_ID_REQUIRED = 5002;
    public static final int DEPARTMENT_NOT_EXIST = 5003;
    public static final int DOCTOR_NOT_EXIST = 5004;
    public static final int SCHEDULE_NOT_EXIST = 5005;

    // ========== 6xxx 预约/文件 ==========
    public static final int APPOINTMENT_PARAM_ERROR = 6001;
    public static final int APPOINTMENT_STOCK_SHORTAGE = 6002;
    public static final int APPOINTMENT_DUPLICATE = 6003;
    public static final int APPOINTMENT_NOT_EXIST = 6004;
    public static final int APPOINTMENT_CANCEL_FORBIDDEN = 6005;
    public static final int APPOINTMENT_VIEW_FORBIDDEN = 6006;
    public static final int FILE_UPLOAD_ERROR = 6007;
    public static final int FILE_NAME_ERROR = 6008;
}
