<%@page import="com.itwillbs.util.Html"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 재설정 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// "resetId" 세션값 가져오기 => 비밀번호 찾기에서 본인확인된 아이디
String resetId = (String)session.getAttribute("resetId");
%>
<main class="content wrap">
	<div class="form-box">
		<h2 class="page-title">비밀번호 재설정</h2>
		<p class="desc">비밀번호는 6자 이상이어야 합니다.</p>

		<form action="PasswordResetPro.me" method="post" id="resetForm">
			<div class="form-row">
				<label>아이디</label>
				<input type="text" class="form-control" value="<%=Html.escape(resetId) %>" readonly="readonly">
			</div>
			<div class="form-row">
				<label>새 비밀번호</label>
				<input type="password" name="memberPassword" id="pw" class="form-control" minlength="6" required="required">
			</div>
			<div class="form-row">
				<label>새 비밀번호 확인</label>
				<input type="password" id="pw2" class="form-control" required="required">
			</div>
			<input type="submit" value="변경하기" class="btn btn-primary btn-block">
		</form>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />

<script type="text/javascript">
document.getElementById('resetForm').onsubmit = function() {
	if(document.getElementById('pw').value != document.getElementById('pw2').value) {
		alert("새 비밀번호가 일치하지 않습니다.");
		return false;
	}
};
</script>
</body>
</html>
