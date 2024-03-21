package com.example.test3.controller;

import com.example.test3.dao.MatchProDao;
import com.example.test3.dao.ProjectInfoDao;
import com.example.test3.dao.UserInfoDao;
import com.example.test3.dto.ProjectInfoDto;
import com.example.test3.dto.UserInfoDto;
import com.example.test3.dto.UserSkillDto;
import com.example.test3.service.FileStorageService;
import com.example.test3.service.UserInfoService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.validation.ObjectError;

import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@org.springframework.web.bind.annotation.RestController
public class RestController {

    private static final Logger logger = LoggerFactory.getLogger(RestController.class);
    private final MatchProDao matchProDao;

    private final ProjectInfoDao projectInfoDao;

    private final UserInfoDao userInfoDao;

    private final UserInfoService userInfoService;

    private FileStorageService fileStorageService;

    public RestController(MatchProDao matchProDao, ProjectInfoDao projectInfoDao, UserInfoDao userInfoDao, UserInfoService userInfoService, FileStorageService fileStorageService) {
        this.matchProDao = matchProDao;
        this.projectInfoDao = projectInfoDao;
        this.userInfoDao = userInfoDao;
        this.userInfoService = userInfoService;
        this.fileStorageService = fileStorageService;
    }

    @GetMapping("/userMatchProSearch")
    public String searchPro(@RequestParam(value="searchProName", required = false)String searchProName,
                            @RequestParam(value="searchCusName", required = false)String searchCusName,
                            @RequestParam(value="searchProgressName", required = false)String searchProgressName,
                            @RequestParam("userNum") int userNum) {

        ObjectMapper mapper = new ObjectMapper();
        String jsonString = "";

        searchProName = "%" + (searchProName != null ? searchProName : "") + "%";
        searchCusName = "%" + (searchCusName != null ? searchCusName : "") + "%";
        searchProgressName = "%" + (searchProgressName != null ? searchProgressName : "") + "%";

        List<ProjectInfoDto> searchResult = matchProDao.getSearchPro(userNum, searchProName, searchCusName, searchProgressName);
        for (ProjectInfoDto pro : searchResult) {
            int userCnt = matchProDao.countUser(pro.getProNum());
            pro.setUserCnt(userCnt);
        }

        try {
            jsonString = mapper.writeValueAsString(searchResult);
        } catch (Exception e) {
            logger.error("userMatchProSearch 예외 발생", e);
        }
        logger.info(jsonString);
        return jsonString;
    }


    @GetMapping("/search_pro")
    public String searchProject(@RequestParam("searchProName")String searchProName,
                                @RequestParam("searchProCust")String searchProCust,
                                @RequestParam("searchStartDate1")String searchStartDate1,
                                @RequestParam("searchStartDate2")String searchStartDate2,
                                @RequestParam("searchEndDate1")String searchEndDate1,
                                @RequestParam("searchEndDate2")String searchEndDate2, Model model) {
        ObjectMapper mapper = new ObjectMapper();
        String jsonString = "";

        // '%' 와일드카드를 사용하여 LIKE 검색을 위한 파라미터 설정
        searchProName = "%" + (searchProName != null ? searchProName : "") + "%";
        searchProCust = "%" + (searchProCust != null ? searchProCust : "") + "%";

        // 날짜 파라미터가 비어있는 경우 기본값 설정
        if (searchStartDate1 == null || searchStartDate1.isEmpty()) {
            searchStartDate1 = "1990-01-01"; // 시작 날짜 기본값
        }
        if (searchStartDate2 == null || searchStartDate2.isEmpty()) {
            searchStartDate2 = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE); // 종료 날짜를 현재 날짜로 설정
        }

        if (searchEndDate1 == null || searchEndDate1.isEmpty()) {
            searchEndDate1 = "1990-01-02"; // 시작 날짜 기본값
        }
        if (searchEndDate2 == null || searchEndDate2.isEmpty()) {
            searchEndDate2 = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE); // 종료 날짜를 현재 날짜로 설정
        }

        List<ProjectInfoDto> searchResult = projectInfoDao.searchProject(searchProName, searchProCust, searchStartDate1, searchStartDate2, searchEndDate1, searchEndDate2);
        for(ProjectInfoDto project : searchResult) {
            List<String> skills = projectInfoDao.selectProSkill(project.getProNum());
            project.setSkillDetailNameList(skills);
        }
        model.addAttribute("searchResult", searchResult);

        try {
            jsonString = mapper.writeValueAsString(searchResult);
        } catch (Exception e) {
            logger.error("search_pro 예외 발생", e);
        }
        logger.info(jsonString);
        return jsonString;
    }

    @GetMapping("/search_userList")
    public String searchUsers(@RequestParam(required = false) String searchUserName,
                              @RequestParam(required = false) String searchUserGrade,
                              @RequestParam(required = false) String searchUserStatus,
                              @RequestParam(required = false) String searchUserStartDate,
                              @RequestParam(required = false) String searchUserEndDate, Model model) {

        ObjectMapper mapper = new ObjectMapper();
        String jsonString = "";

        // '%' 와일드카드를 사용하여 LIKE 검색을 위한 파라미터 설정
        searchUserName = "%" + (searchUserName != null ? searchUserName : "") + "%";
        searchUserGrade = "%" + (searchUserGrade != null ? searchUserGrade : "") + "%";
        searchUserStatus = "%" + (searchUserStatus != null ? searchUserStatus : "") + "%";

        // 날짜 파라미터가 비어있는 경우 기본값 설정
        if (searchUserStartDate == null || searchUserStartDate.isEmpty()) {
            searchUserStartDate = "1990-01-01"; // 시작 날짜 기본값
        }
        if (searchUserEndDate == null || searchUserEndDate.isEmpty()) {
            searchUserEndDate = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE); // 종료 날짜를 현재 날짜로 설정
        }

        List<UserInfoDto> searchResult = userInfoDao.searchUsers(searchUserName, searchUserGrade, searchUserStatus, searchUserStartDate, searchUserEndDate);
        for(UserInfoDto user : searchResult) {
            List<String> skills = userInfoDao.selectUserSkills(user.getUserNum());
            user.setSkillDetailNameList(skills);
        }
        model.addAttribute("searchResult", searchResult);

        try {
            jsonString = mapper.writeValueAsString(searchResult);
        } catch (Exception e) {
            logger.error("search_userList 예외 발생", e);
        }
        logger.info(jsonString);
        return jsonString;
    }

    @PostMapping("/deleteUser")
    public void deleteUser(@RequestBody List<Integer> userNum){

        try {
            userInfoService.deleteUserData(userNum);
        } catch (Exception e) {
        }
    }

    @PostMapping("/addUser")
    public ResponseEntity<?> addUser(@Valid UserInfoDto userInfo, BindingResult result) {
        if (result.hasErrors()) {
            String errorMsg = result.getAllErrors().stream()
                    .map(ObjectError::getDefaultMessage)
                    .collect(Collectors.joining(", "));
            return ResponseEntity.badRequest().body("Validation error: " + errorMsg);
        }

        try {
            MultipartFile userImgFile = userInfo.getUserImgFile();
            String originalFilename = userImgFile.getOriginalFilename();
            String extension = StringUtils.getFilenameExtension(originalFilename);
            String fileName = userInfo.getUserId() + "." + extension;

            fileStorageService.store(userImgFile, fileName);
            userInfo.setUserImg(fileName);
            logger.info("File {} has been successfully saved.", fileName);
        } catch (Exception e) {
            logger.error("File upload failed: " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("File upload failed: " + e.getMessage());
        }

        userInfoService.addUser(userInfo);
        logger.info("User added with userId: {}", userInfo.getUserId());

        if (userInfo.getSkillCD() != null) {
            for (String skill : userInfo.getSkillCD()) {
                UserSkillDto userSkill = new UserSkillDto();
                userSkill.setUserNum(userInfo.getUserNum());
                userSkill.setDetailCD(skill);
                userInfoDao.addUserSkill(userSkill);
            }
        }

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath().path("/user/allUserInfo").build().toUri();
        return ResponseEntity.status(HttpStatus.FOUND).location(location).build();
    }

    @PostMapping("/userCheck")
    public ResponseEntity<Boolean> checkUserId(@RequestParam("userId") String userId) {
        boolean isAvailable = !userInfoDao.checkUserIdExist(userId);
        return ResponseEntity.ok(isAvailable);
    }



}

