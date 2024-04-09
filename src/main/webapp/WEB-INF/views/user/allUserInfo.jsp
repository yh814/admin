<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>사원 리스트</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<c:import url="/WEB-INF/views/include/side_bar.jsp" />
<link rel="stylesheet" href="${root }css/allUserInfo.css">
<link rel="stylesheet" href="${root }css/modal.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="${root}js/allUserInfoTop.js"></script>
<script>
	const emailList = [
		<c:forEach var="email" items="${emailList}" varStatus="status">
		{ detailCD: '${email.detailCD}', detailCdName: '${email.detailCdName}' }<c:if test="${!status.last}">,</c:if>
		</c:forEach>
	];
</script>

<body>

<div class="search-sec">
    <!-- 검색 폼 -->
    <form id="searchForm" class="search-form">
        <p class="search-title">검색조건</p>
        <div class="search-box">
            <div class="search-item">
				<div class="search-item1">
					<p class="mini-title">사원명 : </p>
					<input type="text" id="searchUserName"  name="searchUserName">

					<p class="mini-title">기술등급 : </p>
					<select id="searchUserGrade" name="searchUserGrade">
						<option value="">전체</option>
						<c:forEach var="grade" items="${gradeList}">
							<option value="${grade.detailCD}">${grade.detailCdName}</option>
						</c:forEach>
					</select>

					<p class="mini-title">재직상태 : </p>
					<select id="searchUserStatus" name="searchUserStatus">
						<option value="">전체</option>
						<c:forEach var="status" items="${statusList}">
							<option value="${status.detailCD}">${status.detailCdName}</option>
						</c:forEach>
					</select>
				</div>
				<div class="search-item1">
					<p class="mini-title">입사일 : </p>
					<input type="date" id="searchUserStartDate" name="searchUserStartDate">
					<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
					<input type="date" id="searchUserEndDate" name="searchUserEndDate">
				</div>
            </div>
            
            <div class="search-item-skill">
                <input type="submit" id="searchButton" value="조회" class="search-submit"/>
                <button type="button" id="resetBtn">초기화</button>
            </div>
        </div>
    </form>
</div>

<div class="info-sec">
    <p class="title">사원 리스트</p>
	<div class="showList">
		<table class="table">
			<thead>
				<tr>
					<th><input type="checkbox" id="check-user" class="check-user" /></th>
					<th>사원번호</th>
					<th>사원명</th>
					<th>직급</th>
					<th>입사일</th>
					<th>재직상태</th>
					<th>기술등급</th>
					<th>보유기술</th>
					<th>상세/수정</th>
					<th>프로젝트관리</th>
				</tr>
			</thead>
			<tbody class="main">
				<tr>
					<td colspan="10">검색조건 없이 조회 누르시면 전체 사원을 확인할 수 있습니다</td>
				</tr>
			</tbody>
		</table>
	</div>
    <div class="add-delete-user">
	        <button id="add-user" class="add-user">등록</button>
	        <!-- 회원 등록 모달창 -->
	        	  <form action="addUser" method="post" enctype="multipart/form-data" id="myModal" class="modal">
					    <div class="modal-content">
					        <!-- 닫기버튼 -->
					        <span class="close" id="closeModalBtn">&times;</span>
					
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
												<option value="default">--이메일 도메인--</option>
												<c:forEach var="emailList" items="${emailList}">
													<option value="${emailList.detailCD}">${emailList.detailCdName}</option>
												</c:forEach>
												<option value="direct">--직접 입력--</option>
											</select>
										</div>

								        <span id="userEmailError" class="error-message" ></span>
								    </div>
								
									<!-- 등록버튼 -->
						            <div class="sub-btn">
						                <button type="button" class="sub-form" id="sub-form">등록</button>
						            </div>
					
								</div><!-- right끝 -->

					            
					        </div>
					    </div>
					</form>

				  <button id="user-delete" class="user-delete">삭제</button>
			  </div>
			    <!-- 모달끝 -->

		
</div>

</body>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		document.getElementById('resetBtn').addEventListener('click', function() {
			location.href="${root }user/allUserInfo";
		});
	});

</script>
<script src="${root}js/allUserInfoLower.js"></script>
</html>
