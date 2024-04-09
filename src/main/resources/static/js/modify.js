$(document).ready(function() {
    $("#userImgFile").on("change", function(event) {
        const file = event.target.files[0];
        const reader = new FileReader();

        reader.onload = function(e) {
            $("#previewImg").attr("src", e.target.result);
        };

        if (file) {
            reader.readAsDataURL(file);
        }
    });
});


function validateEmailDomain(input) {
    const pattern = /^[a-zA-Z]([a-zA-Z0-9-]*[a-zA-Z0-9])+\.[a-zA-Z]([a-zA-Z0-9-]*[a-zA-Z0-9])+/;
    const errorMessage = document.getElementById('userEmail2Error');

    if (pattern.test(input.value)) {
        errorMessage.textContent = ''; // 유효성 검사 통과 시 에러 메시지 제거
    } else {
        errorMessage.textContent = '유효한 이메일 형식으로 기재해주세요 ex)naver.com'; // 에러 메시지 표시
    }
}


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
        pattern : /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+$/,
        patternMessage : '메일 앞주소는 문자, 숫자 및 특수 문자로 구성되며, 점으로 시작하거나 끝날 수 없습니다.',
        errorElementId : 'userEmailError',
        allowNull : true
    }

}

/*이메일 입력 처리*/
const inputField = document.getElementById('directInput');

function decovery(select) {
    if (select.value === 'direct') {
        inputField.value='';
        inputField.readOnly = false;
    }else if(select.value === 'default'){
        inputField.value='';
        inputField.readOnly = true;
    }else{
        inputField.value = select.options[select.selectedIndex].text;
        inputField.readOnly = true;
    }
}

inputField.addEventListener('input', function (event) { // 'event' 매개변수 추가
    let inputValue = event.target.value.toLowerCase();
    let autoCompleteValue = '';

    for (let email of emailList) {
        if (email.detailCdName.toLowerCase().startsWith(inputValue)) {
            autoCompleteValue = email.detailCdName;
            break; // 일치하는 첫 번째 항목을 찾으면 루프 종료
        }
    }
    document.getElementById('autocompletePreview').textContent = autoCompleteValue ? autoCompleteValue : '';

    if(inputField.value==='' || inputField.value === null){
        document.getElementById('autocompletePreview').textContent = '';
    }
});



/*Tab 누를 시 자동완성*/
inputField.addEventListener('keydown', function (event){
    if(event.keyCode===9){
        event.preventDefault();
        let autocompletePreview = document.getElementById('autocompletePreview').textContent;

        if(autocompletePreview){
            inputField.value = autocompletePreview;
            document.getElementById('autocompletePreview').textContent = '';
            toolTip.style.display = 'none';
        }
    }
})


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
}


/*체크박스 유효성 검사 함수*/
function validateCheckboxGroup(checkboxGroupName, errorElementId, errorMessage){
    const checkboxes = document.querySelectorAll('input[name="skillCD"]');
    const errorElement = document.getElementById(errorElementId);

    if (checkboxes.length === 0) {
        errorElement.textContent = errorMessage;
    } else {
        errorElement.textContent = '';
    }

}



/*회원 등록 제출*/
document.getElementById('sub-form').addEventListener('click', function(event) {
    event.preventDefault(); // 폼의 기본 제출 동작을 방지
    let hasError = false;
    let isValid = false;

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

    const selectFields = ['sexCD', 'userStatusCD', 'conStatusCD', 'userRankCD', 'userGradeCD'];

    selectFields.forEach(function(selectFieldId) {
        const selectElement = document.getElementById(selectFieldId);
        const errorElementId = selectFieldId + 'Error'; // 오류 메시지를 표시할 요소의 ID
        const errorElement = document.getElementById(errorElementId);
        const errorMessage = '정보를 선택해주세요.';
        const userNum = document.getElementById('userNum').value;


        if (selectElement.value === 'default') {
            errorElement.textContent = errorMessage;
            isValid = false;
        } else {
            errorElement.textContent = '';
        }
    });

    if (document.getElementById('skillCDError').textContent !== '') {
        hasError = true;
    }else if (!isValid) {
        event.preventDefault(); // 폼 제출 방지
    }

    if (!hasError) {
        const formData = new FormData(document.getElementById('modify')); // 폼 데이터를 FormData 객체로 생성

        for (const pair of formData.entries()) {
            console.log(pair[0]+ ', ' + pair[1]);
        }
        $.ajax({
            url: '/modify_user',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(data) {
                event.stopPropagation();
                alert('회원 수정이 완료되었습니다.');
            },
            error: function(xhr, status, error) {
                alert('회원 수정을 실패하였습니다.');
            }
        });
    } else {
        /*alert('입력한 정보를 다시 확인해주세요.');*/
    }


});


function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 기본 주소
            document.getElementById('addr').value = data.roadAddress;
            /*// 참고항목
            var extraAddr = '';
            if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                extraAddr += data.bname;
            }
            if (data.buildingName !== '' && data.apartment === 'Y') {
                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            document.getElementById('extraAddress').value = extraAddr;*/

            // 상세주소 입력란으로 포커스 이동
            document.getElementById('addrDetail').focus();
        }
    }).open();
}