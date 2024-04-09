let checkedPros =[];
$(document).ready(function() {

    $('tr').click(function(event) {
        const checkbox = $(this).find('.check-match');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.check-match').click(function(event) {
        event.stopPropagation();
    });



    /* 모달 */
    $("#add").click(function() {
        $("#add-modal").css("display", "block");
    });

    $('#searchUserName, #searchGradeName, #searchStatusName').keypress(function(event) {
        // 엔터키가 눌렸을 때
        if (event.which === 13) {
            event.preventDefault(); // 폼의 기본 제출 동작을 방지
            $('#searchButton').click(); // 조회 버튼 클릭
        }
    });

    /* 프로젝트 검색 */
    $('#searchButton').click(function(event) {
        const searchUserName = $('#searchUserName').val();
        const searchGradeName = $('#searchGradeName').val();
        const searchStatusName = $('#searchStatusName').val();
        const proNum = $('#proNum').val();

        $.ajax({
            type: 'GET',
            url: '/proMatchUserSearch',
            dataType: 'json',
            data: {
                searchUserName: searchUserName,
                searchGradeName: searchGradeName,
                searchStatusName: searchStatusName,
                proNum: proNum
            },

            success: function(data) {

                console.log(data);
                const tableBody = $('.main-search');
                tableBody.empty();

                if (data && data.length > 0) {
                    data.forEach(function(user) {

                        const exists = checkedPros.some(item => item.userNum === user.userNum);

                        const displayStyle = exists ? ' style="display: none;"' : '';

                        let row = '<tr'+displayStyle +'>'+
                            '<td><input type="checkbox" id="' + user.userNum  + '" class="check-user" ' +
                            'data-userNum="' + user.userNum  + '" ' +
                            'data-userName="' + user.userName + '" ' +
                            'data-employmentStatusDetailName="' + user.employmentStatusDetailName + '" ' +
                            'data-rankDetailName="' + user.rankDetailName + '" ' +
                            'data-gradeDetailName="' + user.gradeDetailName + '" ' +
                            'data-skillCD="' + user.skillDetailNameList + '" /></td>' +
                            '<td>' + user.userNum + '</td>' +
                            '<td>' + user.userName + '</td>' +
                            '<td>' + user.employmentStatusDetailName + '</td>' +
                            '<td>' + user.rankDetailName + '</td>' +
                            '<td>' + user.gradeDetailName + '</td>' +
                            '<td>';
                        user.skillDetailNameList.forEach(function(skill, index) {
                            row += skill;
                            if (index < user.skillDetailNameList.length - 1) {
                                row += ', ';
                            }
                        });
                        row += '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    $('.pagination').hide();

                    console.log(data);
                }else {
                    const row = '<tr>' + '<td colspan="10">데이터가 없습니다</td>' + '</tr>';
                    tableBody.append(row);
                }

            },
            error: function(xhr, status, error) {
                // 오류 처리
            }
        });
    });

    /* 모달창 닫기 */
    $("#closeModalBtn").click(function() {
        const confirmAdd = confirm('선택된 프로젝트가 모두 취소됩니다.\n그래도 닫으시겠습니까?');
        if (confirmAdd) {

            $("#add-modal").css("display", "none");

            window.location.reload();
        } else {
            return;
        }
    });

    /* 검색 조건 초기화 */
    $('#resetBtn').click(function() {
        $('#searchUserName').val('');
        $('#searchGradeName').val('');
        $('#searchStatusName').val('');
        const proNum = $('#proNum').val();

        $.ajax({
            type: 'GET',
            url: '/proMatchUserSearch',
            dataType: 'json',
            data: {
                searchProName: '',
                searchCusName: '',
                searchProgressName: '',
                proNum: proNum
            },

            success: function(data) {
                const tableBody = $('.main-search');

                tableBody.empty();

                if (data && data.length > 0) {
                    data.forEach(function(user) {
                        let row;
                        row = '<tr>' +
                            '<td><input type="checkbox" id="' + user.userNum + '" class="check-user"/></td>' +
                            '<td>' + user.userNum + '</td>' +
                            '<td>' + user.userName + '</td>' +
                            '<td>' + user.employmentStatusDetailName + '</td>' +
                            '<td>' + user.rankDetailName + '</td>' +
                            '<td>' + user.gradeDetailName + '</td>' +
                            '<td>';
                        user.skillDetailNameList.forEach(function(skill, index) {
                            row += skill;
                            if (index < user.skillDetailNameList.length - 1) {
                                row += ', ';
                            }
                        });
                        row += '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    $('.pagination').show();
                } else {
                    const row = '<tr><td colspan="10">데이터가 없습니다</td></tr>';
                    tableBody.append(row);
                }
            },
            error: function(xhr, status, error) {
                console.error("Error occurred during the reset search: ", error);
            }
        });
    });

    //조회, 초기화 누르기 전 tr
    $('tr').click(function(event) {
        const checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.check-user').click(function(event) {
        event.stopPropagation();
    });

    //조회, 초기화 누른 후 tr
    $('.main-search').on('click', 'tr', function(event) {
        const checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.main-search').on('click', '.check-user', function(event) {
        event.stopPropagation();
    });

    /*체크된 항목 추가할 리스트에 추가하기*/
    const proNum = $('#proNum').val();

    $('.add-user').click(function() {
        event.preventDefault();
        // 체크된 항목 확인

        $('.main-search input[type="checkbox"]:checked').each(function () {
            const checkbox = $(this);
            const row = checkbox.closest('tr');


            const userInfo = {
                userNum: checkbox.data('usernum'), // 소문자와 카멜 케이스로 접근
                userName: checkbox.data('username'), // 카멜 케이스로 접근
                employmentStatusDetailName: checkbox.data('employmentstatusdetailname'), // 카멜 케이스로 접근
                rankDetailName: checkbox.data('rankdetailname'), // 카멜 케이스로 접근
                gradeDetailName: checkbox.data('gradedetailname'), // 카멜 케이스로 접근
                proNum: proNum // 이미 정의된 변수를 사용
            };

            const exists = checkedPros.some(item => item.userNum === userInfo.userNum);

            if (!exists) {
                checkedPros.push(userInfo);
                console.log(userInfo);
                row.css('display', 'none');
            }
        });
        console.log(checkedPros);
        // 체크된 항목이 없는 경우
        if (('.main-search input[type="checkbox"]:checked').length === 0) {
            alert('추가할 프로젝트를 선택해주세요.');
            return;  // 아무 동작 없이 함수 종료
        }

        $('.add-userMain').empty();

        checkedPros.forEach(function (user) {

            let newRow = '<tr>' +
                '<td><input type="checkbox" id="' + user.userNum + '" class="check-user" style="display: none"/></td>' +
                '<td>' + user.userNum + '</td>' +
                '<td>' + user.userName+ '</td>' +
                '<td>' + user.rankDetailName + '</td>' +
                '<td>' + user.gradeDetailName + '</td>' +
                '<td><input type="date" name="inputDate"/></td>' +
                '<td><input type="date" name="witDate"/></td>' +
                '<td><select name="roleCD" id="roleCD">' +
                '<option value="default">--역할 선택--</option>';

            roleList.forEach(function (role) {
                newRow += '<option value="' + role.detailCD + '">' + role.detailCdName + '</option>';
            });

            newRow += '</select></td>' +
                '<td><button class="delete-add" style="background-color: transparent; font-size: 16px; border: none;">&nbsp;❌&nbsp;</button></td>' +
                '</tr>';

            $('.add-userMain').append(newRow);

            /* 해당 리스트 삭제하기 */
            $(document).on('click', '.delete-add', function () {
                const row = $(this).closest('tr');
                const userNum = row.find('.check-user').attr('id'); // 삭제할 요소의 proNum 가져오기

                // 'checkedPros' 배열에서 해당 'proNum'을 가진 요소의 인덱스를 찾아 제거
                const index = checkedPros.findIndex(item => item.userNum.toString() === userNum);
                if (index !== -1) {
                    checkedPros.splice(index, 1); // 배열에서 해당 요소 제거
                }
                $(`.main-search input[type="checkbox"]#${userNum}`).closest('tr').show().find('input[type="checkbox"]').prop('checked', false);

                console.log(checkedPros);

                row.remove();
            });

            /*모든 프로젝트 삭제*/
            $('.delete-all').click(function () {
                event.preventDefault();
                checkedPros = [];

                $('.add-userMain tr').remove();

                $('.main-search tr').css('display', '');
                $('.main-search input[type="checkbox"]').prop('checked', false);
            });


            /*프로젝트 추가*/
            $('.add-match').off('click').on('click', function(event) {
                event.preventDefault();
                let newDataArray = checkedPros.map(item => {
                    return {
                        userNum : item.userNum,
                        proNum : item.proNum,
                        inputDate : '',
                        witDate : '',
                        roleCD : ''
                    }
                });

                $('.add-userMain tr').each(function (index){

                    const row = $(this);
                    const  userNum = row.find('.check-user').attr('id');

                    const  inputDate = row.find('input[name="inputDate"]').val();
                    console.log('inputDate:', inputDate);
                    const witDate = row.find('input[name="witDate"]').val();
                    const roleCD = row.find(('select[name="roleCD"]')).val();

                    const item = newDataArray.find(item => parseInt(item.userNum) === parseInt(userNum));
                    if (item) {
                        item.inputDate = inputDate;
                        item.witDate = witDate;
                        item.roleCD = roleCD;
                    }
                });

                const jsonPayload = JSON.stringify({MatchProDtoList : newDataArray});

                console.log(jsonPayload);
                $.ajax({
                    url: '/addMatchUser',
                    type: 'POST',
                    data: jsonPayload,
                    contentType: 'application/json',
                    success: function (data) {
                        checkedPros = [];
                        alert('해당 프로젝트에 사원이 등록되었습니다.');
                        window.location.href = '/match/proMatch?proNum=' + proNum;
                    },
                    error: function (xhr, status, error) {
                        alert('해당 프로젝트에 사원등록이 실패하였습니다.');
                    }

                });
            });
        });

    });

    /*매치 삭제*/
    $('.delete').click(function (){
        event.preventDefault();
        let seletedList = [];

        $('.check-match:checked').each(function (){
            seletedList.push($(this).attr('id'));
        });

        if(seletedList.length === null){
            alert('선택한 항목이 없습니다.');
            return;
        }

        console.log(seletedList);

        let dataToSand = JSON.stringify({
            proNum : proNum,
            userNumList : seletedList
        });

        console.log(dataToSand);

        const isDelete = confirm('투입된 사원을 삭제하시겠습니까?')

        if(isDelete){
            $.ajax({
                url: '/deleteMatchUser',
                type: 'POST',
                contentType: 'application/json',
                data: dataToSand,
                success: function(response){
                    // 삭제 성공 시 처리
                    console.log('deleted:', dataToSand);
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
        }else {
            return;
        }
    });

    $('.match-modify').click(function (){
        event.stopPropagation();

        const row = $(this).closest('tr');

        row.find('input').prop('readOnly', false);
        row.find('select').prop('disabled', false);

        row.find('.set-modify').css('display','');
        row.find('.match-modify').css('display','none');

        $('.set-modify').click(function (){
            event.stopPropagation();

            const row = $(this).closest('tr');

            const  userNum = row.find('.check-match').attr('id');
            console.log(proNum);
            const  inputDate = row.find('input[name="inputDate"]').val();
            const witDate = row.find('input[name="witDate"]').val();
            const roleCD = row.find(('select[name="roleCD"]')).val();

            const updateData ={
                userNum : userNum,
                proNum : proNum,
                inputDate : inputDate,
                witDate : witDate,
                roleCD : roleCD
            }

            $.ajax({
                url: '/updateMatchInfo',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(updateData),
                success: function(response){
                    // 삭제 성공 시 처리
                    alert("수정 처리되었습니다.");
                    row.find('.set-modify').css('display','none');
                    row.find('.match-modify').css('display','');
                    window.location.reload(); // AJAX 요청이 완료된 후에 페이지 리로드
                },
                error: function(xhr, status, error) {
                    // 오류 처리
                    console.error('Error updating user:', error);
                    console.log(xhr.responseText); // 서버 응답을 콘솔에 출력
                    alert("수정이 완료되지 않았습니다.");
                }
            })
        })

    });

});