<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 재설정 | palette</title>
<jsp:include page="/inc/head.jsp" />
<style>
.email-row {
	display: flex;
	align-items: center;
	gap: 6px;
}
</style>
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<main class="content wrap">
	<div class="form-box">
		<h2 class="page-title">비밀번호 재설정</h2>
		<p class="desc">비밀번호는 가입시 사용한 아이디, 이름, 이메일을 통해 재설정 하실 수 있습니다.</p>

		<form action="findPasswordPro.me" method="post" id="findForm">
			<div class="form-row">
				<input type="text" name="memberId" class="form-control" placeholder="아이디" required="required">
			</div>
			<div class="form-row">
				<input type="text" name="memberName" class="form-control" placeholder="이름" required="required">
			</div>
			<div class="form-row email-row">
				<input type="text" id="emailId" class="form-control" placeholder="이메일" required="required">
				@
				<select id="emailDomain" class="form-control">
					<option value="">이메일을 선택해주세요</option>
					<option value="naver.com">naver.com</option>
					<option value="gmail.com">gmail.com</option>
					<option value="daum.net">daum.net</option>
					<option value="example.com">example.com</option>
				</select>
			</div>
			<!-- 이메일 아이디 + @ + 도메인 => 서버로 보낼 이메일 -->
			<input type="hidden" name="memberEmail" id="memberEmail">
			<input type="submit" value="비밀번호 재설정" class="btn btn-primary btn-block">
		</form>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />

<script type="text/javascript">
document.getElementById('findForm').onsubmit = function() {
	var domain = document.getElementById('emailDomain').value;
	if(domain == "") {
		alert("이메일을 선택해주세요");
		return false;
	}
	document.getElementById('memberEmail').value = document.getElementById('emailId').value + "@" + domain;
};
</script>
</body>
</html>
