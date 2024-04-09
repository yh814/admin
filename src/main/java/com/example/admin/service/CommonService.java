package com.example.admin.service;

import com.example.admin.dao.CodeDao;
import com.example.admin.dto.CodeDetailDto;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

@Service
public class CommonService {

    private final CodeDao codeDao;

    public CommonService(CodeDao codeDao){
        this.codeDao = codeDao;
    }

    //성별
    public void userSexName(Model model){
        String sexName = "CD001";
        List<CodeDetailDto> sexList = codeDao.getDetailName(sexName);
        model.addAttribute("sexList", sexList);
    }

    //재직상태
    public void userStatusName(Model model){
        String statusName="CD002";
        List<CodeDetailDto> statusList = codeDao.getDetailName(statusName);
        model.addAttribute("statusList",statusList);
    }

    //직급
    public void userRankName(Model model){
        String userRankName = "CD003";
        List<CodeDetailDto> userRankList = codeDao.getDetailName(userRankName);
        model.addAttribute("userRankList", userRankList);
    }

    //기술등급
    public void userGradeName(Model model){
        String gradeName="CD004";
        List<CodeDetailDto> gradeList= codeDao.getDetailName(gradeName);
        model.addAttribute("gradeList", gradeList);
    }

    //계약상태
    public void userConStatusName(Model model){
        String conStatusName="CD005";
        List<CodeDetailDto> conStatusList= codeDao.getDetailName(conStatusName);
        model.addAttribute("conStatusList", conStatusList);
    }

    //고객사코드
    public void proCusName(Model model){
        String cusName="CD006";
        List<CodeDetailDto> cusList= codeDao.getDetailName(cusName);
        model.addAttribute("cusList", cusList);
    }

    //진행상태
    public void proProgressName(Model model){
        String progressName="CD007";
        List<CodeDetailDto> progressList = codeDao.getDetailName(progressName);
        model.addAttribute("progressList",progressList);
    }

    //역할
    public void matchRoleName(Model model){
        String roleName="CD008";
        List<CodeDetailDto> roleList = codeDao.getDetailName(roleName);
        model.addAttribute("roleList",roleList);
    }

    //스킬
    public void skillName(Model model){
        String skillName= "CD009";
        List<CodeDetailDto> skillList = codeDao.getDetailName(skillName);
        model.addAttribute("skillList", skillList);
    }

    public void emailName(Model model){
        String emailName= "CD011";
        List<CodeDetailDto> emailList = codeDao.getDetailName(emailName);
        model.addAttribute("emailList", emailList);
    }

}
