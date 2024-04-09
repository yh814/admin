package com.example.admin.service;

import com.example.admin.dao.MatchProDao;
import com.example.admin.dto.MatchProDto;
import com.example.admin.wrapper.ProNumAndUserNumListDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class MatchProService {

    private final MatchProDao matchProDao;

    public MatchProService(MatchProDao matchProDao) {
        this.matchProDao = matchProDao;
    }


    /*프로젝트 추가 삭제*/
    @Transactional
    public void addMatchPro(MatchProDto matchProDto) {
        matchProDao.addMatchPro(matchProDto);
    }

    public void deleteMatch(int userNum,List<Integer> proNum){
        for(int pro : proNum){
            matchProDao.deleteMatch(userNum, pro);
        }
    }

    /*사원 추가 삭제*/
    @Transactional
    public void addMatchUser(MatchProDto matchProDto) {
      matchProDao.addMatchPro(matchProDto);
  }

    public void deleteMatchUser(ProNumAndUserNumListDto proNumAndUserNumListDto){
        for(int user : proNumAndUserNumListDto.getUserNumList()){
            matchProDao.deleteMatch(user, proNumAndUserNumListDto.getProNum());
        }
    }


}
