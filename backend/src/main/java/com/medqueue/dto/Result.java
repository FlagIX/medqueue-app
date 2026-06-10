package com.medqueue.dto;

import com.medqueue.common.ErrorCode;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result {
    private Boolean success;
    private Integer code;
    private String errorMsg;
    private Object data;
    private Long total;

    public static Result ok(){
        return new Result(true, ErrorCode.SUCCESS, null, null, null);
    }
    public static Result ok(Object data){
        return new Result(true, ErrorCode.SUCCESS, null, data, null);
    }
    public static Result ok(List<?> data, Long total){
        return new Result(true, ErrorCode.SUCCESS, null, data, total);
    }
    public static Result fail(int code, String errorMsg){
        return new Result(false, code, errorMsg, null, null);
    }
}
