<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 리뷰 작성할 클래스 번호
int classNum = (Integer)request.getAttribute("classNum");
%>
<main class="content wrap">
	<div class="form-box wide">
		<h2 class="page-title">리뷰 작성</h2>

		<!-- 파일 업로드 => enctype="multipart/form-data" -->
		<form action="reviewWritePro.rbo" method="post" enctype="multipart/form-data">
			<input type="hidden" name="classNum" value="<%=classNum %>">
			<div class="form-row">
				<textarea name="reviewContent" class="form-control" required="required" placeholder="클래스 후기를 남겨주세요."></textarea>
			</div>
			<div class="form-row">
				<label>사진첨부</label>
				<input type="file" name="reviewFile" accept="image/*">
			</div>
			<input type="submit" value="작성" class="btn btn-primary btn-block">
		</form>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
