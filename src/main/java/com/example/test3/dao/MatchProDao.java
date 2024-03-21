package com.example.test3.dao;

import com.example.test3.dto.MatchProDto;
import com.example.test3.dto.ProjectInfoDto;
import com.example.test3.dto.UserInfoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import java.util.List;
@Mapper
public interface MatchProDao {
    /*해당 유저가 한 모든 프로젝트*/
    List<MatchProDto> getOneUserPros(int userNum);

    /*매치 유저 정보*/
    UserInfoDto getMatchUserInfo(int userNum);

    /*해당 유저가 진행하고 있지 않는 프로젝트들*/
    List<ProjectInfoDto> matchAllProList(int userNum, RowBounds rowBounds);

    /*해당 유저가 진행하고 있지 않는 프로젝트들의 수*/
    int matchAllProListCnt(int userNum);

    /*해당 유저가 진행하고 있지 않는 프로젝트 search*/
    List<ProjectInfoDto> getSearchPro(int userNum, String searchProName, String searchCusName, String searchProgressName);

    /*유저 프로젝트 추가*/
    void addMatchPro(MatchProDto matchProDto);

    /*한 프로젝트에 투입된 총인원*/
    int countUser(int proNum);
}
