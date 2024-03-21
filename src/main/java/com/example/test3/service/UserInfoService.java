package com.example.test3.service;

import com.example.test3.dao.UserInfoDao;
import com.example.test3.dto.PageDto;
import com.example.test3.dto.UserInfoDto;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserInfoService {
    private int page_listcnt;
    private int page_paginationcnt;

    private final UserInfoDao userInfoDao;

    public UserInfoService(UserInfoDao userInfoDao,
                              @Value("${page.listcnt}")int page_listcnt,
                              @Value("${page.paginationcnt}")int page_paginationcnt) {
        this.userInfoDao = userInfoDao;
        this.page_listcnt = page_listcnt;
        this.page_paginationcnt = page_paginationcnt;
    }

    public UserInfoDto loginIdPw(String userId, String userPw) {
        return userInfoDao.loginIdPw(userId, userPw);
    }

    //아이디 체크
    public boolean checkUserIdExist(String userId) {

        boolean result = userInfoDao.checkUserIdExist(userId);

        if (result) {
            return true;
        } else {
            return false;
        }

    }

    //모든 유저
    public List<UserInfoDto> getAllUserInfoDetail(int page){
        int start = (page-1)*page_listcnt;
        RowBounds rowBounds = new RowBounds(start, page_listcnt);

        return userInfoDao.getAllUserInfoDetail(rowBounds);
    }

    //모든 유저 인원수
    public PageDto getAllUserCount(int currentPage) {
        int user_cnt = userInfoDao.getAllUserCount();
        PageDto pageBean = new PageDto(user_cnt, currentPage, page_listcnt, page_paginationcnt );
        return pageBean;
    }

    //-----------------------------------------------추가---------------------------------------------------

    public void addUser(UserInfoDto userInfo) {
        userInfoDao.addUser(userInfo);
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
