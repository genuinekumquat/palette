<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<main class="content wrap">
	<div class="form-box">
		<h2 class="page-title">아이디 찾기</h2>
		<p class="desc">가입시 입력한 이름과 이메일로 아이디를 찾을 수 있습니다.</p>

		<form action="findIdPro.me" method="post">
			<div class="form-row">
				<input type="text" name="memberName" class="form-control" placeholder="이름" required="required">
			</div>
			<div class="form-row">
				<input type="email" name="memberEmail" class="form-control" placeholder="이메일" required="required">
			</div>
			<input type="submit" value="아이디 찾기" class="btn btn-primary btn-block">
		</form>

		<div class="form-links">
			<a href="login.me">로그인</a>|<a href="findPassword.me">비밀번호 찾기</a>
		</div>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
