package com.example.test3.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import java.util.List;

@Data
@Alias("ProjectInfoDto")
public class ProjectInfoDto {
    private int proNum;
    private String proName;
    private String cusCD;
    private String startDate;
    private String endDate;
    private String progressCD;
    private String manager;
    private String mPhone;
    private String note;

    //코드마스터 detailName
    private String cusDetailName;//고객사 상세 이름
    private String progressDetailName;// 진행상태 상세 이름

    //프로젝트 스킬
    private List<String> skillDetailNameList;

    private int userCnt;
}
