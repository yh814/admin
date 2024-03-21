<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
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
<link rel="stylesheet" href="${root }css/match.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script>
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
    
    $('#searchProName, #searchCusName, #searchProgressName').keypress(function(event) {
        // 엔터키가 눌렸을 때
        if (event.which === 13) {
            event.preventDefault(); // 폼의 기본 제출 동작을 방지
            $('#searchButton').click(); // 조회 버튼 클릭
        }
    });
    
    /* 프로젝트 검색 */
    $('#searchButton').click(function(event) {
		const searchProName = $('#searchProName').val();
		const searchCusName = $('#searchCusName').val();
		const searchProgressName = $('#searchProgressName').val();
		const userNum = $('#userNum').val();

        $.ajax({
            type: 'GET',
            url: '/userMatchProSearch',
			dataType: 'json',
            data: {
                searchProName: searchProName,
                searchCusName: searchCusName,
                searchProgressName: searchProgressName,
                userNum: userNum
            },
            
            success: function(data) {
                const tableBody = $('.main-search');
                tableBody.empty();

                if (data && data.length > 0) {
	                data.forEach(function(project) {
						const row = '<tr>' +
	                        '<td><input type="checkbox" id="' + project.proNum + '" class="check-pro"/></td>' +
	                        '<td>' + project.proNum + '</td>' +
	                        '<td>' + project.proName + '</td>' +
	                        '<td>' + project.cusDetailName + '</td>' +
	                        '<td>' + project.startDate + '</td>' +
	                        '<td>' + project.endDate + '</td>' +
	                        '<td>' + project.progressDetailName + '</td>' +
	                        '<td>' + project.userCnt + '명</td>' + // 수정: 프로젝트별 사용자 수
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
        $('#searchProName').val('');
        $('#searchCusName').val('');
        $('#searchProgressName').val('');

        $.ajax({
            type: 'GET',
            url: '/userMatchProSearch',
			dataType: 'json',
            data: {
                searchProName: '',
                searchCusName: '',
                searchProgressName: '',
                userNum: $('#userNum').val()
            },
            
            success: function(data) {
                const tableBody = $('.main-search');
                tableBody.empty();

                if (data && data.length > 0) {
                    data.forEach(function(project) {
						let row;
						row = '<tr>' +
								'<td><input type="checkbox" id="' + project.proNum + '" class="check-pro"/></td>' +
								'<td>' + project.proNum + '</td>' +
								'<td>' + project.proName + '</td>' +
								'<td>' + project.cusDetailName + '</td>' +
								'<td>' + project.startDate + '</td>' +
								'<td>' + project.endDate + '</td>' +
								'<td>' + project.progressDetailName + '</td>' +
								'<td>' + project.userCnt + '명</td>' +
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
		const checkbox = $(this).find('.check-pro');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.check-pro').click(function(event) {
        event.stopPropagation();
    });
    
    //조회, 초기화 누른 후 tr
    $('.main-search').on('click', 'tr', function(event) {
		const checkbox = $(this).find('.check-pro');
        checkbox.prop('checked', !checkbox.prop('checked'));
        event.stopPropagation();
    });

    $('.main-search').on('click', '.check-pro', function(event) {
        event.stopPropagation();
    });

    
});
</script>
<body>

	<div class="userInfo-sec" >
	        <p class="userInfo-title">사원정보</p>
	        <div class="userInfo-box">
	            <div class="userInfo-item">
	                <p class="mini-title">사원명 : </p>
	                <input type="text" id="userName"  name="userName" readonly="readonly" class="input-info" value="${userMatchInfo.userName }">
	                <p class="mini-title">기술등급 : </p>
	                <input type="text" id="rankDetailName"  name="rankDetailName" readonly="readonly" class="input-info"  value="${userMatchInfo.rankDetailName }">
	                <p class="mini-title">직급 : </p>
	                <input type="text" id="gradeDetailName"  name="gradeDetailName" readonly="readonly" class="input-info" value="${userMatchInfo.gradeDetailName }">
	            </div>
	        </div>	    
	</div>
	
	<div class="userProInfo-sec">
		<p class="userInfo-title">프로젝트 리스트</p>
		<table class="table">
        <thead>
            <tr>
            	<th><input type="checkbox" id="check-match" class="check-match" disabled/></th>
                <th>프로젝트번호</th>
                <th>프로젝트명</th>
                <th>고객사명</th>
                <th>진행현황</th>
                <th>프로젝트 시작일</th>
                <th>프로젝트 종료일</th>
                <th>투입일</th>
                <th>철수일</th>
                <th>역할</th>
                <th>상세수정</th>
            </tr>
        </thead>
        <tbody class="main">
	        <c:choose>
	        	<c:when test="${empty userProList}">
			        <tr>
			            <td colspan="11">데이터가 없습니다.</td>
			        </tr>
			    </c:when>
			    <c:otherwise>
		            <c:forEach var="match" items="${userProList}">
		                <tr>
		                	<td><input type="checkbox" id="${match.proNum }" class="check-match"/></td>
		                    <td>${match.proNum}</td>
		                    <td>${match.proName}</td>
		                    <td>${match.cusDetailName}</td>
		                    <td>${match.progressDetailName}</td>
		                    <td>${match.startDate}</td>
		                    <td>${match.endDate}</td>
		                    <td>${match.inputDate}</td>
		                    <td>${match.witDate}</td>
		                    <td>${match.roleDetailName}</td>
		                    <td>
		                        <a href="#">
		                            <button class="match-modify">상세/수정</button>
		                        </a>
		                    </td>
		                </tr>
		            </c:forEach>
	            </c:otherwise>
            </c:choose>
        </tbody>     
    </table>
    
    	<div class="pro-btn">
			<button class="add" id="add">프로젝트 추가</button> 
			<!-- 프로젝트 추가 모달 -->
				<form id="add-modal" class="add-modal">
					<input type="hidden" id="userNum" value="${userMatchInfo.userNum}" />
					<div class="modal">		
						<!-- 닫기버튼 -->
						<span class="close" id="closeModalBtn">&times;</span>
												
				        <div class="search-box">
				      		<p class="search-title">검색조건</p>
				            <div class="search-item">
				                <p class="mini-title">프로젝트명 : </p>
				                <input type="text" id="searchProName"  name="searchProName">
				
				                <p class="mini-title">고객사 : </p>
				                <select id="searchCusName" name="searchCusName">
				                    <option value="">전체</option>
				                    <c:forEach var="cus" items="${cusList}">
				                        <option value="${cus.detailCD}">${cus.detailCdName}</option>
				                    </c:forEach>
				                </select>
				
				                <p class="mini-title">진행상태 : </p>
				                <select id="searchProgressName" name="searchProgressName">
				                    <option value="">전체</option>
				                    <c:forEach var="progress" items="${progressList}">
				                        <option value="${progress.detailCD}">${progress.detailCdName}</option>
				                    </c:forEach>
				                </select>			
				            </div>
				            
				            <div class="search-item-skill">
				                <button type="button" id="searchButton" class="searchButton">조회</button>
				                <button type="button" id="resetBtn" class="resetBtn">초기화</button>				                
				            </div>
				        </div><!-- searchbox-div -->
				        
				        <div class="search-result">
				        	<p class="result-title">프로젝트 리스트</p>
						    <table class="result-table">
						        <thead>
						            <tr>
						            	<th><input type="checkbox" id="check-pro" class="check-pro" disabled/></th>
						                <th>프로젝트 번호</th>
						                <th>프로젝트명</th>
						                <th>고객사</th>
						                <th>시작일</th>
						                <th>종료일</th>
						                <th>진행상태</th>
						                <th>총인원</th>					                
						            </tr>
						        </thead>
						        <tbody class="main-search">
						            <c:forEach var="project" items="${allProList}" >
						                <tr>
						                	<td><input type="checkbox" id="${project.proNum }" class="check-pro"/></td>
						                    <td>${project.proNum}</td>
						                    <td>${project.proName}</td>
						                    <td>${project.cusDetailName}</td>
						                    <td>${project.startDate}</td>
						                    <td>${project.endDate}</td>
						                    <td>${project.progressDetailName}</td>
						                    <td>${userCnt}명</td>
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
										<a href="${root }match/userMatch#Modal&page=${pageBean.prevPage}" class="page-link">이전</a>
									</li>
									</c:otherwise>
									</c:choose>
									
									
									<c:forEach var='idx' begin="${pageBean.min }" end='${pageBean.max }'>
									<c:choose>
									<c:when test="${idx == pageBean.currentPage }">
									<li class="page-item-active">
										<a href="${root }match/userMatch#Modal?page=${idx}" class="page-link">${idx }</a>
									</li>
									</c:when>
									<c:otherwise>
									<li class="page-item">
										<a href="${root }match/userMatch#Modal?page=${idx}" class="page-link" class="page-link">${idx }</a>
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
				        
				        
			        </div><!-- modal-div -->
			    </form>
			
	        <button class="delete">프로젝트 삭제</button> 
        </div>
	</div>
</body>
</html>