package com.example.test3.dao;

import com.example.test3.dto.BoardDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BoardDao {
    List<BoardDto> getNotice();
    List<BoardDto> getFreeBoard();
    List<BoardDto> getMainNotice();
    List<BoardDto> getMainFreeBoard();
 }
