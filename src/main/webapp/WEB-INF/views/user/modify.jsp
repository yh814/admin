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
<script>
	const emailList = [
		<c:forEach var="email" items="${emailList}" varStatus="status">
		{ detailCD: '${email.detailCD}', detailCdName: '${email.detailCdName}' }<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];
</script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root}css/modify.css">
<body>

<div class="modify-sec">
	<form action="${root}/modify_user" method="post" enctype="multipart/form-data" id="modify" class="modify">
		<div class="modal-content">
			<!-- 메인 -->
			<div class="modalMain">
				<!-- 이미지 -->
				<div class="userImg">
					<div class="block">
						<span class="block">* 표시가 있는 칸은 필수 입력입니다.</span>
					</div>
					<span class="img-title">프로필 이미지</span>
					<img src="${root}upload/${userInfo.userImg}" id="previewImg" alt="기본이미지" style="width: 150px; height: 200px;"/>
					<input type="file" accept="image/gif, image/jpeg, image/png" class="getImg" id="userImgFile" name="userImgFile" style="display:none;"/>
					<div class="img-btns">
						<label for="userImgFile" class="btn btn-primary">이미지 변경</label>
						<button class="remove-img">되돌리기</button>
					</div>
					<input type="hidden" id="existingImg" name="existingImg" value="${userInfo.userImg}" />
					<span id="userImgError" class="error-message" ></span>
					<div class="userInfo-default">
						<label for="userNum">사원번호</label>
						<input type="text" id="userNum" name="userNum" class="form-control" readonly="readonly" style="background-color: lightgray" value="${userInfo.userNum}"/>
					</div>
					<!-- 아이디 -->
					<div class="userInfo-default">
						<label for="userId">아이디</label>
						<div class="id-sec">
							<input type="text" id="userId" name="userId" class="form-control" placeholder="" readonly="readonly" style="background-color: lightgray;" value="${userInfo.userId}"/>
						</div>
					</div>
				</div>

				<!-- 왼쪽 -->
				<div class="left">
					<!-- 사원명 -->
					<div class="form-group">
						<label for="userName">사원명&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="text" id="userName" name="userName" class="form-control" placeholder="2~10자 사이로 입력해주세요" required="required" value="${userInfo.userName}"/>
						<span id="userNameError" class="error-message" ></span>
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
						<input type="date" id="userBirth" name="userBirth" class="form-control" placeholder="생년월일은 8자리의 숫자로 입력해 주세요. ex)1990-01-01" required="required" value="${userInfo.userBirth}"/>
						<span id="userBirthError" class="error-message" ></span>
					</div>

					<!-- 성별 -->
					<div class="form-group">
						<label for="sexCD">성별&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="sexCD" name="sexCD" class="form-control" required="required">
							<option value="">--성별 선택--</option>
							<c:forEach var="sexList" items="${sexList}">
								<option value="${sexList.detailCD}" ${sexList.detailCD==userInfo.sexCD ? 'selected':''} >${sexList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="sexCDError" class="error-message" ></span>
					</div>

					<!-- 주소 -->
					<div class="form-group">
						<label for="addr">주소&nbsp;<span class="necessary" style="color:red;">*</span></label><div>
						<input type="text" id="addr" name="addr" class="form-control" required="required" value="${userInfo.addr}"/>
						<button id="search-addr" onclick="execDaumPostcode()">주소 검색</button>
						</div>
						<span id="addrError" class="error-message"></span>
					</div>

					<!-- 상세주소 -->
					<div class="form-group">
						<label for="addrDetail">상세주소</label>
						<input type="text" id="addrDetail" name="addrDetail" class="form-control" value="${userInfo.addrDetail}"/>
						<span id="addrDetailError" class="error-message" ></span>
					</div>

					<!-- 보유스킬 -->
					<div class="form-group3">
						<label>보유스킬&nbsp;&nbsp;&nbsp;<span class="necessary" style="color:red;">*&nbsp;&nbsp;</span>&nbsp;:&nbsp;&nbsp;&nbsp;</label>
						<input type="hidden" id="getUserSkills" value="${userInfo.skillCD}">
						<c:forEach var="skillList" items="${skillList}">
							<label class="skill" for="skill_${skillList.detailCD}">
								<input type="checkbox" id="skill_${skillList.detailCD}" name="skillCD" value="${skillList.detailCD}" ${fn:contains(userInfo.skillCD,skillList.detailCdName) ? 'checked' : ''}/>
									${skillList.detailCdName}
							</label>
						</c:forEach>
						<span id="skillCDError" class="error-message" ></span>
					</div>

				</div><!-- left끝 -->

				<div class="right">
					<!-- 입사일 -->
					<div class="form-group2">
						<label for="startDate">입사일&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="date" id="startDate" name="startDate" class="form-control" required="required" value="${userInfo.startDate}"/>
						<span id="startDateError" class="error-message"></span>
					</div>

					<!-- 재직상태 -->
					<div class="form-group2">
						<label for="userStatusCD">재직상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="userStatusCD" name="userStatusCD" class="form-control" required="required">
							<option value="">--재직상태 선택--</option>
							<c:forEach var="statusList" items="${statusList}">
								<option value="${statusList.detailCD}" ${statusList.detailCD == userInfo.userStatusCD ? 'selected':''}>${statusList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="userStatusCDError" class="error-message" ></span>
					</div>

					<!-- 계약상태 -->
					<div class="form-group2">
						<label for="conStatusCD">계약상태&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="conStatusCD" name="conStatusCD" class="form-control" required="required">
							<option value="">--계약상태 선택--</option>
							<c:forEach var="conStatusList" items="${conStatusList}">
								<option value="${conStatusList.detailCD}" ${conStatusList.detailCD == userInfo.conStatusCD ? 'selected':''}>${conStatusList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="conStatusCDError" class="error-message"></span>
					</div>

					<!-- 직급 -->
					<div class="form-group2">
						<label for="userRankCD">직급&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="userRankCD" name="userRankCD" class="form-control" required="required">
							<option value="">--직급 선택--</option>
							<c:forEach var="userRankList" items="${userRankList}">
								<option value="${userRankList.detailCD}" ${userRankList.detailCD == userInfo.userRankCD ? 'selected':''}>${userRankList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="userRankCDError" class="error-message" ></span>
					</div>

					<!-- 기술등급 -->
					<div class="form-group2">
						<label for="userGradeCD">기술등급&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<select id="userGradeCD" name="userGradeCD" class="form-control" required="required">
							<option value="">--기술등급 선택--</option>
							<c:forEach var="gradeList" items="${gradeList}">
								<option value="${gradeList.detailCD}" ${gradeList.detailCD == userInfo.userGradeCD ? 'selected':''}>${gradeList.detailCdName}</option>
							</c:forEach>
						</select>
						<span id="userGradeCDError" class="error-message" ></span>
					</div>

					<!-- 연봉 -->
					<div class="form-group2">
						<label for="salary">연봉&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<div class="input-group">
							<div class="input-group-append">
								<input type="text" id="salary" name="salary" class="form-control" placeholder="(,)없이 숫자로만 입력해주세요" required="required" value="${userInfo.salary}"/>

								<span class="input-group-text">만원</span>
							</div>
							<span id="salaryError" class="error-message" ></span>
						</div>
					</div>

					<!-- 전화번호 -->
					<div class="form-group2">
						<label for="userPhone">전화번호&nbsp;<span class="necessary" style="color:red;">*</span></label>
						<input type="text" id="userPhone" name="userPhone" class="form-control" placeholder="번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000" required="required" value="${userInfo.userPhone}"/>
						<span id="userPhoneError" class="error-message" ></span>
					</div>

					<!-- 이메일 -->
					<div class="form-group2">
						<label for="userEmail">이메일</label>
						<div class="email-input">
							<input type="text" id="userEmail" name="userEmail" class="form-control" value="${userInfo.userEmail}" />&nbsp;&nbsp;@&nbsp;&nbsp;
							<input type="text" id="directInput" name="userEmail2" class="form-control" value="${userInfo.userEmail2}">
							<div id="autocompletePreview" class="autocompletePreview" style="color: gray;"></div>
							<select class="form-control" onchange="decovery(this);">
								<option value="default">--직접 입력--</option>
								<c:forEach var="emailList" items="${emailList}">
									<option value="${emailList.detailCD}">${emailList.detailCdName}</option>
								</c:forEach>

							</select>
						</div>
					</div>
					<div class="email-errors">
						<span id="userEmailError" class="error-message" ></span>
						<span id="userEmail2Error" class="error-message" ></span>
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

<script src="${root}js/modify.js"></script>
</html>








