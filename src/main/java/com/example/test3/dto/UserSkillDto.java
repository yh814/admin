package com.example.test3.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("UserSkillDto")
public class UserSkillDto {

    private int userNum;
    private String detailCD;
}
