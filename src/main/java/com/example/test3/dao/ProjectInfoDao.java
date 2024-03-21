package com.example.test3.dao;

import com.example.test3.dto.ProjectInfoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;

import java.util.List;
@Mapper
public interface ProjectInfoDao {
    /*전체 프로젝트*/
    List<ProjectInfoDto> allProList(RowBounds rowBounds);

    /*모든 프로젝트 개수 가져오기*/
    int getAllProjectCount();

    /*해당 프로젝트의 필요기술들*/
    List<String> selectProSkill(int proNum);

    /*검색기능*/
    List<ProjectInfoDto> searchProject(String searchProName,String searchProCust, String searchStartDate1, String searchStartDate2, String searchEndDate1, String searchEndDate2);
}
