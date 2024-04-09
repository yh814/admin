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
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root}css/board.css">

<body>

	<div class="sec">
		<h3 class="title">사원게시판</h3>
			<div class="search-box">
				<select name="searchCate" id="searchCate">
					<option value="search-default" selected>전체</option>
					<option value="search-title">제목</option>
					<option value="search-detail">내용</option>
					<option value="search-writer">작성자</option>
				</select>
				<input type="text" class="search-input">
				<button class="search-btn">검색</button>
			</div>

			<div class="showList">
				<table class="table" >
					<thead>
					<tr>
						<th>제목</th>
						<th>내용</th>
						<th>작성자</th>
						<th>작성날짜</th>
					</tr>
					</thead>
					<tbody class="main">
					<c:forEach var='allFreeBoard' items="${allFreeBoard }">
						<tr>
							<td>${allFreeBoard.boardTitle}</td>
							<td>${allFreeBoard.boardContents}</td>
							<td>${allFreeBoard.userId}</td>
							<td>${allFreeBoard.boardRegDate}</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>

			 
	</div>
</body>
<script src="${root}js/freeBoard.js"></script>
</html>