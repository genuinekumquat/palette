<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>클래스 등록 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<main class="content wrap">
	<div class="form-box wide">
		<h2 class="page-title">CLASS 등록</h2>

		<!-- 파일 업로드 => enctype="multipart/form-data" -->
		<form action="classWritePro.cbo" method="post" enctype="multipart/form-data">
			<div class="form-row">
				<label>제목</label>
				<input type="text" name="classSubject" class="form-control" required="required">
			</div>
			<div class="form-row">
				<label>가격</label>
				<input type="number" name="classPrice" class="form-control" min="0" required="required">
			</div>
			<div class="form-row">
				<label>카테고리</label>
				<select name="classCategory" class="form-control" required="required">
<%	for(String c : ClassBoardDTO.CATEGORIES) { %>
					<option value="<%=c %>"><%=c %></option>
<%	} %>
				</select>
			</div>
			<div class="form-row">
				<label>지역</label>
				<select name="classLocation" class="form-control" required="required">
<%	for(String l : ClassBoardDTO.LOCATIONS) { %>
					<option value="<%=l %>"><%=l %></option>
<%	} %>
				</select>
			</div>
			<div class="form-row">
				<label>소개</label>
				<textarea name="classContent" class="form-control"></textarea>
			</div>
			<div class="form-row">
				<label>대표 이미지</label>
				<input type="file" name="classFile" accept="image/*">
			</div>
			<input type="submit" value="글쓰기" class="btn btn-primary btn-block">
		</form>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
