package com.example.admin.controller;

import com.example.admin.dao.UserInfoDao;
import com.example.admin.dto.UserInfoDto;
import com.example.admin.service.CommonService;
import com.example.admin.service.UserInfoService;
import com.google.gson.Gson;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserInfoController {

    private final UserInfoService userInfoService;

    private final UserInfoDao userInfoDao;

    private final CommonService commonService;

    public UserInfoController(UserInfoService userInfoService,UserInfoDao userInfoDao, CommonService commonService){
        this.userInfoService = userInfoService;
        this.userInfoDao = userInfoDao;
        this.commonService = commonService;
    }

    @PostMapping("/login_pro")
    public String loginpro(@RequestParam("id") String userId, @RequestParam("password") String userPw , HttpServletRequest request, RedirectAttributes redirectAttributes, Model model) {

        UserInfoDto userInfo = userInfoService.loginIdPw(userId, userPw);

        if(userInfo != null && userId.equals(userInfo.getUserId()) && userPw.equals(userInfo.getUserPw())) {
            HttpSession session = request.getSession();
            session.setAttribute("userInfo", userInfo);
            return "redirect:/board/homePage";
        } else {
            redirectAttributes.addFlashAttribute("loginError", "Invalid ID or Password");
            return "redirect:/login";
        }
    }

    @GetMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest request){
        HttpSession session = request.getSession(false);
        if(session != null){
            session.invalidate();
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/allUserInfo")
    public String getAllUserInfo(@RequestParam(value = "page", defaultValue = "1") int page, Model model) {

        // 기술등급, 재직상태, 스킬
        commonService.userSexName(model);
        commonService.userStatusName(model);
        commonService.userRankName(model);
        commonService.userGradeName(model);
        commonService.userConStatusName(model);
        commonService.skillName(model);
        commonService.emailName(model);

        return "user/allUserInfo";
    }

    @GetMapping("/modify")
    public String modify(@RequestParam("userNum")int userNum,  Model model) {

        UserInfoDto userInfo = userInfoDao.getOneUserInfo(userNum);
        List<String> getSkills = userInfoDao.selectUserSkills(userNum);
        userInfo.setSkillCD(getSkills);
        model.addAttribute("userInfo",userInfo);

        System.out.println(userInfo.getSkillCD());

        String skillCDJson = new Gson().toJson(userInfo.getSkillCD());
        model.addAttribute("skillCDJson", skillCDJson);

        // 기술등급, 재직상태, 스킬
        commonService.userSexName(model);
        commonService.userStatusName(model);
        commonService.userRankName(model);
        commonService.userGradeName(model);
        commonService.userConStatusName(model);
        commonService.skillName(model);
        commonService.emailName(model);

        return "user/modify";
    }

    @GetMapping("/join")
    public String join(Model model){
        commonService.userSexName(model);
        commonService.userStatusName(model);
        commonService.userRankName(model);
        commonService.userGradeName(model);
        commonService.userConStatusName(model);
        commonService.skillName(model);
        commonService.emailName(model);
        return "user/join";
    }

    @GetMapping("/myPage")
    public String myPage(Model model){
        return "user/myPage";
    }


}
