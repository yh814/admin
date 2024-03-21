package com.example.test3.service;

import com.example.test3.dao.MatchProDao;
import com.example.test3.dto.PageDto;
import com.example.test3.dto.ProjectInfoDto;
import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MatchProService {

    private int page_listcnt;
    private int page_paginationcnt;

    private final MatchProDao matchProDao;

    public MatchProService(MatchProDao matchProDao,
                           @Value("${page.listcnt}")int page_listcnt,
                           @Value("${page.paginationcnt}")int page_paginationcnt) {
        this.matchProDao = matchProDao;
        this.page_listcnt = page_listcnt;
        this.page_paginationcnt = page_paginationcnt;
    }

    public List<ProjectInfoDto> matchAllProList(int userNum, int page){
        int start = (page - 1) * page_listcnt;
        RowBounds rowBounds = new RowBounds(start, page_listcnt);
        return matchProDao.matchAllProList(userNum, rowBounds);
    }

    public PageDto matchAllProListCnt(int userNum, int currentPage) {
        int proCnt = matchProDao.matchAllProListCnt(userNum);
        return new PageDto(proCnt, currentPage, page_listcnt, page_paginationcnt);
    }



}
