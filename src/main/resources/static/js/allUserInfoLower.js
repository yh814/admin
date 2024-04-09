/*이미지 파일 미리보기*/
$(document).ready(function () {
    $("#userImgFile").on("change", function (event) {
        const file = event.target.files[0];
        const reader = new FileReader();

        reader.onload = function (e) {
            $("#previewImg").attr("src", e.target.result);
        };

        if (file) {
            reader.readAsDataURL(file);
        }

        if ($(this).val() === null) {
            $('#userImgError').text('파일을 선택해주세요.');
        } else {
            $('#userImgError').text('');
        }
    });

});


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

const validationRules = {
    userName: {
        length: {min: 2, max: 10},
        pattern: /^[a-zA-Zㄱ-ㅎ가-힣]*$/,
        patternMessage: '영문 대소문자와 한글만 사용할 수 있습니다.',
        errorElementId: 'userNameError',
        allowNull: false
    },
    userId: {
        length: {min: 5, max: 20},
        pattern: /^[a-z0-9_-]+$/,
        patternMessage: '영문 소문자, 숫자와 특수기호(_),(-)만 사용할 수 있습니다.',
        errorElementId: 'userIdError',
        allowNull: false
    },
    userPw: {
        length: {min: 8, max: 16},
        pattern: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]*$/,
        patternMessage: '영문, 숫자, 특수문자를 모두 포함해야 합니다.',
        errorElementId: 'userPwError',
        allowNull: false
    },
    userBirth: {
        pattern: /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
        patternMessage: '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
        errorElementId: 'userBirthError',
        allowNull: false
    },
    addr: {
        errorElementId: 'addrError',
        allowNull: false
    },
    addrDetail: {
        errorElementId: 'addrDetailError',
        allowNull: true
    },
    startDate: {
        pattern: /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
        patternMessage: '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
        errorElementId: 'startDateError',
        allowNull: false
    },
    salary: {
        pattern: /^[0-9]+$/,
        patternMessage: '(,)없이 숫자로만 입력해주세요',
        errorElementId: 'salaryError',
        allowNull: false
    },
    userPhone: {
        pattern: /^\d{2,3}-\d{3,4}-\d{4}$/,
        patternMessage: '번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000',
        errorElementId: 'userPhoneError',
        allowNull: false
    },
    userEmail: {
        pattern: /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+$/,
        patternMessage: '메일 앞주소는 문자, 숫자 및 특수 문자로 구성되며, 점으로 시작하거나 끝날 수 없습니다.',
        errorElementId: 'userEmailError',
        allowNull: true
    }
}

/*이메일 입력 처리*/
const inputField = document.getElementById('directInput');

function decovery(select) {
if(select.value === 'default'){
        inputField.value='';
        inputField.readOnly = false;
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
        }
    }
});



/*비밀번호*/

// 비밀번호와 비밀번호 확인 필드의 유효성 검사 함수
function validatePasswordMatch() {
    const password = document.getElementById('userPw').value;
    const confirmPassword = document.getElementById('userPw2').value;
    const pwErrorElement = document.getElementById('userPw2Error');

    if (password === null) {
        pwErrorElement.textContent = '';
    } else {
        if (confirmPassword === null) {
            pwErrorElement.textContent = '비밀번호 확인해주세요.'
        } else {
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


function setupValidationForFields(validationRules) {
    for (let fieldId in validationRules) {
        const field = document.getElementById(fieldId);
        const rules = validationRules[fieldId];

        if (field) {
            field.addEventListener('input', function () {
                validateField(this, rules, rules.errorElementId);
            });
        }
    }
}


/*select칸 유효성 검사 함수*/
function setupValidationForSelect(selectElementId, errorElementId, errorMessage) {
    const selectElement = document.getElementById(selectElementId);

    // 'change' 이벤트에 대한 리스너를 추가합니다.
    selectElement.addEventListener('change', function () {
        const errorElement = document.getElementById(errorElementId);

        if (selectElement.value === "default" || selectElement.value === null) {
            errorElement.textContent = errorMessage;
        } else {
            errorElement.textContent = '';
        }
    });
}

window.onload = function () {
    setupValidationForFields(validationRules);
}


/*체크박스 유효성 검사 함수*/
function validateCheckboxGroup(checkboxGroupName, errorElementId, errorMessage) {
    const checkboxes = document.querySelectorAll('input[name="skillCD"]:checked');
    const errorElement = document.getElementById(errorElementId);

    if (checkboxes.length === 0) {
        errorElement.textContent = errorMessage;
    } else {
        errorElement.textContent = '';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    setupValidationForFields(validationRules);

});

let isIdPass = false;
document.getElementById('userId').addEventListener('input', function () {
    isIdPass = false;
});

document.addEventListener('DOMContentLoaded', function () {
    const checkIdButton = document.getElementById('checkId');
    if (checkIdButton) {
        checkIdButton.addEventListener('click', function (event) {
            const userId = document.getElementById('userId').value;

            if (userId === "") {
                alert('아이디를 입력해주세요.');
                return;
            }

            $.ajax({
                url: '/userCheck',
                type: 'POST',
                data: 'userId=' + encodeURIComponent(userId),
                success: function (isAvailable) {
                    if (isAvailable) {
                        alert('사용 가능한 아이디입니다.');
                        isIdPass = true;
                    } else {
                        alert('이미 사용 중인 아이디입니다.');
                    }
                },
                error: function () {
                    alert('아이디 중복 검사에 실패했습니다. 다시 시도해주세요.');
                }
            });
        });
    }
});


/*회원 등록 제출*/
document.getElementById('sub-form').addEventListener('click', function (event) {
    event.preventDefault();

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
    validateCheckboxGroup('skillCD', 'skillCDError', '적어도 하나의 기술 스택을 선택해주세요.');

    const selectFields = ['sexCD', 'userStatusCD', 'conStatusCD', 'userRankCD', 'userGradeCD'];

    selectFields.forEach(function (selectFieldId) {
        const errorElementId = selectFieldId + 'Error';
        const errorMessage = '정보를 선택해주세요.';

        // 각 선택 필드에 대한 유효성 검사 설정
        setupValidationForSelect(selectFieldId, errorElementId, errorMessage);
    });

    // 유효하지 않은 경우 폼 제출을 방지
    if (!isIdPass) {
        event.preventDefault();
        alert('아이디 중복 체크를 해주세요.');
        hasError = true;
    } else if ($('#userImgFile').val() === '') {
        event.preventDefault();
        alert('파일을 선택해주세요.');
        hasError = true;
    } else if (!isValid) {
        event.preventDefault(); // 폼 제출 방지

    } else if (document.getElementById('skillCDError').textContent !== '') {
        hasError = true;
    }

    if (!hasError) {
        const formData = new FormData(document.getElementById('myModal')); // 폼 데이터를 FormData 객체로 생성
        const addrDetail = document.getElementById('addrDetail').value;
        const userEmail = document.getElementById('userEmail').value;

        if (addrDetail === '') {
            formData.append('', addrDetail);
        }

        if (userEmail === '') {
            formData.append('', userEmail);
        }

        for (const pair of formData.entries()) {
            console.log(pair[0] + ', ' + pair[1]);
        }

        $.ajax({
            url: '/addUser',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function (data) {
                alert('회원 추가가 완료되었습니다.');
                window.location.reload(); // 페이지 새로고침
            },
            error: function (xhr, status, error) {
                alert('회원 추가에 실패하였습니다.');
            }
        });
    } else {
        /*alert('입력한 정보를 다시 확인해주세요.');*/
    }
});
