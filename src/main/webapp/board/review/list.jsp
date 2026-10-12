<%@page import="com.itwillbs.domain.ReviewBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 리뷰</title>
<style type="text/css">
.review-list{
    width: 735px;
    margin: 60px auto;
}

.review-list h1{
    text-align: center;
}

.review{
    padding: 15px 0;
    border-bottom: 1px solid #eee;
}

.review-info{
    font-size: 13px;
    color: #545454;
    margin-bottom: 10px;
}

.review-img{
    display: block;
    max-width: 300px;
    margin-bottom: 10px;
}

.review-empty{
    color: #999;
    text-align: center;
}
</style>
</head>
<body>
<%!
// 사용자가 입력한 리뷰 내용 => HTML 태그로 실행되지 않게 변환
String escape(String str) {
	if(str == null) {
		return "";
	}
	return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
			.replace("\"", "&quot;").replace("'", "&#39;");
}
%>
<%
// 로그인한 아이디로 작성된 리뷰 리스트 (최신 작성순)
List<ReviewBoardDTO> boardList = (List<ReviewBoardDTO>)request.getAttribute("boardList");
%>
<div class="review-list">
	<h1>나의 리뷰</h1>
<%
if(boardList == null || boardList.isEmpty()) {
%>
	<p class="review-empty">작성한 리뷰가 없습니다.</p>
<%
} else {
	for(ReviewBoardDTO boardDTO : boardList) {
%>
	<div class="review">
		<div class="review-info">
			<a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>&tab=review">클래스 보러가기</a><br>
			작성일 : <%=boardDTO.getReviewIssueDate() %>
		</div>
<%		if(boardDTO.getReviewFile() != null) { %>
		<img src="upload/<%=escape(boardDTO.getReviewFile()) %>" class="review-img">
<%		} %>
		<p><%=escape(boardDTO.getReviewContent()).replace("\n", "<br>") %></p>
	</div>
<%
	}
}
%>
</div>
</body>
</html>
