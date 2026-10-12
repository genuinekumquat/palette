<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Class 수정</title>
</head>
<body>
<%!
// 입력값 => HTML 태그로 실행되지 않게 변환
String escape(String str) {
	if(str == null) {
		return "";
	}
	return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
			.replace("\"", "&quot;").replace("'", "&#39;");
}

// 기존에 선택된 값이면 selected
String selected(String value, String option) {
	return option.equals(value) ? "selected=\"selected\"" : "";
}
%>
<%
String memberId = (String)session.getAttribute("memberId");
// 수정할 클래스 기존 정보
ClassBoardDTO boardDTO = (ClassBoardDTO)request.getAttribute("boardDTO");
String category = boardDTO.getClassCategory();
String location = boardDTO.getClassLocation();
%>
	<h1>Class 수정</h1>

	<!-- 파일 업로드 => enctype="multipart/form-data" -->
	<form action="classUpdatePro.cbo" method="post" enctype="multipart/form-data">
		<input type="hidden" name="classNum" value="<%=boardDTO.getClassNum() %>">
		<table id="notice">
			<tr>
				<td>Class 제목</td>
				<td><input type="text" name="classSubject" value="<%=escape(boardDTO.getClassSubject()) %>"></td>
			</tr>
			<tr>
				<td>Class 가격</td>
				<td><input type="text" name="classPrice" value="<%=boardDTO.getClassPrice() %>"></td>
			</tr>
			<tr>
				<td>Class 카테고리</td>
				<td>
				<select style="width: 200px;" name="classCategory" class="form-control" required="required">
				<option value="야외/체험" <%=selected(category, "야외/체험") %>>야외/체험</option>
				<option value="만들기" <%=selected(category, "만들기") %>>만들기</option>
				<option value="강의" <%=selected(category, "강의") %>>강의</option>
				</select></td>
			</tr>
			<tr>
				<td>Class 지역</td>
				<td>
				<select style="width: 200px;" name="classLocation" class="form-control" required="required">
				<option value="서울" <%=selected(location, "서울") %>>서울</option>
				<option value="경기" <%=selected(location, "경기") %>>경기</option>
				<option value="부산" <%=selected(location, "부산") %>>부산</option>
				<option value="제주" <%=selected(location, "제주") %>>제주</option>
				</select></td>
			</tr>
			<tr>
				<td>Class 소개</td>
				<td><textarea rows="10" cols="20" name="classContent"><%=escape(boardDTO.getClassContent()) %></textarea></td>
			</tr>
			<tr>
				<td>대표 이미지</td>
				<td>
<%	if(boardDTO.getClassFile() != null) { %>
				<img src="upload/<%=escape(boardDTO.getClassFile()) %>" width="150"><br>
<%	} %>
				<!-- 새 이미지 선택 안하면 기존 이미지 유지 -->
				<input type="file" name="classFile" accept="image/*">
				</td>
			</tr>
		</table>
		<div id="table_search">
			<input type="submit" value="수정하기" class="btn">
		</div>
	</form>

</body>
</html>
