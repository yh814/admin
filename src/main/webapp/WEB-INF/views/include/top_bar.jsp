<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
    body {
        margin: 0;
        padding: 0;
    }

    .top-sec {
        width: 100%;
        height: 55px;
        top: 0;
        display: flex;
        justify-content: flex-end;
        align-items: center;
        background-color: white;
        position: fixed;
        z-index: 1000;
        font-weight: 500;
        font-size: 15px;
        color: rgb(51, 51, 51);
        line-height: 35px;
        letter-spacing: -1px;
        text-align: center;
    }

    #session_info{
        margin-right: 40px;
    }

    .logout{
        margin-left: 20px;
        margin-right: 40px;
        border: none;
        border-radius: 5px;
        background: #5F9EA0;
        color: white;
        font-size: 15px;
        cursor: pointer;
        width: 100px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .my-page{
        border: none;
        border-radius: 5px;
        background: #a6acac8c;
        color: white;
        font-size: 15px;
        cursor: pointer;
        width: 100px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
</style>
<body>
<div class="top-sec">
    <div id="session_info"></div>
    <button class="my-page"><a href="/user/myPage">내 정보</a></button>
    <button class="logout">로그아웃</button>
</div>
</body>

<script>
    $(document).ready(function (){
        getSessionInfo();
    })

    function getSessionInfo(){
        $.ajax({
            url: "/getSessionInfo",
            type: "GET",
            success: function (data){
                $("#session_info").text(data + " 님");
            },
            error: function (xhr, status, error){
                console.error("Failed to fetch session info:",error);
            }
        })
    }

    $(".logout").click(function (){
        const logout = confirm("로그아웃하시겠습니까?");
        if(logout){
            $.ajax({
                url:"/user/logout",
                type: "GET",
                success: function (){
                    location.href = '/login';
                },
                error: function (xhr, status, error){
                    console.error("Failed to fetch session info:",error);
                }
            });
        }else {
            return;
        }
    });
</script>
</html>
