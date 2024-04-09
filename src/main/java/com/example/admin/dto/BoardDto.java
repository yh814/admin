package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("BoardDto")
public class BoardDto {
    private int boardNum;
    private String userId;
    private String boardTitle;
    private String boardRegDate;
    private String boardHits;
    private String boardCategory;
    private String boardContents;
}
