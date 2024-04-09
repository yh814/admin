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
    proName:{
        length: {min: 2, max: 20},
        pattern: /^[a-zA-Zㄱ-ㅎ가-힣_-]*$/,
        patternMessage: '영문 대소문자와 한글, _-만 사용할 수 있습니다.',
        errorElementId: 'proNameError',
        allowNull: false
    },
    startDate: {
        pattern: /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
        patternMessage: '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
        errorElementId: 'startDateError',
        allowNull: false
    },
    endDate: {
        pattern: /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/,
        patternMessage: '8자리의 숫자로 입력해 주세요. ex)1990-01-01',
        errorElementId: 'endDateError',
        allowNull: false
    },
    manager:{
        length: {min: 2, max: 10},
        pattern: /^[a-zA-Zㄱ-ㅎ가-힣]*$/,
        patternMessage: '영문 대소문자와 한글만 사용할 수 있습니다.',
        errorElementId: 'managerError',
        allowNull: true
    },
    mPhone: {
        pattern: /^\d{2,3}-\d{3,4}-\d{4}$/,
        patternMessage: '번호 중간에 -과 함께 작성해주세요 ex)010-0000-0000, 02-000-0000',
        errorElementId: 'mPhoneError',
        allowNull: false
    },
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


document.addEventListener('DOMContentLoaded',function (){
    setupValidationForFields(validationRules);
    setupValidationForSelect('cusCD', 'cusCDError', '고객사를 선택해주세요.');
    setupValidationForSelect('progressCD', 'progressCDError', '진행상태를 선택해주세요.');

    document.getElementById('sub-form').addEventListener('click', function (event) {
        let hasError = false;
        let isValid = false;

        /*프로젝트 이름*/
        const proName = document.getElementById('proName');
        const proNameError = document.getElementById('proNameError');

        if(proName.value === ''){
            proNameError.textContent = '프로젝트 이름을 입력해주세요.';
            hasError = true;
        }else{
            proNameError.textContent = '';
        }

        /*시작일*/
        const startDate = document.getElementById('startDate');
        const startDateError = document.getElementById('startDateError');

        if(startDate.value === ""){
            startDateError.textContent = '시작일을 입력해주세요.';
            hasError = true;
        }else {
            startDateError.textContent = '';
        }

        /*종료일*/
        const endDate = document.getElementById('endDate');
        const endDateError = document.getElementById('endDateError');

        if(endDate.value === ""){
            endDateError.textContent = '종료일을 입력해주세요.';
            hasError = true;
        }else {
            endDateError.textContent = '';
        }

        /*고객사*/
        const cusCD = document.getElementById('cusCD');
        const cusCDError = document.getElementById('cusCDError');
        if (cusCD.value === 'default') {
            cusCDError.textContent = '고객사를 선택해주세요.';
            hasError = true;
        } else {
            cusCDError.textContent = '';
        }

        /*진행상태*/
        const progressCD = document.getElementById('progressCD');
        const progressCDError = document.getElementById('progressCDError');
        if (progressCD.value === 'default') {
            progressCDError.textContent = '진행상태를 선택해주세요.';
            hasError = true;
        } else {
            progressCDError.textContent = '';
        }


        validateCheckboxGroup('skillCD', 'skillCDError', '적어도 하나의 기술 스택을 선택해주세요.');


        if (!isValid) {
            event.preventDefault(); // 폼 제출 방지

        }else if (document.getElementById('skillCDError').textContent !== '') {
            hasError = true;
        }

        if(!hasError){
            const formData = new FormData(document.getElementById('modify'));

            const manager = document.getElementById('manager').value || "";
            formData.append('manager', manager);

            const mPhone = document.getElementById('mPhone').value || "";
            formData.append('mPhone', mPhone);

            const note = document.getElementById('note').value || "";
            formData.append('note', note);

            for (const pair of formData.entries()) {
                console.log(pair[0] + ', ' + pair[1]);
            }

            console.log(formData);

            $.ajax({
                url: '/modify_pro',
                type: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                success: function(data) {
                    alert('프로젝트 수정이 완료되었습니다.');
                },
                error: function(xhr, status, error) {
                    alert('프로젝트 수정을 실패하였습니다.');
                }
            });
        }
    });
});