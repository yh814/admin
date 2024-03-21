package com.example.test3.dao;

import com.example.test3.dto.CodeDetailDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface CodeDao {
    List<CodeDetailDto> getDetailName(String codeId);
}
