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
    <title>사원-프로젝트 관리</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root }css/userMatch.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>

<script>
	const roleList = [
		<c:forEach items="${roleList}" var="role" varStatus="status">
		{detailCD: "${role.detailCD}", detailCdName: "${role.detailCdName}"}<c:if test="${!status.last}">, </c:if>
		</c:forEach>
	];
</script>
<body>

<div class="userInfo-sec">
	<p class="userInfo-title">사원정보</p>
	<div class="userInfo-box">
		<div class="userInfo-item">
			<p class="mini-title">사원명 : </p>
	                <input type="text" id="userName"  name="userName" readonly="readonly" class="input-info" value="${userMatchInfo.userName }">
	                <p class="mini-title">기술등급 : </p>
	                <input type="text" id="rankDetailName"  name="rankDetailName" readonly="readonly" class="input-info"  value="${userMatchInfo.rankDetailName }">
	                <p class="mini-title">직급 : </p>
	                <input type="text" id="gradeDetailName"  name="gradeDetailName" readonly="readonly" class="input-info" value="${userMatchInfo.gradeDetailName }">
	            </div>
	        </div>	    
	</div>

	
	<div class="userProInfo-sec">
		<p class="userInfo-title">프로젝트 리스트</p>
		<div class="showProList">
			<table class="table">
				<thead>
					<tr>
						<th><input type="checkbox" id="check-match" class="check-match" disabled/></th>
						<th>프로젝트번호</th>
						<th>프로젝트명</th>
						<th>고객사명</th>
						<th>진행현황</th>
						<th>프로젝트 시작일</th>
						<th>프로젝트 종료일</th>
						<th>투입일</th>
						<th>철수일</th>
						<th>역할</th>
						<th>수정</th>
					</tr>
				</thead>
				<tbody class="main">
					<c:choose>
						<c:when test="${empty userProList}">
							<tr>
								<td colspan="11">데이터가 없습니다.</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="match" items="${userProList}">
								<tr>
									<td><input type="checkbox" id="${match.proNum }" class="check-match"/></td>
									<td>${match.proNum}</td>
									<td>${match.proName}</td>
									<td>${match.cusDetailName}</td>
									<td>${match.progressDetailName}</td>
									<td>${match.startDate}</td>
									<td>${match.endDate}</td>
									<td><input type="date" name="inputDate" value="${match.inputDate}" readonly="readonly" required="required"/></td>
									<td><input type="date" name="witDate" value="${match.witDate}" readonly="readonly"/></td>
									<td><select id="roleCD" name="roleCD" class="form-control" required="required" disabled="disabled" >
										<option value="">--성별 선택--</option>
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
			<button class="add" id="add">프로젝트 추가</button>
			<button class="delete">프로젝트 삭제</button>
		</div>
			<!-- 프로젝트 추가 모달 -->
				<form id="add-modal" class="add-modal">
					<input type="hidden" id="userNum" value="${userMatchInfo.userNum}" data-userNum="${userMatchInfo.userNum}"/>
					<div class="modal">
						<!-- 닫기버튼 -->
						<span class="close" id="closeModalBtn">&times;</span>
												
				        <div class="search-box">
				      		<p class="search-title">검색조건</p>
				            <div class="search-item">
				                <p class="mini-title">프로젝트명 : </p>
				                <input type="text" id="searchProName"  name="searchProName">
				
				                <p class="mini-title">고객사 : </p>
				                <select id="searchCusName" name="searchCusName">
				                    <option value="">전체</option>
				                    <c:forEach var="cus" items="${cusList}">
				                        <option value="${cus.detailCD}">${cus.detailCdName}</option>
				                    </c:forEach>
				                </select>
				
				                <p class="mini-title">진행상태 : </p>
				                <select id="searchProgressName" name="searchProgressName">
				                    <option value="">전체</option>
				                    <c:forEach var="progress" items="${progressList}">
				                        <option value="${progress.detailCD}">${progress.detailCdName}</option>
				                    </c:forEach>
				                </select>			
				            </div>
				            
				            <div class="search-item-skill">
				                <button type="button" id="searchButton" class="searchButton">조회</button>
				                <button type="button" id="resetBtn" class="resetBtn">초기화</button>				                
				            </div>
				        </div><!-- searchbox-div -->
				        
				        <div class="search-result">
				        	<p class="result-title">프로젝트 리스트</p>
							<div class="showList">
								<table class="result-table">
									<thead>
										<tr>
											<th><input type="checkbox" id="check-pro" class="check-pro"/></th>
											<th>프로젝트 번호</th>
											<th>프로젝트명</th>
											<th>고객사</th>
											<th>시작일</th>
											<th>종료일</th>
											<th>진행상태</th>
											<th>총인원</th>
										</tr>
									</thead>
									<tbody class="main-search">
										<c:forEach var="project" items="${allProList}" >
											<tr>
												<td><input type="checkbox" id="${project.proNum }" class="check-pro"
													data-proNum="${project.proNum}"
													data-proName="${project.proName}"
													data-progressDetailName="${project.progressDetailName}"
													data-startDate="${project.startDate}"
													data-endDate="${project.endDate}"/>
												</td>
												<td>${project.proNum}</td>
												<td>${project.proName}</td>
												<td>${project.cusDetailName}</td>
												<td>${project.startDate}</td>
												<td>${project.endDate}</td>
												<td>${project.progressDetailName}</td>
												<td>${project.userCnt}명</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						    <div class="pagination-main">
								<button class="add-pro">추가</button>
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
											<th><input type="checkbox" id="add-allpro" class="add-allpro" style="display: none"/></th>
											<th>프로젝트 번호</th>
											<th>프로젝트명</th>
											<th>시작일</th>
											<th>종료일</th>
											<th>진행상태</th>
											<th>투입일</th>
											<th>철수일</th>
											<th>역할</th>
											<th><button class="delete-all">&nbsp;❌&nbsp;</button></th>
										</tr>
										</thead>
										<tbody class="add-proMain">

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
<script src="${root}js/userMatch.js"></script>
</html>