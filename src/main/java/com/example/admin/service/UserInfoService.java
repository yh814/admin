package com.example.admin.service;

import com.example.admin.dao.UserInfoDao;
import com.example.admin.dto.UserInfoDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserInfoService {
    private final UserInfoDao userInfoDao;

    public UserInfoService(UserInfoDao userInfoDao) {
        this.userInfoDao = userInfoDao;
    }

    public UserInfoDto loginIdPw(String userId, String userPw) {
        return userInfoDao.loginIdPw(userId, userPw);
    }

    //아이디 체크
    public boolean checkUserIdExist(String userId) {

        int result = userInfoDao.checkUserIdExist(userId);

        if (result>0) {
            return true;
        } else {
            return false;
        }

    }

    //---------------------------------------------추가---------------------------------------------------

    public void addUser(UserInfoDto userInfo) {
        userInfoDao.addUser(userInfo);
    }

    /*유저 스킬 수정*/
    @Transactional
    public void updateUserSkills(int userNum, List<String> skills){
        userInfoDao.deleteUserSkill(userNum);
        for(String skill: skills){
            userInfoDao.addUserSkill(userNum, skill);
        }
    }

    //-----------------------------------------------삭제---------------------------------------------------
    //유저 삭제
    @Transactional
    public void deleteUserData(List<Integer> userNum) {
        try {
            for(int user: userNum) {
                userInfoDao.delUserFromMP(user);
                userInfoDao.delUserFromUS(user);
                userInfoDao.delUserFromUI(user);
                userInfoDao.delUserFromB(user);
            }
        }catch(Exception e) {
            throw new RuntimeException("Error deleting user", e);
        }
    }
}
