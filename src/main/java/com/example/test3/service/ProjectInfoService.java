package com.example.test3.service;

import com.example.test3.dao.ProjectInfoDao;
import com.example.test3.dto.PageDto;
import com.example.test3.dto.ProjectInfoDto;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProjectInfoService {

    private int page_listcnt;
    private int page_paginationcnt;

    private final ProjectInfoDao projectInfoDao;

    public ProjectInfoService(ProjectInfoDao projectInfoDao,
                           @Value("${page.listcnt}")int page_listcnt,
                           @Value("${page.paginationcnt}")int page_paginationcnt) {
        this.projectInfoDao = projectInfoDao;
        this.page_listcnt = page_listcnt;
        this.page_paginationcnt = page_paginationcnt;
    }

    public List<ProjectInfoDto> allProList(int page){
        int start=(page-1)*page_listcnt;
        RowBounds rowBounds = new RowBounds(start, page_listcnt);
        return projectInfoDao.allProList(rowBounds);
    }

    //모든 프로젝트 인원수
    public PageDto getAllProCount(int currentPage) {
        int pro_cnt = projectInfoDao.getAllProjectCount();
        PageDto pageBean = new PageDto(pro_cnt, currentPage, page_listcnt, page_paginationcnt);
        return pageBean;
    }



}
