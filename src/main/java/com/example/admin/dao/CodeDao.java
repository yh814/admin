package com.example.admin.dao;

import com.example.admin.dto.CodeDetailDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
@Mapper
public interface CodeDao {
    List<CodeDetailDto> getDetailName(String codeId);
}
