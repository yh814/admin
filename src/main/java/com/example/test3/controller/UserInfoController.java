package com.example.test3.controller;

import com.example.test3.dao.CodeDao;
import com.example.test3.dao.UserInfoDao;
import com.example.test3.dto.CodeDetailDto;
import com.example.test3.dto.PageDto;
import com.example.test3.dto.UserInfoDto;
import com.example.test3.service.UserInfoService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/user")
public class UserInfoController {

    @Resource(name = "loginUser")
    private UserInfoDto loginUser;

    private final UserInfoService userInfoService;

    private final UserInfoDao userInfoDao;

    private final CodeDao codeDao;

    public UserInfoController(UserInfoService userInfoService,UserInfoDao userInfoDao, CodeDao codeDao){
        this.userInfoService = userInfoService;
        this.userInfoDao = userInfoDao;
        this.codeDao = codeDao;
    }

    @PostMapping("/login_pro")
    public String loginpro(@RequestParam("id") String userId, @RequestParam("password") String userPw , RedirectAttributes redirectAttributes) {

        UserInfoDto userInfo = userInfoService.loginIdPw(userId, userPw);

        if(userInfo != null && userId.equals(userInfo.getUserId()) && userPw.equals(userInfo.getUserPw())) {
            loginUser.setUserId(userInfo.getUserId());
            loginUser.setUserName(userInfo.getUserName());

            return "redirect:/board/homePage";
        } else {
            redirectAttributes.addFlashAttribute("loginError", "Invalid ID or Password");
            return "redirect:/login";
        }
    }

    @GetMapping("/allUserInfo")
    public String getAllUserInfo(@ModelAttribute("userInfoBean") UserInfoDto userInfoBean, @RequestParam(value = "page", defaultValue = "1") int page, Model model) {
        // 전체 사용자 정보를 가져옴
        List<UserInfoDto> allUser = userInfoService.getAllUserInfoDetail(page);

        for (UserInfoDto user : allUser) {
            List<String> skills = userInfoDao.selectUserSkills(user.getUserNum());
            user.setSkillDetailNameList(skills);
        }
        model.addAttribute("allUser", allUser);

        PageDto pageBean = userInfoService.getAllUserCount(page);
        model.addAttribute("pageBean", pageBean);

        // 기술등급, 재직상태, 스킬
        String gradeName = "CD004";
        List<CodeDetailDto> gradeList = codeDao.getDetailName(gradeName);
        model.addAttribute("gradeList", gradeList);

        String conStatusName = "CD005";
        List<CodeDetailDto> conStatusList = codeDao.getDetailName(conStatusName);
        model.addAttribute("conStatusList", conStatusList);

        String statusName = "CD002";
        List<CodeDetailDto> statusList = codeDao.getDetailName(statusName);
        model.addAttribute("statusList", statusList);

        String skillName = "CD009";
        List<CodeDetailDto> skillList = codeDao.getDetailName(skillName);
        model.addAttribute("skillList", skillList);

        // 성별, 직급
        String sexName = "CD001";
        List<CodeDetailDto> sexList = codeDao.getDetailName(sexName);
        model.addAttribute("sexList", sexList);

        String userRankName = "CD003";
        List<CodeDetailDto> userRankList = codeDao.getDetailName(userRankName);
        model.addAttribute("userRankList", userRankList);

        return "user/allUserInfo";
    }

    @GetMapping("/modify")
    public String modify(@RequestParam("userNum")int userNum, Model model) {

        UserInfoDto userInfo = userInfoDao.getOneUserInfo(userNum);
        model.addAttribute(userInfo);

        model.addAttribute("userInfoBean", new UserInfoDto());
        //성별
        String sexName = "CD001";
        List<CodeDetailDto> sexList = codeDao.getDetailName(sexName);
        model.addAttribute("sexList", sexList);

        //재직상태
        String statusName="CD002";
        List<CodeDetailDto> statusList = codeDao.getDetailName(statusName);
        model.addAttribute("statusList",statusList);

        //직급
        String userRankName = "CD003";
        List<CodeDetailDto> userRankList = codeDao.getDetailName(userRankName);
        model.addAttribute("userRankList", userRankList);

        //기술등급
        String gradeName="CD004";
        List<CodeDetailDto> gradeList= codeDao.getDetailName(gradeName);
        model.addAttribute("gradeList", gradeList);

        //기술등급
        String conStatusName="CD005";
        List<CodeDetailDto> conStatusList= codeDao.getDetailName(conStatusName);
        model.addAttribute("conStatusList", conStatusList);

        //스킬
        String skillName= "CD009";
        List<CodeDetailDto> skillList = codeDao.getDetailName(skillName);
        model.addAttribute("skillList", skillList);



        return "user/modify";
    }


}
