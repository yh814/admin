<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>인원관리</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root }css/proMatch.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>

<script>
    const roleList = [
        <c:forEach items="${roleList}" var="role" varStatus="status">
        {detailCD: "${role.detailCD}", detailCdName: "${role.detailCdName}"}<c:if test="${!status.last}">, </c:if>
        </c:forEach>
    ];

</script>
<body>

<div class="proInfo-sec">
    <p class="proInfo-title">프로젝트 정보</p>
    <div class="proInfo-box">
        <div class="proInfo-item">
            <p class="mini-title">프로젝트명 : </p>
            <input type="text" id="proName"  name="proName" readonly="readonly" class="input-info" value="${proMatchInfo.proName }">
            <p class="mini-title">시작일 : </p>
            <input type="text" id="startDate"  name="startDate" readonly="readonly" class="input-info"  value="${proMatchInfo.startDate }">
            <p class="mini-title">종료일 : </p>
            <input type="text" id="endDate"  name="endDate" readonly="readonly" class="input-info" value="${proMatchInfo.endDate }">
            <p class="mini-title">진행현황 : </p>
            <input type="text" id="progressDetailName"  name="progressDetailName" readonly="readonly" class="input-info" value="${proMatchInfo.progressDetailName }">
        </div>
    </div>
</div>

<div class="userProInfo-sec">
    <p class="proInfo-title">투입인원 리스트</p>
    <div class="showUserList">
        <table class="table">
            <thead>
            <tr>
                <th><input type="checkbox" id="check-match" class="check-match" disabled/></th>
                <th>사원번호</th>
                <th>사원명</th>
                <th>등급</th>
                <th>직급</th>
                <th>투입일</th>
                <th>철수일</th>
                <th>역할</th>
                <th>수정</th>
            </tr>
            </thead>
            <tbody class="main">
            <c:choose>
                <c:when test="${empty proUserList}">
                    <tr>
                        <td colspan="11">데이터가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="match" items="${proUserList}">
                        <tr>
                            <td><input type="checkbox" id="${match.userNum }" class="check-match"/></td>
                            <td>${match.userNum}</td>
                            <td>${match.userName}</td>
                            <td>${match.gradeDetailName}</td>
                            <td>${match.rankDetailName}</td>
                            <td><input type="date" name="inputDate" value="${match.inputDate}" readonly="readonly" required="required"/></td>
                            <td><input type="date" name="witDate" value="${match.witDate}" readonly="readonly"/></td>
                            <td><select id="roleCD" name="roleCD" class="form-control" required="required" disabled="disabled" >
                                <option value="">--역할 선택--</option>
                                <c:forEach var="roleList" items="${roleList}">
                                    <option value="${roleList.detailCD}" ${roleList.detailCD==match.roleCD ? 'selected':''} >${roleList.detailCdName}</option>
                                </c:forEach>
                            </select></td>
                            <td>
                                <button class="match-modify">수정</button>
                                <button class="set-modify" style="display: none;">저장</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div class="pro-btn">
        <button class="add" id="add">인원 추가</button>
        <button class="delete">인원 삭제</button>
    </div>

    <!-- 프로젝트 추가 모달 -->
    <form id="add-modal" class="add-modal">
        <input type="hidden" id="proNum" value="${proMatchInfo.proNum}" data-proNum="${proMatchInfo.proNum}"/>
        <div class="modal">
            <!-- 닫기버튼 -->
            <span class="close" id="closeModalBtn">&times;</span>

            <div class="search-box">
                <p class="search-title">검색조건</p>
                <div class="search-item">
                    <p class="mini-title">사원명 : </p>
                    <input type="text" id="searchUserName"  name="searchUserName">

                    <p class="mini-title">등급 : </p>
                    <select id="searchGradeName" name="searchGradeName">
                        <option value="">전체</option>
                        <c:forEach var="grade" items="${gradeList}">
                            <option value="${grade.detailCD}">${grade.detailCdName}</option>
                        </c:forEach>
                    </select>

                    <p class="mini-title">재직상태 : </p>
                    <select id="searchStatusName" name="searchStatusName">
                        <option value="">전체</option>
                        <c:forEach var="status" items="${statusList}">
                            <option value="${status.detailCD}">${status.detailCdName}</option>
                        </c:forEach>
                    </select>

                </div>

                <div class="search-item-skill">
                    <button type="button" id="searchButton" class="searchButton">조회</button>
                    <button type="button" id="resetBtn" class="resetBtn">초기화</button>
                </div>
            </div><!-- searchbox-div -->

            <div class="search-result">
                <p class="result-title">사원 리스트</p>
                <div class="showList">
                    <table class="result-table">
                        <thead>
                        <tr>
                            <th><input type="checkbox" id="check-user" class="check-user"/></th>
                            <th>사원번호</th>
                            <th>사원명</th>
                            <th>재직상태</th>
                            <th>직급</th>
                            <th>등급</th>
                            <th>보유스킬</th>
                        </tr>
                        </thead>
                        <tbody class="main-search">
                        <c:forEach var="user" items="${allUserList}" >
                            <tr>
                                <td><input type="checkbox"
                                           id="${user.userNum }"
                                           class="check-user"
                                           data-userNum="${user.userNum}"
                                           data-userName="${user.userName}"
                                           data-employmentStatusDetailName="${user.employmentStatusDetailName}"
                                           data-rankDetailName="${user.rankDetailName}"
                                           data-gradeDetailName="${user.gradeDetailName}"
                                           data-skillCD="${user.skillDetailNameList}"/>
                                </td>
                                <td>${user.userNum }</td>
                                <td>${user.userName}</td>
                                <td>${user.employmentStatusDetailName}</td>
                                <td>${user.rankDetailName}</td>
                                <td>${user.gradeDetailName}</td>
                                <td>
                                    <c:forEach var="skill" items="${user.skillDetailNameList}" varStatus="status">
                                        ${skill}${status.last ? '' : ', '}
                                    </c:forEach>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="pagination-main">
                    <button class="add-user">추가</button>
                </div>

            </div>

            <%--추가 리스트--%>

            <div class="add-form">
                <p class="add-title">추가 리스트</p>
                <div class="showList">
                    <form action="addUserMatch" method="post" id="addUserMatchForm">
                        <table class="result-table">
                            <thead>
                            <tr>
                                <th><input type="checkbox" id="add-alluser" class="add-alluser" style="display: none"/></th>
                                <th>사원번호</th>
                                <th>사원명</th>
                                <th>직급</th>
                                <th>등급</th>
                                <th>투입일</th>
                                <th>철수일</th>
                                <th>역할</th>
                                <th><button class="delete-all">&nbsp;❌&nbsp;</button></th>
                            </tr>
                            </thead>
                            <tbody class="add-userMain">

                            </tbody>
                        </table>

                    </form>
                </div>
                <div class="pagination-main">
                    <button class="add-match">등록</button>
                </div>
            </div>


        </div><!-- modal-div -->
    </form>



</div>
</body>
<script src="${root}js/proMatch.js"></script>
</html>