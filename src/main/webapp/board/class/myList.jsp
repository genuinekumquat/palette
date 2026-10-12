<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 클래스 관리 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 로그인한 호스트가 등록한 클래스 리스트 (최신 등록순)
List<ClassBoardDTO> boardList = (List<ClassBoardDTO>)request.getAttribute("boardList");
%>
<main class="content wrap">
	<h2 class="page-title">나의 클래스 관리</h2>

<%
if(boardList == null || boardList.isEmpty()) {
%>
	<p class="empty">등록한 클래스가 없습니다.</p>
<%
} else {
%>
	<div class="card-list">
<%
	for(ClassBoardDTO boardDTO : boardList) {
%>
		<%-- 클릭하면 상세페이지 => 수정, 삭제 --%>
		<a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>" class="card">
			<img src="<%=Html.classImage(boardDTO.getClassFile()) %>" class="card-img" alt="">
			<div class="card-title">제목 : <%=Html.escape(boardDTO.getClassSubject()) %></div>
			<div class="card-price">금액 : <%=boardDTO.getClassPrice() %></div>
		</a>
<%
	}
%>
	</div>
<%
}
%>

	<div class="btn-group">
		<input type="button" value="클래스 등록" class="btn btn-primary" onclick="location.href='classWrite.cbo'">
		<input type="button" value="마이페이지" class="btn" onclick="location.href='mypage.me'">
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
