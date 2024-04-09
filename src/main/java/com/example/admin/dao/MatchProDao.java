package com.example.admin.dao;

import com.example.admin.dto.MatchProDto;
import com.example.admin.dto.ProjectInfoDto;
import com.example.admin.dto.UserInfoDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface MatchProDao {
    /*해당 유저가 한 모든 프로젝트*/
    List<MatchProDto> getOneUserPros(int userNum);

    /*매치 유저 정보*/
    UserInfoDto getMatchUserInfo(int userNum);

    /*해당 유저가 진행하고 있지 않는 프로젝트들*/
    List<ProjectInfoDto> matchAllProList(int userNum);

    /*해당 유저가 진행하고 있지 않는 프로젝트들의 수*/
    int matchAllProListCnt(int userNum);

    /*해당 유저가 진행하고 있지 않는 프로젝트 search*/
    List<ProjectInfoDto> getSearchPro(int userNum, String searchProName, String searchCusName, String searchProgressName);

    /*유저 프로젝트 추가*/
    void addMatchPro(MatchProDto matchProDto);

    /*한 프로젝트에 투입된 총인원*/
    int countUser(int proNum);

    /*진행하는 프로젝트 삭제*/
    void deleteMatch(int userNum, int proNum);

    /*매치한 프로젝트 수정*/
    void updateMatchInfo(MatchProDto matchProDto);

    ProjectInfoDto getMatchProInfo(int proNum);

    List<MatchProDto> getOneProUsers(int proNum);

    List<UserInfoDto> matchAllUserList(int proNum);

    List<UserInfoDto> getSearchUser(int proNum, String searchUserName, String searchGradeName, String searchStatusName);

}
