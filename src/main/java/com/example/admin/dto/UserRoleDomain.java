package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("userRole")
public class UserRoleDomain {

    private String sysopid;

    private String role;
}
