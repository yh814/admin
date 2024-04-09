package com.example.admin.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login(@RequestParam(value="fail", defaultValue = "false")boolean fail, Model model){
        model.addAttribute("fail",fail);
        return "login";
    }



}
