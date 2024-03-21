package com.example.test3.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("CodeDetailDto")
public class CodeDetailDto {
    private String detailCD;
    private String codeId;
    private String detailCdName;
}
