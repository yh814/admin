package com.example.admin.controller;

import com.example.admin.dao.BoardDao;
import com.example.admin.dao.MatchProDao;
import com.example.admin.dao.ProjectInfoDao;
import com.example.admin.dao.UserInfoDao;
import com.example.admin.dto.*;
import com.example.admin.service.FileStorageService;
import com.example.admin.service.MatchProService;
import com.example.admin.service.ProjectInfoService;
import com.example.admin.service.UserInfoService;
import com.example.admin.wrapper.MatchProDtoList;
import com.example.admin.wrapper.ProNumAndUserNumListDto;
import com.example.admin.wrapper.UserNumAndProNumListDto;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@org.springframework.web.bind.annotation.RestController
public class RestController {

    private static final Logger logger = LoggerFactory.getLogger(RestController.class);
    private final MatchProDao matchProDao;

    private final MatchProService matchProService;

    private final ProjectInfoDao projectInfoDao;

    private final ProjectInfoService projectInfoService;

    private final UserInfoDao userInfoDao;

    private final UserInfoService userInfoService;

    private final FileStorageService fileStorageService;

    private final BoardDao boardDao;

    public RestController(MatchProDao matchProDao, MatchProService matchProService, ProjectInfoDao projectInfoDao, ProjectInfoService projectInfoService, UserInfoDao userInfoDao, UserInfoService userInfoService, FileStorageService fileStorageService, BoardDao boardDao) {
        this.matchProDao = matchProDao;
        this.matchProService = matchProService;
        this.projectInfoDao = projectInfoDao;
        this.projectInfoService = projectInfoService;
        this.userInfoDao = userInfoDao;
        this.userInfoService = userInfoService;
        this.fileStorageService = fileStorageService;
        this.boardDao = boardDao;
    }

    /*세션에 저장된 유저정보 가져오기*/
    @GetMapping("/getSessionInfo")
    public String getSessionInfo(HttpServletRequest request){
        HttpSession session = request.getSession();

        UserInfoDto userInfo = (UserInfoDto) session.getAttribute("userInfo");
        if(userInfo != null){
            return userInfo.getUserName();
        }else{
            return "No session info";
        }
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
    public ResponseEntity<?> searchProject(@RequestParam(value = "page", defaultValue = "1") int page,
                                           @RequestParam(value = "size", defaultValue = "5") int size,
                                           @RequestParam("searchProName") String searchProName,
                                           @RequestParam("searchProCust") String searchProCust,
                                           @RequestParam("searchStartDate1") String searchStartDate1,
                                           @RequestParam("searchStartDate2") String searchStartDate2,
                                           @RequestParam("searchEndDate1") String searchEndDate1,
                                           @RequestParam("searchEndDate2") String searchEndDate2) {

        // LIKE 검색을 위한 '%' 와일드카드 적용
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
            searchEndDate1 = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);// 종료 날짜를 현재 날짜로 설정
        }
        if (searchEndDate2 == null || searchEndDate2.isEmpty()) {
            searchEndDate2 =  "2030-01-01"; //
        }

        // 페이징 처리된 검색 결과 가져오기
        List<ProjectInfoDto> searchResult = projectInfoService.searchProject(searchProName, searchProCust, searchStartDate1, searchStartDate2, searchEndDate1, searchEndDate2, page, size);

        for(ProjectInfoDto pro : searchResult) {
            List<String> skills = projectInfoDao.selectProSkill(pro.getProNum());
            pro.setSkillDetailNameList(skills);
            logger.info("skills"+skills);
        }

        // 페이징 정보 가져오기
        PageDto pageDto = projectInfoService.getSearchProjectCount(searchProName, searchProCust, searchStartDate1, searchStartDate2, searchEndDate1, searchEndDate2, page, size);

        // 결과와 페이징 정보를 Map에 담아 반환
        Map<String, Object> response = new HashMap<>();
        response.put("searchResult", searchResult);
        response.put("pageInfo", pageDto);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/deletePro")
    public void deletePro(@RequestBody List<Integer> proNum){

        try {
            projectInfoService.deleteProData(proNum);
        } catch (Exception e) {
        }
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
            userInfoService.updateUserSkills(userInfo.getUserNum(), userInfo.getSkillCD());
        }

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath().path("/user/allUserInfo").build().toUri();
        return ResponseEntity.status(HttpStatus.FOUND).location(location).build();
    }

    @PostMapping("/userCheck")
    public ResponseEntity<Boolean> checkUserId(@RequestParam("userId") String userId) {
        boolean isAvailable = !userInfoService.checkUserIdExist(userId);
        return ResponseEntity.ok(isAvailable);
    }

    @PostMapping("/modify_user")
    public ResponseEntity<?> modify_user(@Valid UserInfoDto userInfo,@RequestParam(value = "existingImg", required = false) String existingImg, BindingResult result) {
        if (result.hasErrors()) {
            String errorMsg = result.getAllErrors().stream()
                    .map(ObjectError::getDefaultMessage)
                    .collect(Collectors.joining(", "));
            return ResponseEntity.badRequest().body("Validation error: " + errorMsg);
        }

        try {
            MultipartFile userImgFile = userInfo.getUserImgFile();

            if(userImgFile != null && !userImgFile.isEmpty()) {
                String originalFilename = userImgFile.getOriginalFilename();
                String extension = StringUtils.getFilenameExtension(originalFilename);
                String fileName = userInfo.getUserId() + "." + extension;

                fileStorageService.store(userImgFile, fileName);
                userInfo.setUserImg(fileName);
                logger.info("File {} has been successfully saved.", fileName);
            } else if (existingImg != null && !existingImg.isEmpty()){
                userInfo.setUserImg(existingImg);
                logger.info("유저 이미지는 {}",userInfo.getUserImg());
            }
        } catch (Exception e) {
            logger.error("File upload failed: " + e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("File upload failed: " + e.getMessage());
        }

        userInfoDao.modifyUserInfo(userInfo);
        userInfoService.updateUserSkills(userInfo.getUserNum(),userInfo.getSkillCD());

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath().path("/user/allUserInfo").build().toUri();
        return ResponseEntity.status(HttpStatus.FOUND).location(location).build();
    }

    /*프로젝트 추가 삭제*/
    @PostMapping("/addMatch")
    public ResponseEntity<?> addUserMatch(@RequestBody MatchProDtoList matchProDtoList) {
        logger.info("User added with userId: {}", matchProDtoList);

        for(MatchProDto pro: matchProDtoList.getMatchProDtoList()){
            matchProService.addMatchPro(pro);
        }

        return ResponseEntity.ok().build();
    }

    @PostMapping("/deleteMatchPro")
    public ResponseEntity<?> deleteUser(@RequestBody UserNumAndProNumListDto uAndpListDto){

        matchProService.deleteMatch(uAndpListDto.getUserNum(), uAndpListDto.getProNumList());

        return ResponseEntity.ok().build();
    }

    /*사원 추가 삭제*/
    @PostMapping("/addMatchUser")
    public ResponseEntity<?> addProMatch(@RequestBody MatchProDtoList matchProDtoList) {
        logger.info("User added with userId: {}", matchProDtoList);

        for(MatchProDto user: matchProDtoList.getMatchProDtoList()){
            matchProService.addMatchUser(user);
        }

        return ResponseEntity.ok().build();
    }

    @PostMapping("/deleteMatchUser")
    public ResponseEntity<?> deletePro(@RequestBody ProNumAndUserNumListDto pAnduListDto){

        matchProService.deleteMatchUser(pAnduListDto);

        return ResponseEntity.ok().build();
    }


    @PostMapping("/updateMatchInfo")
    public ResponseEntity<?> updateMatchInfo(@RequestBody MatchProDto matchProDto){
        matchProDao.updateMatchInfo(matchProDto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/addPro")
    public ResponseEntity<?> addPro(@Valid ProjectInfoDto projectInfoDto, BindingResult result) {

        if (result.hasErrors()) {
            String errorMsg = result.getAllErrors().stream()
                    .map(ObjectError::getDefaultMessage)
                    .collect(Collectors.joining(", "));
            return ResponseEntity.badRequest().body("Validation error: " + errorMsg);
        }

        projectInfoService.addPro(projectInfoDto);
        logger.info("Project added with proNum: {}", projectInfoDto.getProNum());

        if (projectInfoDto.getSkillCD() != null) {
            projectInfoService.updateProSkills(projectInfoDto.getProNum(), projectInfoDto.getSkillCD());
        }

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath().path("/project/proMain").build().toUri();
        return ResponseEntity.status(HttpStatus.FOUND).location(location).build();
    }

    @PostMapping("/modify_pro")
    public ResponseEntity<?> modify_pro(@Valid ProjectInfoDto proInfo, BindingResult result) {
        if (result.hasErrors()) {
            String errorMsg = result.getAllErrors().stream()
                    .map(ObjectError::getDefaultMessage)
                    .collect(Collectors.joining(", "));
            return ResponseEntity.badRequest().body("Validation error: " + errorMsg);
        }

        projectInfoDao.modifyProInfo(proInfo);
        projectInfoService.updateProSkills(proInfo.getProNum(),proInfo.getSkillCD());

        URI location = ServletUriComponentsBuilder.fromCurrentContextPath().path("/project/proMain").build().toUri();
        return ResponseEntity.status(HttpStatus.FOUND).location(location).build();
    }

    @GetMapping("/proMatchUserSearch")
    public String searchUser(@RequestParam(value="searchUserName", required = false)String searchUserName,
                            @RequestParam(value="searchGradeName", required = false)String searchGradeName,
                            @RequestParam(value="searchStatusName", required = false)String searchStatusName,
                            @RequestParam("proNum") int proNum) {

        ObjectMapper mapper = new ObjectMapper();
        String jsonString = "";

        searchUserName = "%" + (searchUserName != null ? searchUserName : "") + "%";
        searchGradeName = "%" + (searchGradeName != null ? searchGradeName : "") + "%";
        searchStatusName = "%" + (searchStatusName != null ? searchStatusName : "") + "%";

        List<UserInfoDto> searchResult = matchProDao.getSearchUser(proNum, searchUserName, searchGradeName, searchStatusName);
        for(UserInfoDto user : searchResult) {
            List<String> skills = userInfoDao.selectUserSkills(user.getUserNum());
            user.setSkillDetailNameList(skills);
        }

        try {
            jsonString = mapper.writeValueAsString(searchResult);
        } catch (Exception e) {
            logger.error("userMatchProSearch 예외 발생", e);
        }
        logger.info(jsonString);
        return jsonString;
    }

    @PostMapping("/searchFreeBoard")
    public ResponseEntity<?> getAllFreeBoard(@RequestParam(value="searchContents", required = false)String searchContents,
                                              @RequestParam(value="searchTitle", required = false)String searchTitle,
                                              @RequestParam(value="searchUserId", required = false)String searchUserId) {

        try {
            List<BoardDto> allFreeBoard = boardDao.getMainFreeBoard(searchContents, searchTitle, searchUserId);
            System.out.println(allFreeBoard);
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonFreeBoard = objectMapper.writeValueAsString(allFreeBoard);

            return ResponseEntity.ok().body(jsonFreeBoard);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }

    }



}
