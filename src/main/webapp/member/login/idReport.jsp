<%@page import="com.itwillbs.util.Html"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기 결과 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 아이디 찾기에서 찾은 아이디 가져오기
// 찾은 아이디 있으면 id값 보여주기
// 찾은 아이디 없으면 회원정보가 존재하지 않습니다
String findId = (String)request.getAttribute("findId");
%>
<main class="content wrap">
	<div class="form-box">
		<h2 class="page-title">아이디 찾기</h2>
<%
if(findId != null){
%>
		<p class="result-text">가입하신 아이디는 '<strong><%=Html.escape(findId) %></strong>' 입니다</p>
<%
} else {
%>
		<p class="result-text">회원정보가 존재하지 않습니다</p>
<%
}
%>
		<div class="btn-group">
			<input type="button" value="로그인 하기" class="btn btn-primary" onclick="location.href='login.me'">
			<input type="button" value="비밀번호 찾기" class="btn" onclick="location.href='findPassword.me'">
		</div>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
