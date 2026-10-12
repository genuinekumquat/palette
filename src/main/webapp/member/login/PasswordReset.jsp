<%@page import="com.itwillbs.util.Html"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
// "resetId" 세션값 가져오기=> 비밀번호 찾기에서 본인확인된 아이디
String resetId = (String)session.getAttribute("resetId");
%>
<h1>비밀번호 재설정</h1>
<h4>비밀번호는 6자 이상이어야 합니다.</h4>

<form action="PasswordResetPro.me" method="post">

아이디 : <input type="text" value="<%=Html.escape(resetId) %>" readonly="readonly"><br>
새 비밀번호 : <input type="password" name="memberPassword" minlength="6" required="required"><br>
새 비밀번호 확인 : <input type="password" ><br>

<input type="submit" value="변경하기">
</form>
</body>
</html>