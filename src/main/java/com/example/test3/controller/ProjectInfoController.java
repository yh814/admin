package com.example.test3.controller;

import com.example.test3.dao.CodeDao;
import com.example.test3.dao.ProjectInfoDao;
import com.example.test3.dto.CodeDetailDto;
import com.example.test3.dto.PageDto;
import com.example.test3.dto.ProjectInfoDto;
import com.example.test3.service.ProjectInfoService;
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

    private final CodeDao codeDao;


    public ProjectInfoController(ProjectInfoDao projectInfoDao, ProjectInfoService projectInfoService, CodeDao codeDao) {
        this.projectInfoDao = projectInfoDao;
        this.projectInfoService = projectInfoService;
        this.codeDao = codeDao;
    }

    @GetMapping("/proMain")
    public String getAllPro(@RequestParam(value = "page", defaultValue = "1") int page, Model model) {
        List<ProjectInfoDto> allPro = projectInfoService.allProList(page);

        for(ProjectInfoDto pro: allPro) {
            List<String> skills = projectInfoDao.selectProSkill(pro.getProNum());
            pro.setSkillDetailNameList(skills);
        }
        model.addAttribute("allPro", allPro);

        PageDto pageBean = projectInfoService.getAllProCount(page);
        model.addAttribute("pageBean", pageBean);

        //고객사코드
        String cusName="CD006";
        List<CodeDetailDto> cusList= codeDao.getDetailName(cusName);
        model.addAttribute("cusList", cusList);

        //재직상태
        String progressName="CD007";
        List<CodeDetailDto> progressList = codeDao.getDetailName(progressName);
        model.addAttribute("progressList",progressList);

        //필요기술
        String skillName = "CD009";
        List<CodeDetailDto> skillList = codeDao.getDetailName(skillName);
        model.addAttribute("skillList",skillList);

        return "project/proMain";
    }


}
