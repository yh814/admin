<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Notice</title>
</head>

<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<link rel="stylesheet" href="${root }css/board.css">

<body>

	<div class="sec">
		<h3 class="title">공지사항</h3>
			<table class="table" >
				<thead>
					<tr>
						<th>제목</th>
						<th>내용</th>				
						<th>작성날짜</th>
					</tr>
				</thead>
				<tbody class="main">
					<c:forEach var='allNotice' items="${allNotice }">
					<tr>
						<th>${allNotice.boardTitle}</th>
						<th>${allNotice.boardContents}</th>
						<th>${allNotice.boardRegDate}</th>
					</tr>
					</c:forEach>
				</tbody> 
			</table>
			
	</div>
	
</body>
</html>