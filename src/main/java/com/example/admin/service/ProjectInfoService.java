package com.example.admin.service;

import com.example.admin.dao.ProjectInfoDao;
import com.example.admin.dto.PageDto;
import com.example.admin.dto.ProjectInfoDto;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProjectInfoService {

    private final ProjectInfoDao projectInfoDao;

    public ProjectInfoService(ProjectInfoDao projectInfoDao) {
        this.projectInfoDao = projectInfoDao;
    }

    /*검색 결과 페이징*/
    public List<ProjectInfoDto> searchProject(String searchProName, String searchProCust, String searchStartDate1, String searchStartDate2, String searchEndDate1, String searchEndDate2, int page, int page_listcnt) {
        int start = (page - 1) * page_listcnt;
        RowBounds rowBounds = new RowBounds(start, page_listcnt);
        return projectInfoDao.searchProject(searchProName, searchProCust, searchStartDate1, searchStartDate2, searchEndDate1, searchEndDate2, rowBounds);
    }

    //검색 결과 개수
    public PageDto getSearchProjectCount(String searchProName, String searchProCust, String searchStartDate1, String searchStartDate2, String searchEndDate1, String searchEndDate2, int currentPage, int page_listcnt) {
        int proCnt = projectInfoDao.getSearchProjectCount(searchProName, searchProCust, searchStartDate1, searchStartDate2, searchEndDate1, searchEndDate2);
        return new PageDto(proCnt, currentPage, page_listcnt);
    }

    /*프로젝트 삭제*/
    @Transactional
    public void deleteProData(List<Integer> proNum) {
        try {
            for(int pro: proNum) {
                projectInfoDao.delProFromMP(pro);
                projectInfoDao.delProFromUS(pro);
                projectInfoDao.delProFromPI(pro);
            }
        }catch(Exception e) {
            throw new RuntimeException("Error deleting project", e);
        }
    }

    /*프로젝트 등록*/
    public void addPro(ProjectInfoDto projectInfoDto) {
        projectInfoDao.addPro(projectInfoDto);
    }

    /*유저 스킬 수정*/
    @Transactional
    public void updateProSkills(int proNum, List<String> skills){
        projectInfoDao.delProFromUS(proNum);
        for(String skill: skills){
            projectInfoDao.addProSkill(proNum, skill);
        }
    }


}
