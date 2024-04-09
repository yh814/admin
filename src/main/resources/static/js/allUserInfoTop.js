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
                            '<a href="/user/modify?userNum=' + user.userNum + '">' +
                            '<button class="user-modify">상세/수정</button>' +
                            '</a>' +
                            '</td>' +
                            '<td>' +
                            '<a href="/match/userMatch?userNum=' + user.userNum + '">' +
                            '<button class="user-modify">프로젝트관리</button>' +
                            '</a>' +
                            '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
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

    /* tr클릭 */
    $('tr').click(function() {
        const checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
    });

    $('.check-user, .user-modify').click(function(event) {
        event.stopPropagation();
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
