package com.example.admin.wrapper;

import com.example.admin.dto.MatchProDto;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
public class MatchProDtoList {

    /*래퍼클래스*/
    @JsonProperty("MatchProDtoList")
    private List<MatchProDto> matchProDtoList;
}

