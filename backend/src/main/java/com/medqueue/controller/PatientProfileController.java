package com.medqueue.controller;

import com.medqueue.dto.Result;
import com.medqueue.dto.UserDTO;
import com.medqueue.entity.PatientProfile;
import com.medqueue.service.IPatientProfileService;
import com.medqueue.utils.UserHolder;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/patient-profile")
public class PatientProfileController {

    @Resource
    private IPatientProfileService patientProfileService;

    @PostMapping
    public Result addPatientProfile(@RequestBody PatientProfile profile) {
        UserDTO user = UserHolder.getUser();
        profile.setUserId(user.getId());
        patientProfileService.save(profile);
        return Result.ok(profile.getId());
    }

    @GetMapping("/my")
    public Result queryMyProfiles() {
        UserDTO user = UserHolder.getUser();
        return Result.ok(patientProfileService.query().eq("user_id", user.getId()).list());
    }

    @PutMapping
    public Result updatePatientProfile(@RequestBody PatientProfile profile) {
        patientProfileService.updateById(profile);
        return Result.ok();
    }

    @DeleteMapping("/{id}")
    public Result deletePatientProfile(@PathVariable("id") Long id) {
        patientProfileService.removeById(id);
        return Result.ok();
    }
}
