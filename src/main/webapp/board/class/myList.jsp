<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 클래스 관리</title>
<style type="text/css">
.products{
    width: 735px;
    margin-left: auto;
    margin-right: auto;
}

.products h3{
    font-size: 24px;
    color: #545454;
    margin-top: 60px;
    margin-bottom: 60px;
    text-align: center;
}

.product{
    display: block;
    width: 225px;
    text-align: center;
    text-decoration: none;
    color: black;
    float: left;
    margin-left: 10px;
    margin-right: 10px;
    margin-bottom: 30px;
}

.product img{
    object-fit: cover;
}

.product-name{
    margin-top: 20px;
    margin-bottom: 4px;
}

.clearfix{
    clear: both;
}

.empty{
    text-align: center;
    color: #999;
}

.buttons{
    text-align: center;
    margin-top: 20px;
}
</style>
</head>
<body>
<%!
// 클래스 제목 => HTML 태그로 실행되지 않게 변환
String escape(String str) {
	if(str == null) {
		return "";
	}
	return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
			.replace("\"", "&quot;").replace("'", "&#39;");
}
%>
<%
// 로그인한 호스트가 등록한 클래스 리스트 (최신 등록순)
List<ClassBoardDTO> boardList = (List<ClassBoardDTO>)request.getAttribute("boardList");
%>
<div class="products">
	<h3>나의 클래스 관리</h3>

<%
if(boardList == null || boardList.isEmpty()) {
%>
	<p class="empty">등록한 클래스가 없습니다.</p>
<%
} else {
	for(ClassBoardDTO boardDTO : boardList) {
%>
	<%-- 클릭하면 상세페이지 => 수정, 삭제 --%>
	<a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>" class="product">
		<img src="<%=boardDTO.getClassFile() != null ? "upload/" + escape(boardDTO.getClassFile()) : "images/cat-space.gif" %>" width="225" height="225">
		<div class="product-name">
			제목 : <%=escape(boardDTO.getClassSubject()) %>
		</div>
		<div class="product-price">
			금액 : <%=boardDTO.getClassPrice() %>
		</div>
	</a>
<%
	}
}
%>
	<div class="clearfix"></div>

	<div class="buttons">
		<input type="button" value="클래스 등록" class="btn" onclick="location.href='classWrite.cbo'">
		<input type="button" value="클래스 목록" class="btn" onclick="location.href='classList.cbo'">
	</div>
</div>
</body>
</html>
