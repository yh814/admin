package com.example.test3.dao;

import com.example.test3.dto.UserInfoDto;
import com.example.test3.dto.UserSkillDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import java.util.List;
@Mapper
public interface UserInfoDao {

    /*로그인 아이디, 비번 체크*/
    UserInfoDto loginIdPw(String userId, String userPw);

    /*아이디 중복체크*/
    int checkUserIdExist(String userId);

    /*한명의 정보 가져오기*/
    UserInfoDto getOneUserInfo(int userNum);

    /*모든 회원의 정보 가져오기*/
    List<UserInfoDto> getAllUserInfoDetail(RowBounds rowBounds);

    /*모든 인원수 가져오기*/
    int getAllUserCount();


    /*해당 사원의 보유스킬들*/
    List<String> selectUserSkills(int userNum);

    /*검색처리*/
    List<UserInfoDto> searchUsers(String searchUserName,String searchUserGrade,String searchUserStatus,String searchUserStartDate,String searchUserEndDate);

    /*회원 등록*/
    void addUser(UserInfoDto userInfo);

    /*회원 스킬 등록*/
    void addUserSkill(UserSkillDto userSkillDto);

    /*회원정보 수정*/
    UserInfoDto modifyUserInfo(UserInfoDto userInfoDto);

    /*유저 삭제*/
    void delUserFromMP(int userNum);
    void delUserFromUS(int userNum);
    void delUserFromUI(int userNum);
    void delUserFromB(int userNum);


}
