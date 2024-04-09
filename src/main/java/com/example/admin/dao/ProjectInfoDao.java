package com.example.admin.dao;

import com.example.admin.dto.ProjectInfoDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.RowBounds;
import org.springframework.data.repository.query.Param;

import java.util.List;
@Mapper
public interface ProjectInfoDao {

    /*해당 프로젝트의 필요기술들*/
    List<String> selectProSkill(int proNum);

    /*검색기능*/
    List<ProjectInfoDto> searchProject(String searchProName, String searchProCust, String searchStartDate1, String searchStartDate2, String searchEndDate1, String searchEndDate2, RowBounds rowBounds);

    /*검색 프로젝트 개수 가져오기*/
    int getSearchProjectCount(String searchProName, String searchProCust, String searchStartDate1, String searchStartDate2, String searchEndDate1, String searchEndDate2);

    /*프로젝트 삭제*/
    void delProFromMP(int proNum);
    void delProFromUS(int proNum);
    void delProFromPI(int proNum);

    /*프로젝트 등록*/
    void addPro(ProjectInfoDto projectInfoDto);

    /*프로젝트 스킬 등록*/
    void addProSkill(@Param("proNum") int proNum, @Param("detailCD") String detailCD);

    /*프로젝트 수정*/
    void modifyProInfo(ProjectInfoDto projectInfoDto);

    /*하나의 프로젝트 정보*/
    ProjectInfoDto getOneProInfo(int proNum);
}
