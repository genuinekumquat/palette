<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<style type="text/css">
.review-write{
    width: 500px;
    margin: 60px auto;
    text-align: center;
}

.review-write textarea{
    width: 100%;
    height: 200px;
    box-sizing: border-box;
}

.review-write .file{
    text-align: left;
    margin: 10px 0;
}

.review-write .btn{
    width: 100%;
}
</style>
</head>
<body>
<%
// 리뷰 작성할 클래스 번호
int classNum = (Integer)request.getAttribute("classNum");
%>
<div class="review-write">
	<h1>리뷰 작성</h1>

	<!-- 파일 업로드 => enctype="multipart/form-data" -->
	<form action="reviewWritePro.rbo" method="post" enctype="multipart/form-data">
		<input type="hidden" name="classNum" value="<%=classNum %>">
		<textarea name="reviewContent" required="required" placeholder="클래스 후기를 남겨주세요."></textarea>
		<div class="file">
			사진첨부 <input type="file" name="reviewFile" accept="image/*">
		</div>
		<input type="submit" value="작성" class="btn">
	</form>
</div>
</body>
</html>
