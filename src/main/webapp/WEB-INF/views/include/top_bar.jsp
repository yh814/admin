<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value = '${pageContext.request.contextPath }/'/>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="${root }css/top_bar.css">

</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function() {
/*     // 사원 관리 드롭다운
    var userSec1 = document.querySelector('.dropdown-menu1');
    var userDropdown1 = document.querySelector('.user-dropdown1');

    userSec1.addEventListener('mouseover', function() {
        userDropdown1.style.display = 'block';
    });

    userDropdown1.addEventListener('mouseleave', function() {
        this.style.display = 'none';
    });
     */
    // 프로젝트 관리 드롭다운
    var proSec = document.querySelector('.dropdown-menu2');
    var proDropdown = document.querySelector('.user-dropdown2');

    proSec.addEventListener('mouseover', function() {
        proDropdown.style.display = 'block';
    });

    proDropdown.addEventListener('mouseleave', function() {
        this.style.display = 'none';
    });
});

</script>

<body>

<div class="topbar-sec">
	<div class="top-bar-con">
		<!-- 로고 이미지 -->
		<div class="logo-img">
			<a href="${root }board/homePage">
				<img src="${root }image/logo.png" alt="logoImg" style="width: 230px; margin-left: 20px;"/>
			</a>
		</div>
		
		<!-- 메뉴 -->
		<div class="menu-box">
			<div>
				<label>MENU</label>
			</div>
			
			<!--  사원 카테고리  -->
			<div>			
				<a href="${root }user/allUserInfo" class="dropdown-menu1">사원 관리</a>
			 	<!--<ul class="user-dropdown1">
					<li class="dropdown-list1"><a href=""></a></li>
					<li class="dropdown-list1"><a href=""></a></li>
					<li class="dropdown-list1"><a href="">c</a></li>		
				</ul> -->
			</div>
			
			<!--  프로젝트 카테고리  -->
			<div>
				<a href="${root }project/proMain"  class="dropdown-menu2">프로젝트 관리</a>
				<ul class="user-dropdown2">
					<li class="dropdown-list2"><a href="">진행중인 프로젝트</a></li>
					<li class="dropdown-list2"><a href="">중단된 프로젝트</a></li>
					<li class="dropdown-list2"><a href="">완료된 프로젝트</a></li>		
				</ul>
			</div>
		
		</div>
	
	</div>
	
	</div>

	
	
</body>