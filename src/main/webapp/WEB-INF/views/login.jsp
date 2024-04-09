<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
<link rel="stylesheet"  href="${root }css/login.css">
</head>
<body>

<div class="login-container">
    <form action="${root}user/login_pro" method="post"> 
        <div class="title">
            <label>Login</label>
        </div>
        <!-- ID 입력 필드 -->
        <label for="id">ID</label> 
        <input type="text" id="id" name="id" required>
        

        <!-- 비밀번호 입력 필드 -->
        <label for="password">Password</label> 
        <input type="password" id="password" name="password" required> 

        <input type="submit" value="Login">
        <c:if test="${not empty loginError}">
		    <div class="error-message">
		        <label>${loginError}</label>
		    </div>
		</c:if>


    </form>

    <div class="join-button">
        <a href="${root}user/join" class="join-btn">Join</a>

        <div class="findInfo">
            <label class="findID">아이디 찾기</label>
            <label class="findPW">비밀번호 찾기</label>
        </div>
    </div>

</div>

   


</body>
</html>
