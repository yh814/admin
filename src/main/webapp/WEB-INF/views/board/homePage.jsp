<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>HomePage</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root }css/homePage.css">

<body>

<div class="board">

    <div class="sec1">
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
            <c:forEach var='notice' items="${noticeList }">
                <tr>
                    <th>${notice.boardTitle}</th>
                    <th>${notice.boardContents}</th>
                    <th>${notice.boardRegDate}</th>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <a href="${root}board/notice">
            <button class="board-plus">더보기</button>
        </a>
    </div>

    <div class="sec2">
        <h3 class="title">사원게시판</h3>
        <table class="table" >
            <thead>
            <tr>
                <th>제목</th>
                <th>내용</th>
                <th>작성날짜</th>
            </tr>
            </thead>
            <tbody class="main">
            <c:forEach var='freeBoard' items="${freeBoardList }">
                <tr>
                    <th>${freeBoard.boardTitle}</th>
                    <th>${freeBoard.boardContents}</th>
                    <th>${freeBoard.boardRegDate}</th>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <a href="${root}board/freeBoard">
            <button class="board-plus">더보기</button>
        </a>
    </div>

</div>

</body>
</html>