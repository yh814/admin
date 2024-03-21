package com.example.test3.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("BoardDto")
public class BoardDto {
    private int boardNum;
    private int userNum;
    private String boardTitle;
    private String boardRegDate;
    private String boardHits;
    private String boardCategory;
    private String boardContents;
}
