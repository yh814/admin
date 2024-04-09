package com.example.admin.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;

public class loginInterceptor implements HandlerInterceptor {

    /*@Resource(name = "loginUser")
    private UserInfoDto loginUser;

    public loginInterceptor(UserInfoDto loginUser){
        this.loginUser = loginUser;
    }*/

    /*@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
       UserInfoDto loginUser = (UserInfoDto) request.getAttribute("loginUser");
        if(!loginUser.isUserLogin()){
            response.sendRedirect(request.getContextPath() + "/login");
           return false;
       }
       return true;
    }*/
}
