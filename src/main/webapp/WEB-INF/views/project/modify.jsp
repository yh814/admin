<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Modify</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root}css/proModify.css">
<body>

<div class="modify-sec">
	<form action="${root}/modify_pro" method="post" enctype="multipart/form-data" id="modify" class="modify">
		<div class="modal-content">
			<!-- 메인 -->
			<div class="modalMain">
				<!-- 왼쪽 -->
				<div class="left">
					<div class="block">
						<span class="block">* 표시가 있는 칸은 필수 입력입니다.</span>
					</div>

					<div class="form-group">
						<label for="proNum">프로젝트번호</label>
						<input type="text" id="proNum" name="proNum" class="form-control" readonly="readonly" style="background-color: lightgray" value="${proInfo.proNum}"/>
					</div>

					<!-- 프로젝트명 -->
					<div class="form-group">
						<label for="proName">프로젝트명&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="text" id="proName" name="proName" class="form-control" placeholder="2~20자 사이로 입력해주세요" required="required" value="${proInfo.proName}"/>
						<span id="proNameError" class="error-message" ></span>
					</div>

					<div class="form-group2">
						<label for="cusCD">고객사&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="cusCD" name="cusCD" class="form-control" required="required">
							<option value="">--고객사 선택--</option>
							<c:forEach var="cusList" items="${cusList}">
								<option value="${cusList.detailCD}" ${cusList.detailCD == proInfo.cusCD ? 'selected':''}>${cusList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="cusCDError" class="error-message"></span>
					</div>

					<div class="form-group2">
						<label for="progressCD">진행상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="progressCD" name="progressCD" class="form-control" required="required">
							<option value="">--진행상태 선택--</option>
							<c:forEach var="progressList" items="${progressList}">
								<option value="${progressList.detailCD}" ${progressList.detailCD == proInfo.progressCD ? 'selected':''}>${progressList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="progressCDError" class="error-message"></span>
					</div>

					<!-- 시작일 -->
					<div class="form-group">
						<label for="startDate">시작일&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="date" id="startDate" name="startDate" class="form-control" required="required" value="${proInfo.startDate}"/>
						<span id="startDateError" class="error-message"></span>
					</div>

					<!-- 종료일 -->
					<div class="form-group">
						<label for="endDate">종료일&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="date" id="endDate" name="endDate" class="form-control" required="required" value="${proInfo.endDate}"/>
						<span id="endDateError" class="error-message"></span>
					</div>

					<!-- 보유스킬 -->
					<div class="form-group3">
						<label>보유스킬&nbsp;&nbsp;&nbsp;<span class="necessary" style="color:red;">*&nbsp;&nbsp;</span>&nbsp;:&nbsp;&nbsp;&nbsp;</label>
						<input type="hidden" id="getProSkills" value="${proInfo.skillCD}">
						<c:forEach var="skillList" items="${skillList}">
							<label class="skill" for="skill_${skillList.detailCD}">
								<input type="checkbox" id="skill_${skillList.detailCD}" name="skillCD" value="${skillList.detailCD}" ${fn:contains(proInfo.skillCD,skillList.detailCdName) ? 'checked' : ''}/>
									${skillList.detailCdName}
							</label>
						</c:forEach>
						<br>
						<span id="skillCDError" class="error-message" ></span>
					</div>

				</div><!-- left끝 -->

				<div class="right">

					<!-- 담당자 -->
					<div class="form-group">
						<label for="manager">담당자</label>
						<input type="text" id="manager" name="manager" class="form-control" placeholder="2~10자 사이로 입력해주세요" value="${proInfo.manager}"/>
						<span id="managerError" class="error-message" ></span>
					</div>

					<!-- 전화번호 -->
					<div class="form-group2">
						<label for="mPhone">전화번호</label>
						<input type="text" id="mPhone" name="mPhone" class="form-control" placeholder="번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000"  value="${proInfo.MPhone}"/>
						<span id="mPhoneError" class="error-message" ></span>
					</div>

					<%--비고--%>
					<div class="form-group4">
						<label for="note">비고</label>
						<textarea id="note" name="note" class="note" placeholder="300자 이하로 입력해주세요" required="required" value="${proInfo.note}"></textarea>
						<%--입력글자수--%>
						<span id="input-count" class="input-count">0 / 300</span>
						<span id="noteError" class="error-message" ></span>
					</div>

					<!-- 등록버튼 -->
					<div class="sub-btn">
						<button type="button" class="sub-form" id="sub-form">수정</button>
					</div>

				</div><!-- right끝 -->


			</div>
		</div>
	</form>
</div>

</body>
<script src="${root}js/proModify.js"></script>
</html>








