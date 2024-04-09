
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root }css/projectInfo.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="${root}js/projectTop.js"></script>
<body>
<!-----------------------------------------------------------------  검색 필터  ----------------------------------------------------------------->
<div class="search-sec">
	<form id="searchForm" class="search-form">
		<p class="search-title">검색조건</p>
		<div class="search-box">
			<div class="search-item">
				<p class="mini-title">프로젝트명 : </p>
				<input type="text" id="searchProName" name="searchProName">
				
				<p class="mini-title">고객사명 : </p>			
					<select id="searchProCust" name="searchProCust">
						<option value="">전체</option>
						<c:forEach var="cusList" items="${cusList}">
					    	<option value="${cusList.detailCD}">${cusList.detailCdName}</option>
					    </c:forEach>
					</select>

			</div>
			<div class="search-item">
				<div class="start">
					<p class="mini-title">시작일 : </p>
					<input type="date" id="searchStartDate1" name="searchStartDate1"/>
					<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
					<input type="date" id="searchStartDate2" name="searchStartDate2"/>
				</div>
				<div class="start">
					<p class="mini-title">종료일 : </p>
					<input type="date" id="searchEndDate1" name="searchEndDate1"/>
					<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
					<input type="date" id="searchEndDate2" name="searchEndDate2"/>
				</div>
			</div>
			<div class="search-item-skill">
			
				<input type="submit" value="검색" class="search-submit"/>
				<button type="button" id="resetBtn">초기화</button>
			</div>
		</div>
	</form>
</div>


<!-----------------------------------------------------------------  프로젝트 리스트 출력  ----------------------------------------------------------------->
<div class="info-sec">
	<p class="title">프로젝트 리스트</p>
	<div class="paging-option">
	<select name="paging" id="paging" style="width: 100px;height: 30px;" class="paging">
		<option value="5">5개</option>
		<option value="10">10개</option>
		<option value="15">15개</option>
	</select>
	</div>
	<div class="pro-showList">
		<table class="table" >
			<thead>
				<tr>
					<th><input type="checkbox" id="check-pro" class="check-pro" disabled/></th>
					<th>프로젝트 번호</th>
					<th>프로젝트명</th>
					<th>고객사명</th>
					<th>진행현황</th>
					<th>시작일</th>
					<th>종료일</th>
					<th>필요기술</th>
					<th>상세/수정</th>
					<th>투입인원</th>
				</tr>
			</thead>
			<tbody class="main">
				<tr>
					<td colspan="10">검색조건 없이 조회 누르시면 전체 프로젝트를 확인할 수 있습니다</td>
				</tr>
			</tbody>

		</table>
	</div>
	<div class="pagination">

	</div>
	<div class="add-delete-pro">
		<button id="add-pro" class="add-pro">등록</button>
		<!-- 회원 등록 모달창 -->
		<form action="addPro" method="post" enctype="multipart/form-data" id="myModal" class="modal">
			<div class="modal-content">
				<!-- 닫기버튼 -->
				<span class="close" id="closeModalBtn">&times;</span>

				<!-- 메인 -->
				<div class="modalMain">

					<!-- 왼쪽 -->
					<div class="left">
						<div class="block">
							<span class="block">* 표시가 있는 칸은 필수 입력입니다.</span>
						</div>
						<!-- 사원명 -->
						<div class="form-group">
							<label for="proName">프로젝트명&nbsp;<span class="necessary" style="color:red;">*</span></label>
							<input type="text" id="proName" name="proName" class="form-control" placeholder="2~20자 사이로 입력해주세요" required="required"/>
							<span id="proNameError" class="error-message" ></span>
						</div>

						<!-- 고객사 -->
						<div class="form-group">
							<label for="cusCD">고객사&nbsp;<span class="necessary" style="color:red;">*</span></label>
							<select id="cusCD" name="cusCD" class="form-control" required="required">
								<option value="default">--고객사 선택--</option>
								<c:forEach var="cusList" items="${cusList}">
									<option value="${cusList.detailCD}">${cusList.detailCdName}</option>
								</c:forEach>
							</select>
							<span id="cusCDError" class="error-message" ></span>
						</div>

						<!-- 진행상태 -->
						<div class="form-group">
							<label for="progressCD">진행상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
							<select id="progressCD" name="progressCD" class="form-control" required="required">
								<option value="default">--진행상태 선택--</option>
								<c:forEach var="progressList" items="${progressList}">
									<option value="${progressList.detailCD}">${progressList.detailCdName}</option>
								</c:forEach>
							</select>
							<span id="progressCDError" class="error-message" ></span>
						</div>

						<%--시작일--%>
						<div class="form-group">
							<label for="startDate">시작일&nbsp;<span class="necessary" style="color:red;">*</span></label>
							<input type="date" id="startDate" name="startDate" class="form-control" required="required"/>
							<span id="startDateError" class="error-message"></span>
						</div>

						<%--종료일--%>
						<div class="form-group">
							<label for="endDate">종료일&nbsp;<span class="necessary" style="color:red;">*</span></label>
							<input type="date" id="endDate" name="endDate" class="form-control"/>
							<span id="endDateError" class="error-message"></span>
						</div>

						<!-- 보유스킬 -->
						<div class="form-group3">
							<label>보유스킬&nbsp;&nbsp;&nbsp;<span class="necessary" style="color:red;">*&nbsp;&nbsp;</span>&nbsp;:&nbsp;&nbsp;&nbsp;</label>
							<c:forEach var="skillList" items="${skillList}">
								<label class="skill" for="skill_${skillList.detailCD}">
									<input type="checkbox" id="skill_${skillList.detailCD}" name="skillCD" value="${skillList.detailCD}"/>
										${skillList.detailCdName}
								</label>
							</c:forEach>

						</div><span id="skillCDError" class="error-message" ></span>

					</div><!-- left끝 -->

					<div class="right">
						<div class="block"></div>

						<!-- 담당자 -->
						<div class="form-group2">
							<label for="manager">담당자</label>
							<div class="input-group">
								<input type="text" id="manager" name="manager" class="form-control" placeholder="2글자 이상의 영어나 한글로 작성해주세요" />
								<span id="managerError" class="error-message" ></span>
							</div>
						</div>

						<!-- 전화번호 -->
						<div class="form-group2">
							<label for="mPhone">전화번호</label>
							<input type="text" id="mPhone" name="mPhone" class="form-control" placeholder="번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000" />
							<span id="mpPhoneError" class="error-message" ></span>
						</div>

						<%--비고--%>
						<div class="form-group4">
							<label for="note">비고</label>
							<textarea id="note" name="note" class="note" placeholder="300자 이하로 입력해주세요" required="required"></textarea>
							<%--입력글자수--%>
							<span id="input-count" class="input-count">0 / 300</span>
							<span id="noteError" class="error-message" ></span>
						</div>


						<!-- 등록버튼 -->
						<div class="sub-btn">
							<button type="button" class="sub-form" id="sub-form">등록</button>
						</div>

					</div><!-- right끝 -->


				</div>
			</div>
		</form>
		<button id="pro-delete" class="pro-delete">삭제</button>
	</div>


</div>
</body>
<script src="${root}js/projectLower.js"></script>
<script>
	$(document).on('click','#resetBtn' ,function (event){
		event.preventDefault();
		window.location.reload();
	});

</script>
</html>