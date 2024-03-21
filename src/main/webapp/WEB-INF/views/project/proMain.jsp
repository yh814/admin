
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var='root' value="${pageContext.request.contextPath }/" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<c:import url="/WEB-INF/views/include/top_bar.jsp" />
<link rel="stylesheet" href="${root }css/allUserInfo.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function() {
    $('#searchForm').submit(function(event) {
        event.preventDefault();

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
            	searchProName: searchProName,
            	searchProCust: searchProCust,
            	searchStartDate1: searchStartDate1,
            	searchStartDate2: searchStartDate2,
            	searchEndDate1: searchEndDate1,
            	searchEndDate2: searchEndDate2
            },
            success: function(data) {
				const tableBody = $('.main');
                tableBody.empty();
                console.log(data);

                    data.forEach(function(pro) {
						let row = '<tr>' +
                        	'<td>'+'<input type="checkbox" id="${pro.proNum}" class="check-user"/>'+'</td>'+
                            '<td>' + pro.userNum + '</td>' +
                            '<td>' + pro.proName + '</td>' +
                            '<td>' + pro.cusCD + '</td>' +
                            '<td>' + pro.progressDetailName + '</td>' +
                            '<td>' + pro.startDate + '</td>' +
                            '<td>' + pro.endDate + '</td>' +
                            '<td>';
						pro.skillDetailNameList.forEach(function(skill, index) {
                            row += skill;
                            if (index < user.skillDetailNameList.length - 1) {
                                row += ', ';
                            }
                        });
                        row += '</td>' +
                            '<td>' +
                            '<a href="${root}project/modify?proNum=' + pro.proNum + '">' +
                            '<button class="user-modify">상세/수정</button>' +
                            '</a>' +
                            '</td>' +
                            '<td>' +
                            '<a href="${root}project/modify?pro.proNum=' + pro.proNum + '">' +
                            '<button class="user-modify">상세/수정</button>' +
                            '</a>' +
                            '</td>' +
                            '</tr>';
                        tableBody.append(row);
                      
                    });
                    $('.pagination').hide();

                console.log(data);
            },
            error: function(xhr, status, error) {
                // 오류 처리
            }
        });
    });
    
    $('tr').click(function(event) {
		const checkbox = $(this).find('.check-user');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.check-user').click(function(event) {
        event.stopPropagation();
    });
    
});
</script>
<body>
<!-----------------------------------------------------------------  검색 필터  ----------------------------------------------------------------->
<div class="search-sec">
	<form action="${root}project/proMain" method="get">
		<p class="search-title">검색조건</p>
		<div class="search-box">
			<div class="search-item">
				<p class="mini-title">프로젝트명 : </p>
				<input type="text" id="searchProName" name="searchProName">
				
				<p class="mini-title">고객사명 : </p>			
					<select id="searchProCust" name="searchProCust">
						<option value="">전체</option>
						<c:forEach var="cusList" items="${cusList}">
					    	<option value="${cusList.detailCD}">${cusList.detailCdName}</option>
					    </c:forEach>
					</select>

			</div>
			<div class="search-item">
				<div class="start">
					<p class="mini-title">시작일 : </p>
					<input type="date" id="searchStartDate1" name="searchStartDate1"/>
					<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
					<input type="date" id="searchStartDate2" name="searchStartDate2"/>
				</div>
				<div class="start">
					<p class="mini-title">종료일 : </p>
					<input type="date" id="searchEndDate1" name="searchEndDate1"/>
					<p> ~ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
					<input type="date" id="searchEndDate2" name="searchEndDate2"/>
				</div>
			</div>
			<div class="search-item-skill">
			
				<input type="submit" value="검색" class="search-submit"/>
				<button type="button" id="resetBtn">초기화</button>
			</div>
		</div>
	</form>
</div>


<!-----------------------------------------------------------------  프로젝트 리스트 출력  ----------------------------------------------------------------->
<div class="info-sec">
	<p class="title">프로젝트 리스트</p>
	<table class="table" >
		<thead>
			<tr>
				<th><input type="checkbox" id="check-user" class="check-user" disabled/></th>
				<th>프로젝트 번호</th>				
				<th>프로젝트명</th>
				<th>고객사명</th>
				<th>진행현황</th>
				<th>시작일</th>
				<th>종료일</th>
				<th>필요기술</th>
				<th>상세/수정</th>
				<th>투입인원</th>
			</tr>
		</thead>
		<tbody class="main">
	        <c:forEach var="pro" items="${allPro}">
	        	<tr>
	        		<td><input type="checkbox" id="${pro.proNum }" class="check-user"/></td>
	            	<td>${pro.proNum}</td>
	                <td>${pro.proName}</td>
	                <td>${pro.cusDetailName}</td>
	                <td>${pro.progressDetailName}</td>
	                <td>${pro.startDate}</td>
	                <td>${pro.endDate}</td>
	                <td>
				        <c:forEach var="skill" items="${pro.skillDetailNameList}" varStatus="status">
				             ${skill}${status.last ? '' : ', '}
				        </c:forEach>
	                </td>                	                
	                <td>
	                    <a href="${root}project/modify?proNum=${pro.proNum}">
	                         <button class="user-modify">상세/수정</button>
	                    </a>   
	                </td>    
	                <td>
	                    <a href="${root}project/modify?proNum=${pro.proNum}">
	                         <button class="user-modify">인원관리</button>
	                    </a>   
	                </td> 
	            </tr>
	        </c:forEach>
        </tbody>

	</table>
	
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
						<a href="${root }project/proMain&page=${pageBean.prevPage}" class="page-link">이전</a>
					</li>
					</c:otherwise>
					</c:choose>
					
					
					<c:forEach var='idx' begin="${pageBean.min }" end='${pageBean.max }'>
					<c:choose>
					<c:when test="${idx == pageBean.currentPage }">
					<li class="page-item-active">
						<a href="${root }project/proMain?page=${idx}" class="page-link">${idx }</a>
					</li>
					</c:when>
					<c:otherwise>
					<li class="page-item">
						<a href="${root }project/proMain?page=${idx}" class="page-link" class="page-link">${idx }</a>
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
						<a href="${root }project/proMain?page${pageBean.nextPage}" class="page-link">다음</a>
					</li>
					</c:otherwise>
					</c:choose>
					
				</ul>
			</div>
			


</div>
<script>

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('resetBtn').addEventListener('click', function() {
        location.href="${root }project/proMain";
    });
});

</script>
</body>
</html>