<%@page import="com.itwillbs.util.Html"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>idCheck</title>
</head>
<body>
<%
// 아이디 찾기에서 찾은 아이디 가져오기 (세션 "memberId"에 넣으면 로그인 상태가 되므로 request로 전달)
String findId=(String)request.getAttribute("findId");
//찾은 아이디 있으면  id값 보여주기
//찾은 아이디 없으면 회원정보가 존재하지 않습니다
if(findId != null){
%>
<p align="center" style = "font-size:20px">가입하신 아이디는 '<%=Html.escape(findId) %>' 입니다</p>
<%	
} else {
%>
<p align="center" style = "font-size:20px">회원정보가 존재하지 않습니다 </p> 
<%
}
%> 
<br>
<p align="center">
<input type="button" value="로그인 하기" onclick="location.href='login.me'"> 
<input type="button" value ="비밀번호 찾기"  onclick="location.href='findPassword.me'" >
</p>
</body>
</html>