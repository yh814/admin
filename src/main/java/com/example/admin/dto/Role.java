package com.example.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum Role {

    ADMIN("ROLE_ADMIN"),
    NORMAL("ROLE_NORMAL");

    private String value;


}
