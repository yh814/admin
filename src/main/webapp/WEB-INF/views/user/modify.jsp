<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var='root' value="${pageContext.request.contextPath }/" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Modify</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	document.getElementById('uploadImg').addEventListener('click', function(){
		document.getElementById('fileInput').click();
	});
	
	document.getElementById('fileInput').addEventListener('change', function(){
		var fileName = this.value.split('\\').pop();
		alert(fileName+ " 파일이 선택되었습니다.")
	})



</script>
</head>

<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<link rel="stylesheet" href="${root }css/modify.css">
<body>

					<div class="modify-sec">
						<form action="${root }user/modify_pro" method="post"  class="form" >
						
						<div class="userImg">
							<img src="${root }image/pre-photo.png" alt="기본이미지" style="width: 150px; height: 200px;"/>
							<input type="file"  id="fileInput" style="display: none;"/>
							<button class="getImg" value="choose-file" id="uploadImg">파일선택</button>
						
						</div>
						
						<!-- 왼쪽 -->
							<div class="left">
								<p>${userInfo.userNum }</p>
								<div class="form-group">
									<label for="userNum">사원번호</label> 
									<input type="text" id="userNum" class="form-control" value="${userInfo.userNum }" readonly="readonly" />
								</div>
								<div class="form-group">
									<label for="userName">사원명</label> 
									<input type="text" id="userName" name="userName" class="form-control" value="${userInfo.userName }" />
								</div>
								<div class="form-group">
									<label for="userId">아이디</label> 
									<input type="text" id="userId" name="userId" class="form-control" value="${userInfo.userId }" readonly="readonly"  />
								</div>
								<div class="form-group">
									<label for="userPw">비밀번호</label> 
									<input type="password" id="userPw" name="userPw" class="form-control" value="" />
								</div>
								<div class="form-group">
									<label for="userPw2">비밀번호 확인</label> 
									<input type="password" id="userPw2" name="userPw2" class="form-control" value="" />
								</div>
								<div class="form-group">
									<label for="userBirth">생년월일</label> 
									<input type="date" id="userBirth" name="userBirth"/>
								</div>
								<div class="form-group">
									<label for="sexCD">성별</label> 
									<select id="sexCD" name="sexCD">
										<c:forEach var="sexList" items="${sexList}">
										    	<option value="${sexList.detailCD}">${sexList.detailCdName}</option>
										    </c:forEach>
									</select>
								</div>
								<div class="form-group">
									<label for="addr">주소</label> 
									<input type="text" id="addr" name="addr"/>
								</div>
								<div class="form-group">
									<label for="addrDetail">상세주소</label> 
									<input type="text" id="addrDetail" name="addrDetail"/>
								</div>
								<div class="form-group">
									<label for="skill">보유스킬</label> 
									<c:forEach var="skillList" items="${skillList}">
										<label><input type="checkbox" id="skill" name="skill" value="${skillList.detailCD }">${skillList.detailCdName}</label>
									</c:forEach>
								</div>
							
							</div>
							
							
							<!-- 오른쪽 -->
							<div class="right">
								<div class="form-group2">
									<label for="startday">입사일 : </label> 
									<input type="date" id="startday" name="startday"/>
								</div>
								<div class="form-group2">
									<label for="addrDetail">재직상태 : </label> 
									<select id="status" name="status">
										<c:forEach var="statusList" items="${statusList}">
										    	<option value="${statusList.detailCD}">${statusList.detailCdName}</option>
										    </c:forEach>
									</select>
								</div>
								<div class="form-group2">
									<label for="rank">직급 : </label>
									<select id="rank" name="rank">
										<c:forEach var="userRankList" items="${userRankList}">
										    	<option value="${userRankList.detailCD}">${userRankList.detailCdName}</option>
										    </c:forEach>
									</select>
								</div>
								<div class="form-group2">
									<label for="rank">기술등급 : </label>
									<select id="grade" name="grade">
										<c:forEach var="gradeList" items="${gradeList}">
										    	<option value="${gradeList.detailCD}">${gradeList.detailCdName}</option>
										    </c:forEach>
									</select>
								</div>
								<div class="form-group2">
									<label for="salary">연봉</label> 
									<input type="text" id="salary" name="salary"/><label>만원</label>
								</div>
								<div class="form-group2">
									<label for="phone">전화번호</label> 
									<input type="text" id="phone" name="phone"/>
								</div>
								<div class="form-group2">
									<label for="email">이메일</label> 
									<input type="email" id="email" name="email"/>
								</div>
							</div>
							
							
							
							
							<div class="sub-btn">
								<div class="text-right">
									<button type="submit" class="btn btn-primary">정보수정</button>
								</div>
							</div>

						</form>
					</div>


</body>
</html>








