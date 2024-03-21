package com.example.test3.config;

import com.example.test3.dto.UserInfoDto;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean(name = "loginUser")
    public UserInfoDto loginUser() {
        return new UserInfoDto();
    }
}
