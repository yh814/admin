package com.example.test3.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("MatchProDto")
public class MatchProDto {
    private int userNum;

    private int proNum;

    private String inputDate;

    private String witDate;

    private String roleCD;

    private String roleDetailName;

    private String rankDetailName; // 직급 상세 이름
    private String gradeDetailName; // 기술 등급 상세 이름

    private String cusDetailName;//고객사 상세 이름
    private String progressDetailName;// 진행상태 상세 이름

    private String userName;
    private String proName;
    private String startDate;
    private String endDate;

    private int userCnt;
}
