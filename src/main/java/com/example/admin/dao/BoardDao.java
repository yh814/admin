package com.example.admin.dao;

import com.example.admin.dto.BoardDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardDao {
    List<BoardDto> getNotice();
    List<BoardDto> getFreeBoard();
    List<BoardDto> getMainNotice();
    List<BoardDto> getMainFreeBoard(String searchContents,String searchTitle, String searchUserId);
 }
