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
<link rel="stylesheet" href="${root }css/allUserInfo.css">
<link rel="stylesheet" href="${root }css/modal.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<body>

<script>
/* 유저 삭제 */
$(document).ready(function(){
	
    $('#user-delete').click(function(){
        // 체크된 항목 확인
        const selectedUsers =[];
        
        $('.check-user:checked').each(function(){
            selectedUsers.push(parseInt($(this).attr('id')));
        });

        // 체크된 항목이 없는 경우
        if (selectedUsers.length === 0) {
            alert('삭제할 회원을 선택해주세요.');
            return;  // 아무 동작 없이 함수 종료
        }

        // 확인 메시지 표시
		const confirmDelete = confirm('선택한 회원에 대한 모든 정보가 삭제됩니다.\n정말로 삭제하시겠습니까?');

        // 확인을 눌렀을 경우
        if (confirmDelete) {
            // AJAX를 사용하여 서버에 삭제 요청 보내기
            $.ajax({
                type: 'POST',
                url: '/deleteUser',
                contentType: 'application/json',
                data: JSON.stringify(selectedUsers),
                success: function(response){
                    // 삭제 성공 시 처리
                    console.log('User deleted:', selectedUsers);
                    alert("삭제 처리되었습니다.");
                    window.location.reload(); // AJAX 요청이 완료된 후에 페이지 리로드
                },
                error: function(xhr, status, error) {
                    // 오류 처리
                    console.error('Error deleting user:', error);
                    console.log(xhr.responseText); // 서버 응답을 콘솔에 출력
                    alert("삭제가 완료되지 않았습니다.");
                }
            });
        } else {
            // 취소 시 동작 (아무 동작 없음)
            console.log('Delete operation canceled.');
        }
    });
    
    
	/* tr클릭 */
    $('tr').click(function() {
		const checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
    });

    $('.check-user, .user-modify').click(function(event) {
        event.stopPropagation();
    });
    
    $('#searchForm').submit(function(event) {
        event.preventDefault();

		const searchUserName = $('#searchUserName').val();
		const searchUserGrade = $('#searchUserGrade').val();
		const searchUserStatus = $('#searchUserStatus').val();
		const searchUserStartDate = $('#searchUserStartDate').val();
		const searchUserEndDate = $('#searchUserEndDate').val();

        $.ajax({
            type: 'GET',
            url: '/search_userList',
            dataType: 'json',
            data: {
                searchUserName: searchUserName,
                searchUserGrade: searchUserGrade,
                searchUserStatus: searchUserStatus,
                searchUserStartDate: searchUserStartDate,
                searchUserEndDate: searchUserEndDate
            },
            success: function(data) {
				const tableBody = $('.main');
                tableBody.empty();
                console.log(data);

                if (data && data.length > 0) {
                    data.forEach(function(user) {
                        let row = '<tr>' +
                            '<td>' + '<input type="checkbox" id="${user.userNum }" class="check-user"/>' + '</td>' +
                            '<td>' + user.userNum + '</td>' +
                            '<td>' + user.userName + '</td>' +
                            '<td>' + user.rankDetailName + '</td>' +
                            '<td>' + user.startDate + '</td>' +
                            '<td>' + user.employmentStatusDetailName + '</td>' +
                            '<td>' + user.gradeDetailName + '</td>' +
                            '<td>';
                        user.skillDetailNameList.forEach(function(skill, index) {
                            row += skill;
                            if (index < user.skillDetailNameList.length - 1) {
                                row += ', ';
                            }
                        });
                        row += '</td>' +
                            '<td>' +
                            '<a href="${root}user/modify?userNum=' + user.userNum + '">' +
                            '<button class="user-modify">상세/수정</button>' +
                            '</a>' +
                            '</td>' +
                            '<td>' +
                            '<a href="${root}match/userMatch?userNum=' + user.userNum + '">' +
                            '<button class="user-modify">프로젝트관리</button>' +
                            '</a>' +
                            '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    $('.pagination').hide();
                    console.log(data);
                } else {
                    let row = '<tr>' + '<td colspan="10">데이터가 없습니다</td>' + '</tr>';
                    tableBody.append(row);
                }
            },
            error: function(xhr, status, error) {
                // 오류 처리
            }
        });
    });
    
    $("#add-user").click(function() {
        $("#myModal").css("display", "block");
    });
    
    
    $("#closeModalBtn").click(function() {
	    const confirmAdd = confirm('입력된 정보가 모두 사라집니다.\n그래도 닫으시겠습니까?');
	    if (confirmAdd) {
	        $("#myModal input[type=text], #myModal input[type=date], #myModal input[type=password], #myModal input[type=email], #myModal select, #myModal textarea").val('');
	        
	        $("#myModal .userImg img").attr("src", "${root}image/pre-photo.png");
	
	        $("#myModal select").val('');
	        
	        $("#myModal").css("display", "none");
	    } else {
	        return;
	    }        
	});

});




</script>

<div class="search-sec">
    <!-- 검색 폼 -->
    <form id="searchForm" class="search-form">
        <p class="search-title">검색조건</p>
        <div class="search-box">
            <div class="search-item">
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
                
                <p class="mini-title">입사일 : </p>
                <input type="date" id="searchUserStartDate" name="searchUserStartDate">
				<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
				<input type="date" id="searchUserEndDate" name="searchUserEndDate">

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
    <table class="table">
        <thead>
            <tr>
            	<th><input type="checkbox" id="check-user" class="check-user" disabled/></th>
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
            <c:forEach var="user" items="${allUser}">
                <tr>
                	<td><input type="checkbox" id="${user.userNum }" class="check-user"/></td>
                    <td>${user.userNum}</td>
                    <td>${user.userName}</td>
                    <td>${user.rankDetailName}</td>
                    <td>${user.startDate}</td>
                    <td>${user.employmentStatusDetailName}</td>
                    <td>${user.gradeDetailName}</td>
                    <td>
                        <c:forEach var="skill" items="${user.skillDetailNameList}" varStatus="status">
                            ${skill}${status.last ? '' : ', '}
                        </c:forEach>
                    </td>
                    <td>
                        <a href="${root}user/modify?userNum=${user.userNum}">
                            <button class="user-modify">상세/수정</button>
                        </a>
                    </td>
                    <td>
                        <a href="${root}match/userMatch?userNum=${user.userNum}">
                            <button class="user-modify">프로젝트관리</button>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>      
    </table>
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
					                <img src="${root}image/pre-photo.png" alt="기본이미지" style="width: 150px; height: 200px;"/>
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
					                        <option value="">--성별 선택--</option>
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
								            <option value="">--재직상태 선택--</option>
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
								            <option value="">--계약상태 선택--</option>
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
								            <option value="">--직급 선택--</option>
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
								            <option value="">--기술등급 선택--</option>
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

								                <span class="input-group-text">만원</span>
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
								        <input type="email" id="userEmail" name="userEmail" class="form-control" />
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
	        
    
    		  <div class="pagination-main">
				<ul class="pagination">
					<c:choose>
					<c:when test="${pageBean.prevPage <= 0 }">
					<li class="page-item-desabled">
						<a href="#" class="page-link">이전</a>
					</li>
					</c:when>
					<c:otherwise>
					<li class="page-item">
						<a href="${root }user/allUserInfo&page=${pageBean.prevPage}" class="page-link">이전</a>
					</li>
					</c:otherwise>
					</c:choose>
					
					
					<c:forEach var='idx' begin="${pageBean.min }" end='${pageBean.max }'>
					<c:choose>
					<c:when test="${idx == pageBean.currentPage }">
					<li class="page-item-active">
						<a href="${root }user/allUserInfo?page=${idx}" class="page-link">${idx }</a>
					</li>
					</c:when>
					<c:otherwise>
					<li class="page-item">
						<a href="${root }user/allUserInfo?page=${idx}" class="page-link" >${idx }</a>
					</li>
					</c:otherwise>
					</c:choose>
					
					</c:forEach>
					
					<c:choose>
					<c:when test="${pageBean.max >= pageBean.pageCnt }">
					<li class="page-item disabled">
						<a href="#" class="page-link">다음</a>
					</li>
					</c:when>
					<c:otherwise>
					<li class="page-item">
						<a href="${root }user/allUserInfo?page${pageBean.nextPage}" class="page-link">다음</a>
					</li>
					</c:otherwise>
					</c:choose>
					
				</ul>
			</div>
		
</div>



</body>
<script>

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('resetBtn').addEventListener('click', function() {
        location.href="${root }user/allUserInfo?page=1";
    });
});

function validateImageSelection() {
	const imageInput = document.getElementById('userImgFile');
	const errorElement = document.getElementById('userImgError');

	if (!imageInput.files.length) {
		errorElement.textContent = '이미지 파일을 선택해주세요.';
	} else {
		errorElement.textContent = '';
	}
}

document.getElementById('userImgFile').addEventListener('change', validateImageSelection);

/*입력칸 유효성 검사 함수*/
function validateField(input, rules, errorElementId) {
	const value = input.value.trim();
	const errorElement = document.getElementById(errorElementId);
	let errorMessage = '';

	if (value === null || value === '') {
		/*allowNull이 false일 경우*/
		if (!rules.allowNull) {
			errorMessage = '필수 입력 값입니다';
			errorElement.textContent = errorMessage;
			return;
		} else {
			return;/*true일 경우 null 허용*/
		}
	} else {
		if ('pattern' in rules && !rules.pattern.test(value)) {
			errorMessage = rules.patternMessage;
		} else if ('length' in rules) {
			if (value.length < rules.length.min || value.length > rules.length.max) {
				errorMessage = '길이는 ' + rules.length.min + '에서 ' + rules.length.max + '자 사이여야 합니다.';
			}
		}

	}

	if (!errorElement) {
		console.error('Error element not found: ' + errorElementId);
		return; // errorElement가 없으면 함수를 종료
	}

	errorElement.textContent = errorMessage;
	errorElement.style.display = errorMessage ? 'block' : 'none';

}

const validationRules ={
	userName: {
		length : {min: 2, max: 10},
		pattern : /^[a-zA-Zㄱ-ㅎ가-힣]*$/,
		patternMessage : '영문 대소문자와 한글만 사용할 수 있습니다.',
		errorElementId : 'userNameError',
		allowNull : false
	},
	userId: {
		length: {min: 5, max: 20},
		pattern: /^[a-z0-9_-]+$/,
		patternMessage: '영문 소문자, 숫자와 특수기호(_),(-)만 사용할 수 있습니다.',
		errorElementId: 'userIdError',
		allowNull : false
	},
	userPw: {
		length : {min: 8, max: 16},
		pattern : /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]*$/,
		patternMessage : '영문, 숫자, 특수문자를 모두 포함해야 합니다.',
		errorElementId : 'userPwError',
		allowNull : false
	},
	userBirth: {
		pattern : /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
		patternMessage : '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
		errorElementId : 'userBirthError',
		allowNull : false
	},
	addr: {
		errorElementId : 'addrError',
		allowNull : false
	},
	addrDetail: {
		errorElementId : 'addrDetailError',
		allowNull : true
	},
	startDate: {
		pattern : /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
		patternMessage : '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
		errorElementId : 'startDateError',
		allowNull : false
	},
	salary: {
		pattern : /^[0-9]+$/,
		patternMessage : '(,)없이 숫자로만 입력해주세요',
		errorElementId : 'salaryError',
		allowNull : false
	},
	userPhone: {
		pattern : /^\d{2,3}-\d{3,4}-\d{4}$/,
		patternMessage : '번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000',
		errorElementId : 'userPhoneError',
		allowNull : false
	},
	userEmail: {
		pattern : /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
		patternMessage : '유효한 이메일 형식이 아닙니다.',
		errorElementId : 'userEmailError',
		allowNull : true
	},
}

/*비밀번호*/
// 비밀번호와 비밀번호 확인 필드의 유효성 검사 함수
function validatePasswordMatch() {
	const password = document.getElementById('userPw').value;
	const confirmPassword = document.getElementById('userPw2').value;
	const pwErrorElement = document.getElementById('userPw2Error');

	if(password===null){
		pwErrorElement.textContent = '';
	}else{
		if(confirmPassword === null){
			pwErrorElement.textContent = '비밀번호 확인해주세요.'
		} else{
			if (password !== confirmPassword) {
				pwErrorElement.textContent = '비밀번호가 일치하지 않습니다.';
				pwErrorElement.style.color = 'red';
			} else {
				pwErrorElement.textContent = '비밀번호가 일치합니다.';
				pwErrorElement.style.color = 'blue';
			}
		}
	}

}

// 비밀번호와 비밀번호 확인 필드에 대한 input 이벤트 리스너 설정
document.getElementById('userPw').addEventListener('input', validatePasswordMatch);
document.getElementById('userPw2').addEventListener('input', validatePasswordMatch);


function setupValidationForFields(validationRules){
	for(let fieldId in validationRules){
		const field = document.getElementById(fieldId);
		const rules = validationRules[fieldId];

		if(field){
			field.addEventListener('input', function (){
				validateField(this, rules, rules.errorElementId);
			});
		}
	}
}


/*select칸 유효성 검사 함수*/
function validateSelect(selectElementId, errorElementId, errorMessage){
	const selectElement = document.getElementById(selectElementId);
	const errorElement = document.getElementById(errorElementId);

	if(selectElement.value===""){
		errorElement.textContent = errorMessage;
	}else {
		errorElement.textContent = '';
	}
}

function setupValidationForSelect(selectElementId, errorElementId, errorMessage){
	const selectElement = document.getElementById(selectElementId);

	selectElement.addEventListener('change', function (){
		validateSelect(selectElementId, errorElementId, errorMessage);
	});
}

window.onload=function (){
	setupValidationForFields(validationRules);
	setupValidationForSelect('sexCD', 'sexCDError', '성별을 선택해주세요.');
	setupValidationForSelect('userStatusCD', 'userStatusCDError', '재직상태를 선택해주세요.');
	setupValidationForSelect('conStatusCD', 'conStatusCDError', '계약상태를 선택해주세요.');
	setupValidationForSelect('userRankCD', 'userRankCDError', '직급을 선택해주세요.');
	setupValidationForSelect('userGradeCD', 'userGradeCDError', '기술등급을 선택해주세요.');
}

/*체크박스 유효성 검사 함수*/
function validateCheckboxGroup(checkboxGroupName, errorElementId, errorMessage){
	const checkboxes = document.querySelectorAll('input[name="skillCD"]:checked');
	const errorElement = document.getElementById(errorElementId);

	if (checkboxes.length === 0) {
		errorElement.textContent = errorMessage;
	} else {
		errorElement.textContent = '';
	}
}

document.addEventListener('DOMContentLoaded', function() {
	const checkIdButton = document.getElementById('checkId');
	if (checkIdButton) {
		checkIdButton.addEventListener('click', function(event) {
			const userId = document.getElementById('userId').value;

			if (userId === "") {
				alert('아이디를 입력해주세요.');
				return;
			}

			$.ajax({
				url: '/userCheck',
				type: 'POST',
				data: { userId: userId },
				success: function(isAvailable) {
					if (isAvailable) {
						alert('사용 가능한 아이디입니다.');
					} else {
						alert('이미 사용 중인 아이디입니다.');
					}
				},
				error: function() {
					alert('아이디 중복 검사에 실패했습니다. 다시 시도해주세요.');
				}
			});
		});
	}
});


/*회원 등록 제출*/
document.getElementById('sub-form').addEventListener('click', function(event) {
	event.preventDefault(); // 폼의 기본 제출 동작을 방지

	let hasError = false;

	// 모든 입력 필드에 대한 유효성 검사 수행
	for (let fieldId in validationRules) {
		const field = document.getElementById(fieldId);
		const rules = validationRules[fieldId];
		const errorElement = document.getElementById(rules.errorElementId);

		validateField(field, rules, rules.errorElementId);

		// 에러 메시지가 있는 경우
		if (errorElement.textContent !== '') {
			hasError = true;
			break; // 에러가 발견되면 더 이상 검사하지 않고 반복문 탈출
		}
	}

	// 기술 스택 선택 확인
	validateCheckboxGroup('skillCD', 'skillCDError', '적어도 하나의 기술 스택을 선택해주세요.');
	if (document.getElementById('skillCDError').textContent !== '') {
		hasError = true;
	}

	if (!hasError) {
		const formData = new FormData(document.getElementById('myModal')); // 폼 데이터를 FormData 객체로 생성

		for (const pair of formData.entries()) {
			console.log(pair[0]+ ', ' + pair[1]);
		}
		$.ajax({
			url: '/addUser',
			type: 'POST',
			data: formData,
			contentType: false,
			processData: false,
			success: function(data) {
				alert('회원 추가가 완료되었습니다.');
				window.location.reload(); // 페이지 새로고침
			},
			error: function(xhr, status, error) {
				alert('회원 추가에 실패하였습니다.');
			}
		});
	} else {
		alert('입력한 정보를 다시 확인해주세요.');
	}
});






</script>
</html>
