package com.medqueue.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.medqueue.dto.LoginFormDTO;
import com.medqueue.dto.ProfileUpdateDTO;
import com.medqueue.dto.Result;
import com.medqueue.entity.User;

import javax.servlet.http.HttpSession;

public interface IUserService extends IService<User> {

    Result sendCode(String phone, HttpSession session);

    Result login(LoginFormDTO loginForm, HttpSession session);

    Result register(LoginFormDTO loginForm);

    Result updateProfile(ProfileUpdateDTO profileUpdate);
}
