package com.example.test3.controller;

import com.example.test3.dao.CodeDao;
import com.example.test3.dao.MatchProDao;
import com.example.test3.dto.*;
import com.example.test3.service.MatchProService;
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

    private final MatchProService matchProService;

    private final CodeDao codeDao;

    public MatchController(MatchProDao matchProDao, MatchProService matchProService, CodeDao codeDao){
        this.matchProDao = matchProDao;
        this.matchProService = matchProService;
        this.codeDao = codeDao;
    }

    @GetMapping("/userMatch")
    public String getUserProject(@RequestParam("userNum")int userNum, @RequestParam(value = "page", defaultValue = "1") int page,
                                 Model model){

        UserInfoDto userMatchInfo = matchProDao.getMatchUserInfo(userNum);
        model.addAttribute("userMatchInfo",userMatchInfo);

        List<MatchProDto> userProList = matchProDao.getOneUserPros(userNum);
        model.addAttribute("userProList", userProList);

        String cusName = "CD006";
        List<CodeDetailDto> cusList = codeDao.getDetailName(cusName);
        model.addAttribute("cusList", cusList);

        String progressName = "CD007";
        List<CodeDetailDto> progressList = codeDao.getDetailName(progressName);
        model.addAttribute("progressList", progressList);

        List<ProjectInfoDto> allProList = matchProService.matchAllProList(userNum, page);
        for(ProjectInfoDto pro: allProList) {
            int userCnt=matchProDao.countUser(pro.getProNum());
            model.addAttribute("userCnt",userCnt);
        }
        model.addAttribute("allProList",allProList);

        PageDto pageBean = matchProService.matchAllProListCnt(userNum, page);
        model.addAttribute("pageBean", pageBean);

        return "match/userMatch";
    }




}
