<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.ReviewBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 리뷰 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 로그인한 아이디로 작성된 리뷰 리스트 (최신 작성순)
List<ReviewBoardDTO> boardList = (List<ReviewBoardDTO>)request.getAttribute("boardList");
%>
<main class="content wrap" style="max-width: 760px;">
	<h2 class="page-title">나의 리뷰</h2>
<%
if(boardList == null || boardList.isEmpty()) {
%>
	<p class="empty">작성한 리뷰가 없습니다.</p>
<%
} else {
	for(ReviewBoardDTO boardDTO : boardList) {
%>
	<div class="review">
		<div class="review-info">
			<b><a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>&tab=review">클래스 보러가기 &rsaquo;</a></b><%=Html.date(boardDTO.getReviewIssueDate()) %>
		</div>
<%		if(boardDTO.getReviewFile() != null) { %>
		<img src="upload/<%=Html.encodePath(boardDTO.getReviewFile()) %>" class="review-img" alt="">
<%		} %>
		<p><%=Html.escapeLines(boardDTO.getReviewContent()) %></p>
	</div>
<%
	}
}
%>
	<div class="btn-group">
		<input type="button" value="마이페이지" class="btn" onclick="location.href='mypage.me'">
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
