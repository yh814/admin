package com.example.admin.controller;

import com.example.admin.dao.ProjectInfoDao;
import com.example.admin.dto.ProjectInfoDto;
import com.example.admin.service.CommonService;
import com.example.admin.service.ProjectInfoService;
import com.google.gson.Gson;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/project")
public class ProjectInfoController {

    private final ProjectInfoDao projectInfoDao;

    private final ProjectInfoService projectInfoService;

    private final CommonService commonService;


    public ProjectInfoController(ProjectInfoDao projectInfoDao, ProjectInfoService projectInfoService, CommonService commonService) {
        this.projectInfoDao = projectInfoDao;
        this.projectInfoService = projectInfoService;
        this.commonService = commonService;
    }

    @GetMapping("/proMain")
    public String getAllPro(Model model) {

        commonService.proCusName(model);
        commonService.proProgressName(model);
        commonService.skillName(model);

        return "project/proMain";
    }

    @GetMapping("/modify")
    public String modify(@RequestParam("proNum")int proNum, Model model) {

        ProjectInfoDto proInfo = projectInfoDao.getOneProInfo(proNum);
        List<String> getSkills = projectInfoDao.selectProSkill(proNum);
        proInfo.setSkillCD(getSkills);
        model.addAttribute("proInfo",proInfo);

        System.out.println(proInfo.getSkillCD());

        String skillCDJson = new Gson().toJson(proInfo.getSkillCD());
        model.addAttribute("skillCDJson", skillCDJson);

        commonService.proCusName(model);
        commonService.proProgressName(model);
        commonService.skillName(model);

        return "project/modify";
    }


}
