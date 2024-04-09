
$(document).ready(function() {
    $('#searchForm').submit(function(event) {
        event.preventDefault();
        loadPageData(1); // 초기 페이지 로드
    });

    $('.paging').change(function() {
        loadPageData(1); // 첫 번째 페이지로부터 데이터를 다시 불러옵니다.
    });


    let currentPageNumber = 1;
    function loadPageData(pageNumber) {
        currentPageNumber = pageNumber;

        const searchProName = $('#searchProName').val();
        const searchProCust = $('#searchProCust').val();
        const searchStartDate1 = $('#searchStartDate1').val();
        const searchStartDate2 = $('#searchStartDate2').val();
        const searchEndDate1 = $('#searchEndDate1').val();
        const searchEndDate2 = $('#searchEndDate2').val();

        $.ajax({
            type: 'GET',
            url: '/search_pro',
            dataType: 'json',
            data: {
                page: pageNumber,
                size: $('#paging').val(), // 페이지당 표시할 항목 수
                searchProName: searchProName,
                searchProCust: searchProCust,
                searchStartDate1: searchStartDate1,
                searchStartDate2: searchStartDate2,
                searchEndDate1: searchEndDate1,
                searchEndDate2: searchEndDate2
            },
            success: function(response) {
                const data = response.searchResult;
                const tableBody = $('.main');
                tableBody.empty();
                console.log(data);

                if (data && data.length > 0) {
                    data.forEach(function(pro) {
                        let row = '<tr>' +
                            '<td>' + '<input type="checkbox" id="' + pro.proNum + '" class="check-pro"/>' + '</td>' +
                            '<td>' + pro.proNum + '</td>' +
                            '<td>' + pro.proName + '</td>' +
                            '<td>' + pro.cusDetailName + '</td>' +
                            '<td>' + pro.progressDetailName + '</td>' +
                            '<td>' + pro.startDate + '</td>' +
                            '<td>' + pro.endDate + '</td>' +
                            '<td>';

                        pro.skillDetailNameList.forEach(function(skill, index) {
                            row += skill;
                            if (index < pro.skillDetailNameList.length - 1) {
                                row += ', ';
                            }
                        });
                        row += '</td>' +
                            '<td>' +
                            '<a href="/project/modify?proNum=' + pro.proNum + '">' +
                            '<button class="user-modify">상세/수정</button>' +
                            '</a>' +
                            '</td>' +
                            '<td>' +
                            '<a href="/match/proMatch?proNum=' + pro.proNum + '">' +
                            '<button class="user-modify">인원관리</button>' +
                            '</a>' +
                            '</td>' +
                            '</tr>';
                        tableBody.append(row);
                    });
                    console.log(data);
                    updatePagination(response.pageInfo); // 페이징 네비게이션 업데이트
                } else {
                    let row = '<tr>' + '<td colspan="10">데이터가 없습니다</td>' + '</tr>';
                    tableBody.append(row);
                }
            },
            error: function(xhr, status, error) {
                console.log("오류가 발생했습니다: " + error);
            }
        });
    }

    function updatePagination(pageInfo) {
        const pagination = $('.pagination');
        pagination.empty(); // 기존 페이징 네비게이션 삭제

        // 이전 페이지 버튼 생성
        const prevButton = $('<a href="#" class="page-link">&laquo;</a>');
        if (pageInfo.prevPage > 1) {
            prevButton.click(function(e) {
                e.preventDefault();
                loadPageData(pageInfo.prevPage);
            });
        } else {
            prevButton.css('disabled',true); // 이전 버튼 비활성화
            prevButton.click(function(e) {
                e.preventDefault(); // 클릭 이벤트 비활성화
            });
        }
        pagination.append(prevButton);

        // 페이지 번호 버튼 생성
        for (let i = pageInfo.min; i <= pageInfo.max; i++) {
            const pageButton = $('<a href="#" class="page-link">'+i+'</a>');
            if (i === pageInfo.currentPage) {
                pageButton.addClass('active'); // 현재 페이지 스타일
            }
            console.log(pageInfo.min, pageInfo.max, pageInfo.currentPage);
            pageButton.click(function(e) {
                e.preventDefault();
                loadPageData(i);
            });
            pagination.append(pageButton);
        }

        // 다음 페이지 버튼 생성
        const nextButton = $('<a href="#" class="page-link">&raquo;</a>');
        if (pageInfo.nextPage < pageInfo.pageCnt) {
            nextButton.click(function(e) {
                e.preventDefault();
                loadPageData(pageInfo.nextPage);
            });
        } else {
            nextButton.css('disabled',true); // 다음 버튼 비활성화
            nextButton.click(function(e) {
                e.preventDefault(); // 클릭 이벤트 비활성화
            });
        }
        pagination.append(nextButton);
    }


    /*프로젝트 삭제*/
    $('.pro-delete').click(function(){
        // 체크된 항목 확인
        const selectedPros =[];

        $('.check-pro:checked').each(function(){
            selectedPros.push(parseInt($(this).attr('id')));
        });

        // 체크된 항목이 없는 경우
        if (selectedPros.length === 0) {
            alert('삭제할 프로젝트를 선택해주세요.');
            return;  // 아무 동작 없이 함수 종료
        }

        // 확인 메시지 표시
        const confirmDelete = confirm('선택한 프로젝트에 대한 모든 정보가 삭제됩니다.\n정말로 삭제하시겠습니까?');

        // 확인을 눌렀을 경우
        if (confirmDelete) {
            // AJAX를 사용하여 서버에 삭제 요청 보내기
            $.ajax({
                type: 'POST',
                url: '/deletePro',
                contentType: 'application/json',
                data: JSON.stringify(selectedPros),
                success: function(response){
                    // 삭제 성공 시 처리
                    console.log('Project deleted:', selectedPros);
                    alert("삭제 처리되었습니다.");
                    loadPageData(currentPageNumber);
                },
                error: function(xhr, status, error) {
                    // 오류 처리
                    console.error('Error deleting project:', error);
                    console.log(xhr.responseText); // 서버 응답을 콘솔에 출력
                    alert("삭제가 완료되지 않았습니다.");
                }
            });
        } else {
            // 취소 시 동작 (아무 동작 없음)
            console.log('Delete operation canceled.');
        }
    });


});

$(document).on('click', 'tr', function(event) {
    const checkbox = $(this).find('.check-pro');
    checkbox.prop('checked', !checkbox.prop('checked'));
    event.stopPropagation();
});

$(document).on('click', '.check-pro', function(event) {
    event.stopPropagation();
});

$(document).ready(function(){

    $("#add-pro").click(function() {
        $("#myModal").css("display", "block");
    });


    $("#closeModalBtn").click(function() {
        const confirmAdd = confirm('입력된 정보가 모두 사라집니다.\n그래도 닫으시겠습니까?');
        if (confirmAdd) {
            $("#myModal input[type=text], #myModal input[type=date], #myModal select, #myModal textarea").val('');

            $("#myModal select").val('');

            $("#myModal").css("display", "none");
        } else {
            return;
        }
    });
});

/*글자수 제한*/
document.addEventListener("DOMContentLoaded", function (){
    const proName = document.getElementById("proName");
    const inputNameError = document.getElementById("proNameError");

    proName.addEventListener("input", function (){

        if(proName.value.length>20){
            proName.value = proName.value.substring(0,20);
            inputNameError.textContent ="20자 이하로 입력해주세요";
        }else {
            inputNameError.textContent="";
        }

    })

    const  noteArea = document.getElementById("note");
    const inputCount = document.getElementById("input-count");

    noteArea.addEventListener("input", function (){
        let currentLength = noteArea.value.length;

        if(currentLength>300){
            noteArea.value = noteArea.value.substring(0,300);
            currentLength = 300;
        }

        inputCount.textContent = currentLength + " / 300";

        if(currentLength>=300){
            inputCount.style.color = "red";
        }else {
            inputCount.style.color = "black";
        }
    });
});