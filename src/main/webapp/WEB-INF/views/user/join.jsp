<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var='root' value="${pageContext.request.contextPath }/" />


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Join</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="${root }css/modal.css">
<style>
	body {
		font-family: Arial, sans-serif;
		background: linear-gradient(to right, #7F7FD5, #86A8E7, #91EAE4);
		margin: 0;
		padding: 0;
		height: 700px;
		display: flex;
		align-items: center;
		justify-content: center;
	}
</style>
<body>

<form action="addUser" method="post" enctype="multipart/form-data" id="myModal" class="join">
	<div class="modal-content">
		<!-- 메인 -->
		<div class="modalMain">
			<!-- 이미지 -->
			<div class="userImg">
				<img src="${root}image/pre-photo.png" id="previewImg" alt="기본이미지" style="width: 150px; height: 200px;"/>
				<input type="file" accept="image/gif, image/jpeg, image/png" class="getImg" id="userImgFile" name="userImgFile" required="required"/>
				<span id="userImgError" class="error-message" ></span>
			</div>

			<!-- 왼쪽 -->
			<div class="left">
				<div class="block">
					<span class="block">* 표시가 있는 칸은 필수 입력입니다.</span>
				</div>
				<!-- 사원명 -->
				<div class="form-group">
					<label for="userName">사원명&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="text" id="userName" name="userName" class="form-control" placeholder="2~10자 사이로 입력해주세요" required="required"/>
					<span id="userNameError" class="error-message" ></span>
				</div>

				<!-- 아이디 -->
				<div class="form-group">
					<label for="userId">아이디&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<div class="id-sec">
						<input type="text" id="userId" name="userId" class="form-control" placeholder="5~20자의 영문 소문자, 숫자와 특수기호(_),(-)만 사용해주세요" required="required"/>
						<button type="button" class="checkId" id ="checkId">중복체크</button>
					</div>
					<span id="userIdError" class="error-message" ></span>
				</div>

				<!-- 비밀번호 -->
				<div class="form-group">
					<label for="userPw">비밀번호&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="password" id="userPw" name="userPw" class="form-control" placeholder="8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요" required="required"/>
					<span id="userPwError" class="error-message"></span>
				</div>

				<!-- 비밀번호 확인 -->
				<div class="form-group">
					<label for="userPw2">비밀번호 확인&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="password" id="userPw2" name="userPw2" class="form-control" required="required"/>
					<span id="userPw2Error" class="error-message" ></span>
				</div>

				<!-- 생년월일 -->
				<div class="form-group">
					<label for="userBirth">생년월일&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="date" id="userBirth" name="userBirth" placeholder="생년월일은 8자리의 숫자로 입력해 주세요. ex)1990-01-01" required="required"/>
					<span id="userBirthError" class="error-message" ></span>
				</div>

				<!-- 성별 -->
				<div class="form-group">
					<label for="sexCD">성별&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<select id="sexCD" name="sexCD" class="form-control" required="required">
						<option value="default">--성별 선택--</option>
						<c:forEach var="sexList" items="${sexList}">
							<option value="${sexList.detailCD}">${sexList.detailCdName}</option>
						</c:forEach>
					</select>
					<span id="sexCDError" class="error-message" ></span>
				</div>

				<!-- 주소 -->
				<div class="form-group">
					<label for="addr">주소&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="text" id="addr" name="addr" class="form-control" required="required"/>
					<span id="addrError" class="error-message"></span>
				</div>

				<!-- 상세주소 -->
				<div class="form-group">
					<label for="addrDetail">상세주소</label>
					<input type="text" id="addrDetail" name="addrDetail" class="form-control" />
					<span id="addrDetailError" class="error-message" ></span>
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
					<span id="skillCDError" class="error-message" ></span>
				</div>

			</div><!-- left끝 -->

			<div class="right">
				<div class="block"></div>
				<!-- 입사일 -->
				<div class="form-group2">
					<label for="startDate">입사일&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="date" id="startDate" name="startDate" class="form-control" required="required"/>
					<span id="startDateError" class="error-message"></span>
				</div>

				<!-- 재직상태 -->
				<div class="form-group2">
					<label for="userStatusCD">재직상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<select id="userStatusCD" name="userStatusCD" class="form-control" required="required">
						<option value="default">--재직상태 선택--</option>
						<c:forEach var="statusList" items="${statusList}">
							<option value="${statusList.detailCD}">${statusList.detailCdName}</option>
						</c:forEach>
					</select>
					<span id="userStatusCDError" class="error-message" ></span>
				</div>

				<!-- 계약상태 -->
				<div class="form-group2">
					<label for="conStatusCD">계약상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<select id="conStatusCD" name="conStatusCD" class="form-control" required="required">
						<option value="default">--계약상태 선택--</option>
						<c:forEach var="conStatusList" items="${conStatusList}">
							<option value="${conStatusList.detailCD}">${conStatusList.detailCdName}</option>
						</c:forEach>
					</select>
					<span id="conStatusCDError" class="error-message"></span>
				</div>

				<!-- 직급 -->
				<div class="form-group2">
					<label for="userRankCD">직급&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<select id="userRankCD" name="userRankCD" class="form-control" required="required">
						<option value="default">--직급 선택--</option>
						<c:forEach var="userRankList" items="${userRankList}">
							<option value="${userRankList.detailCD}">${userRankList.detailCdName}</option>
						</c:forEach>
					</select>
					<span id="userRankCDError" class="error-message" ></span>
				</div>

				<!-- 기술등급 -->
				<div class="form-group2">
					<label for="userGradeCD">기술등급&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<select id="userGradeCD" name="userGradeCD" class="form-control" required="required">
						<option value="default">--기술등급 선택--</option>
						<c:forEach var="gradeList" items="${gradeList}">
							<option value="${gradeList.detailCD}">${gradeList.detailCdName}</option>
						</c:forEach>
					</select>
					<span id="userGradeCDError" class="error-message" ></span>
				</div>

				<!-- 연봉 -->
				<div class="form-group2">
					<label for="salary">연봉&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<div class="input-group">
						<div class="input-group-append">
							<input type="text" id="salary" name="salary" class="form-control" placeholder="(,)없이 숫자로만 입력해주세요" required="required"/>

							<span class="input-group-text">&nbsp;&nbsp;만원</span>
						</div>
						<span id="salaryError" class="error-message" ></span>
					</div>
				</div>

				<!-- 전화번호 -->
				<div class="form-group2">
					<label for="userPhone">전화번호&nbsp;<span class="necessary" style="color:red;">*</span></label>
					<input type="text" id="userPhone" name="userPhone" class="form-control" placeholder="번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000" required="required"/>
					<span id="userPhoneError" class="error-message" ></span>
				</div>

				<!-- 이메일 -->
				<div class="form-group2">
					<label for="userEmail">이메일</label>
					<div class="email-input">
						<input type="text" id="userEmail" name="userEmail" class="form-control" />&nbsp;&nbsp;@&nbsp;&nbsp;
						<input type="text" id="directInput" name="userEmail2" class="form-control">
						<div id="autocompletePreview" class="autocompletePreview" style="color: gray;"></div>
						<select class="form-control3" onchange="decovery(this);">
							<option value="default">--직접 입력--</option>
							<c:forEach var="emailList" items="${emailList}">
								<option value="${emailList.detailCD}">${emailList.detailCdName}</option>
							</c:forEach>

						</select>
					</div>

					<span id="userEmailError" class="error-message" ></span>
				</div>

				<!-- 등록버튼 -->
				<div class="sub-btn">
					<button type="button" class="sub-form" id="sub-form">가입하기</button>
					<button type="button" class="sub-form" id="back-form">돌아가기</button>
				</div>


			</div><!-- right끝 -->


		</div>
	</div>
</form>

</body>
<script src="${root}js/allUserInfoLower.js"></script>
<script>
	$(document).ready(function() {
		const backBtn = document.getElementById("back-form");
		$('#back-form').click(function (){
			window.location.href="/login";
		});
	});
</script>
</html>








