<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>클래스 수정 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%!
// 기존에 선택된 값이면 selected
String selected(String value, String option) {
	return option.equals(value) ? "selected=\"selected\"" : "";
}
%>
<%
// 수정할 클래스 기존 정보
ClassBoardDTO boardDTO = (ClassBoardDTO)request.getAttribute("boardDTO");
%>
<main class="content wrap">
	<div class="form-box wide">
		<h2 class="page-title">CLASS 수정</h2>

		<!-- 파일 업로드 => enctype="multipart/form-data" -->
		<form action="classUpdatePro.cbo" method="post" enctype="multipart/form-data">
			<input type="hidden" name="classNum" value="<%=boardDTO.getClassNum() %>">
			<div class="form-row">
				<label>제목</label>
				<input type="text" name="classSubject" class="form-control" value="<%=Html.escape(boardDTO.getClassSubject()) %>" required="required">
			</div>
			<div class="form-row">
				<label>가격</label>
				<input type="number" name="classPrice" class="form-control" min="0" value="<%=boardDTO.getClassPrice() %>" required="required">
			</div>
			<div class="form-row">
				<label>카테고리</label>
				<select name="classCategory" class="form-control" required="required">
<%	for(String c : ClassBoardDTO.CATEGORIES) { %>
					<option value="<%=c %>" <%=selected(boardDTO.getClassCategory(), c) %>><%=c %></option>
<%	} %>
				</select>
			</div>
			<div class="form-row">
				<label>지역</label>
				<select name="classLocation" class="form-control" required="required">
<%	for(String l : ClassBoardDTO.LOCATIONS) { %>
					<option value="<%=l %>" <%=selected(boardDTO.getClassLocation(), l) %>><%=l %></option>
<%	} %>
				</select>
			</div>
			<div class="form-row">
				<label>소개</label>
				<textarea name="classContent" class="form-control"><%=Html.escape(boardDTO.getClassContent()) %></textarea>
			</div>
			<div class="form-row">
				<label>대표 이미지</label>
<%	if(boardDTO.getClassFile() != null) { %>
				<img src="<%=Html.classImage(boardDTO.getClassFile()) %>" width="160" style="display:block; margin-bottom:10px; border-radius:8px;" alt="">
<%	} %>
				<!-- 새 이미지 선택 안하면 기존 이미지 유지 -->
				<input type="file" name="classFile" accept="image/*">
			</div>
			<input type="submit" value="수정하기" class="btn btn-primary btn-block">
		</form>
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
