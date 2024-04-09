package com.example.admin.controller;

import com.example.admin.dao.MatchProDao;
import com.example.admin.dao.UserInfoDao;
import com.example.admin.dto.MatchProDto;
import com.example.admin.dto.ProjectInfoDto;
import com.example.admin.dto.UserInfoDto;
import com.example.admin.service.CommonService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/match")
public class MatchController {

    private final MatchProDao matchProDao;

    private final UserInfoDao userInfoDao;
    private final CommonService commonService;

    public MatchController(MatchProDao matchProDao, UserInfoDao userInfoDao, CommonService commonService){
        this.matchProDao = matchProDao;
        this.userInfoDao = userInfoDao;
        this.commonService = commonService;
    }

    @GetMapping("/userMatch")
    public String getUserProject(@RequestParam("userNum")int userNum, @RequestParam(value = "page", defaultValue = "1") int page,
                                 Model model){

        UserInfoDto userMatchInfo = matchProDao.getMatchUserInfo(userNum);
        model.addAttribute("userMatchInfo",userMatchInfo);

        List<MatchProDto> userProList = matchProDao.getOneUserPros(userNum);
        model.addAttribute("userProList", userProList);

        commonService.proCusName(model);
        commonService.proProgressName(model);
        commonService.matchRoleName(model);

        List<ProjectInfoDto> allProList = matchProDao.matchAllProList(userNum);
        for(ProjectInfoDto pro: allProList) {
            int userCnt=matchProDao.countUser(pro.getProNum());
            pro.setUserCnt(userCnt);
        }
        model.addAttribute("allProList",allProList);


        return "match/userMatch";
    }

    @GetMapping("/proMatch")
    public String getUserProject(@RequestParam("proNum")int proNum, Model model){

        ProjectInfoDto proMatchInfo = matchProDao.getMatchProInfo(proNum);
        model.addAttribute("proMatchInfo",proMatchInfo);

        List<MatchProDto> proUserList = matchProDao.getOneProUsers(proNum);
        model.addAttribute("proUserList", proUserList);

        commonService.userStatusName(model);
        commonService.userRankName(model);
        commonService.userGradeName(model);
        commonService.proProgressName(model);
        commonService.matchRoleName(model);
        commonService.skillName(model);

        List<UserInfoDto> allUserList = matchProDao.matchAllUserList(proNum);
        for(UserInfoDto user : allUserList) {
            List<String> skills = userInfoDao.selectUserSkills(user.getUserNum());
            user.setSkillDetailNameList(skills);
        }

        model.addAttribute("allUserList", allUserList);

        return "match/proMatch";
    }


}
