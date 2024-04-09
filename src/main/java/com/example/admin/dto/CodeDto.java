package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("CodeDto")
public class CodeDto {
    private String codeId;
    private String codeInfo;
}
