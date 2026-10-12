<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<main class="content wrap">
	<div class="form-box">
		<h2 class="page-title">로그인</h2>

		<form action="loginPro.me" method="post">
			<div class="form-row">
				<input type="text" name="memberId" class="form-control" placeholder="아이디" required="required">
			</div>
			<div class="form-row">
				<input type="password" name="memberPassword" class="form-control" placeholder="비밀번호" required="required">
			</div>
			<input type="submit" value="로그인" class="btn btn-primary btn-block">
		</form>

		<div class="form-links">
			<a href="ghselect.me">회원가입</a>|<a href="findId.me">아이디 찾기</a>|<a href="findPassword.me">비밀번호 찾기</a>
		</div>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
