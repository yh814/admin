package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import jakarta.validation.constraints.NotNull;

@Data
@Alias("MatchProDto")
public class MatchProDto {
    private int userNum;

    private int proNum;

    @NotNull
    private String inputDate;

    private String witDate;

    @NotNull
    private String roleCD;

    private String roleDetailName;

    private String rankDetailName; // 직급 상세 이름
    private String gradeDetailName; // 기술 등급 상세 이름
    private String employmentStatusDetailName;//재직상태 상세 이름

    private String cusDetailName;//고객사 상세 이름
    private String progressDetailName;// 진행상태 상세 이름

    private String userName;
    private String proName;
    private String startDate;
    private String endDate;



    private int userCnt;
    private int proCnt;

}
