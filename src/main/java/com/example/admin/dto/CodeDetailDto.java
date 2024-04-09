package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("CodeDetailDto")
public class CodeDetailDto {
    private String detailCD;
    private String codeId;
    private String detailCdName;
}
