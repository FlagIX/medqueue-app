package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.PatientProfile;
import com.medqueue.service.IPatientProfileService;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/patient")
public class PatientProfileController {

    @Resource
    private IPatientProfileService patientProfileService;

    @PostMapping
    public Result addPatientProfile(@RequestBody PatientProfile profile) {
        UserDTO user = UserHolder.getUser();
        return patientProfileService.addProfile(profile, user.getId());
    }

    @GetMapping("/list")
    public Result queryMyProfiles() {
        UserDTO user = UserHolder.getUser();
        return patientProfileService.queryMyProfiles(user.getId());
    }

    @PutMapping
    public Result updatePatientProfile(@RequestBody PatientProfile profile) {
        return patientProfileService.updateProfile(profile);
    }

    @DeleteMapping("/{id}")
    public Result deletePatientProfile(@PathVariable("id") Long id) {
        UserDTO user = UserHolder.getUser();
        return patientProfileService.deleteProfile(id, user.getId());
    }
}
