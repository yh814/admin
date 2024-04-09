$(document).ready(function() {
    function search() {
        const selected = $("#searchCate").val();
        const searchValue = encodeURIComponent($(".search-input").val());

        let searchCondition = "";

        if (selected === "search-title") {
            searchCondition = "searchTitle=" + searchValue;
        } else if (selected === "search-detail") {
            searchCondition = "searchContents=" + searchValue;
        } else if (selected === "search-writer") {
            searchCondition = "searchUserId=" + searchValue;
        } else if(selected === "search-default"){
            searchCondition = "searchTitle="+searchValue+"&searchContents="+searchValue+"&searchUserId="+searchValue;
        }

        $.ajax({
            url: "/searchFreeBoard",
            type: "POST",
            dataType: "json",
            data: searchCondition,
            success: function(responseData) {
                const tbody = $(".main");
                tbody.empty();
                console.log(responseData);

                if(responseData.length > 0){
                    responseData.forEach(board => {
                        let row = '<tr>' +
                            '<td>' + board.boardTitle + '</td>' +
                            '<td>' + board.boardContents + '</td>' +
                            '<td>' + board.userId + '</td>' +
                            '<td>' + board.boardRegDate + '</td>' +
                            '</tr>'
                        tbody.append(row);
                    });
                }else{
                    let row = '<tr>' + '<td colspan="10">데이터가 없습니다</td>' + '</tr>';
                    tbody.append(row);
                }

            },
            error: function(xhr, status, error) {
                console.error("AJAX 오류:", error);
            }
        });
    }

    $(".search-btn").click(function () {
        search();
    });
});
