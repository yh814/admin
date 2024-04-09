package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.util.List;

@Data
@Alias("ProjectInfoDto")
public class ProjectInfoDto {
    private int proNum;

    @Size(min = 2, max = 10)
    @Pattern(regexp = "^(?!.*\\s{2})[a-zA-Zㄱ-ㅎ가-힣/_\\s-]*$")
    @NotBlank
    private String proName;

    @NotBlank
    private String cusCD;

    @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$")
    @NotBlank
    private String startDate;

    @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$")
    @NotBlank
    private String endDate;

    @NotBlank
    private String progressCD;

    private String manager;
    private String mPhone;
    private String note;

    private List<String> skillCD;

    //코드마스터 detailName
    private String cusDetailName;//고객사 상세 이름
    private String progressDetailName;// 진행상태 상세 이름

    //프로젝트 스킬
    private List<String> skillDetailNameList;

    private int userCnt;
}
