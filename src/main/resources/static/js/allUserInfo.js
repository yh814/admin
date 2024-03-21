/* 유저 삭제 */
$(document).ready(function(){
	
    $('#user-delete').click(function(){
        // 체크된 항목 확인
        var selectedUsers =[];
        
        $('.check-user:checked').each(function(){
            selectedUsers.push(parseInt($(this).attr('id')));
        });

        // 체크된 항목이 없는 경우
        if (selectedUsers.length === 0) {
            alert('삭제할 회원을 선택해주세요.');
            return;  // 아무 동작 없이 함수 종료
        }

        // 확인 메시지 표시
        var confirmDelete = confirm('선택한 회원에 대한 모든 정보가 삭제됩니다.\n정말로 삭제하시겠습니까?');

        // 확인을 눌렀을 경우
        if (confirmDelete) {
            // AJAX를 사용하여 서버에 삭제 요청 보내기
            $.ajax({
                type: 'POST',
                url: '${root}user/deleteUser',
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
        var checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
    });

    $('.check-user, .user-modify').click(function(event) {
        event.stopPropagation();
    });
    
    $('#searchForm').submit(function(event) {
        event.preventDefault();

        var searchUserName = $('#searchUserName').val();
        var searchUserGrade = $('#searchUserGrade').val();
        var searchUserStatus = $('#searchUserStatus').val();
        var searchUserStartDate = $('#searchUserStartDate').val();
        var searchUserEndDate = $('#searchUserEndDate').val();

        $.ajax({
            type: 'GET',
            url: '${root}user/search_userList',
            dataType: 'json',
            data: {
                searchUserName: searchUserName,
                searchUserGrade: searchUserGrade,
                searchUserStatus: searchUserStatus,
                searchUserStartDate: searchUserStartDate,
                searchUserEndDate: searchUserEndDate
            },
            success: function(data) {
                var tableBody = $('.main');
                tableBody.empty();
                console.log(data);

                if (data && data.length > 0) {
                    data.forEach(function(user) {
                        var row = '<tr>' +
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
                            '<a href="${root}user/user-pro?userNum=' + user.userNum + '">' +
                            '<button class="user-modify">프로젝트관리</button>' +
                            '</a>' +
                            '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    $('.pagination').hide();
                    console.log(data);
                } else {
                    var row = '<tr>' + '<td colspan="10">데이터가 없습니다</td>' + '</tr>';
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
	    var confirmAdd = confirm('입력된 정보가 모두 사라집니다.\n그래도 닫으시겠습니까?');
	    if (confirmAdd) {
	        $("#myModal input[type=text], #myModal input[type=date], #myModal input[type=password], #myModal input[type=email], #myModal select, #myModal textarea").val('');
	        
	        $("#myModal .userImg img").attr("src", "${root}image/pre-photo.png");
	
	        $("#myModal select").val('');
	        
	        $("#myModal").css("display", "none");
	    } else {
	        return;
	    }        
	});
	
	
	$("#submitBtn").click(function () {
            var userSkill = [];

            // 선택된 스킬을 배열에 추가
            $("input[name='skillCD']:checked").each(function () {
                userSkill.push($(this).val());
            });

            var userName= $("#userName").val();
            var userId= $("#userId").val();
            var userPw=$("#userPw").val();
            var userPw2=$("#userPw2").val();
            var userBirth= $("#userBirth").val();
            var sexCD=$("#sexCD").val();
            var addr= $("#addr").val();
            var addrDetail=$("#addrDetail").val();
            var startDate= $("#startDate").val();
            var userStatusCD= $("#userStatusCD").val();
            var conStatusCD=$("#conStatusCD").val();
            var userRankCD= $("#userRankCD").val();
            var userGradeCD=$("#userGradeCD").val();
            var salary=$("#salary").val();
            var userPhone= $("#userPhone").val();
            var userEmail= $("#userEmail").val();
            var userImg= $("#userImg").val();

            $.ajax({
                type: "POST",
                url: "${root}user/addUser",
                contentType: "application/json",
                data: {
                	userName: userName,
                	userId: userId,
                	userPw: userPw2,
                	userPw2: userPw2,
                	userBirth: userBirth,
                	sexCD: sexCD,
                	addr: addr,
                	addrDetail: addrDetail,
                	startDate: startDate,
                	userStatusCD: userStatusCD,
                	conStatusCD: conStatusCD,
                	userRankCD: userRankCD,
                	userGradeCD: userGradeCD,
                	salary: salary,
                	userPhone: userPhone,
                	userEmail: userEmail,
                	userImg: userImg,
                	userSkill: userSkill                	
                },
                success: function (response) {
                    console.log(response);
                },
                error: function (error) {
                    console.error("Error:", error);
                }
            });
        });
   
   
   $('#sub-form').click(function(){
    	
    });
   
});


/*입력칸 유효성 검사 함수*/
function validateField(input, rules, errorElementId){
    const value = input.value;
    const errorElement = document.getElementById(errorElementId);
    let errorMessage ='';

    if(value === null || value === ''){
        /*allowNull이 false일 경우*/
        if(!rules.allowNull){
            errorMessage = '필수 입력 값입니다';
            errorElement.textContent = errorMessage;
            return;
        }
        else{
            errorMessage = '';
            return;/*true일 경우 null 허용*/
        }
    }

    if('length' in rules){
        if(value.length < rules.length.min || value.length > rules.length.max){
            errorMessage = `길이는 ${rules.length.min}에서 ${rules.length.max}자 사이여야 합니다.`
        }
    }
    else if('maxLength' in rules && value.length > rules.maxLength){
        errorMessage = `최대 ${rules.maxLength}자를 초과할 수 없습니다.`
    }
    else if('pattern' in rules && !rules.pattern.test(value)){
        errorMessage = rules.patternMessage;
    }

    errorElement.textContent = errorMessage;

}

const validationRules ={
    userName: {
        length : {min: 8, max: 16},
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
        pattern : /^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]*$/,
        patternMessage : '영문, 숫자, 특수문자를 모두 포함해야 합니다.',
        errorElementId : 'userPwError',
        allowNull : false
    },
    userBirth: {
        pattern : /^[0-9]{8}$/,
        patternMessage : '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
        errorElementId : 'userBirthError',
        allowNull : false
    },
    addr: {
        errorElementId : 'addrError',
        allowNull : false
    },
    addrDetail: {
        allowNull : true
    },
    startDate: {
        pattern : /^[0-9]{8}$/,
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
    setupValidationForSelect('sexCD', 'sexCDError', '성별을 선택해주세요.');
    setupValidationForSelect('userStatusCD', 'userStatusCDError', '재직상태를 선택해주세요.');
    setupValidationForSelect('conStatusCD', 'conStatusCDError', '계약상태를 선택해주세요.');
    setupValidationForSelect('userRankCD', 'userRankCDError', '직급을 선택해주세요.');
    setupValidationForSelect('userGradeCD', 'userGradeCDError', '기술등급을 선택해주세요.');
}

/*체크박스 유효성 검사 함수*/
function validateCheckboxGroup(checkboxGroupName, errorElementId, errorMessage){
    const checkboxes = document.querySelectorAll(`input[name="${checkboxGroupName}"]:checked`);
    const errorElement = document.getElementById(errorElementId);

    if (checkboxes.length === 0) {
        errorElement.textContent = errorMessage;
    } else {
        errorElement.textContent = '';
    }
}
