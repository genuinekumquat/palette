<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>palette | 취미를 공유해 봐!</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 최근 등록된 클래스 3개
List<ClassBoardDTO> newList = (List<ClassBoardDTO>)request.getAttribute("newList");
%>

<section class="hero">
	<h1>취미를 공유해 봐!</h1>
	<p>palette에서 나만의 원데이 클래스를 만나보세요</p>
	<a href="classList.cbo" class="btn btn-primary">클래스 둘러보기</a>
</section>

<main class="wrap">
	<%-- 카테고리 => 클릭하면 해당 카테고리 클래스만 조회 --%>
	<section class="section">
		<h2 class="page-title">OUR CLASS</h2>
		<div class="category-tiles">
<%	for(String c : ClassBoardDTO.CATEGORIES) { %>
			<a href="classList.cbo?category=<%=Html.encode(c) %>" class="category-tile">
				<%=c %>
				<span>클래스 보기 &rsaquo;</span>
			</a>
<%	} %>
		</div>
	</section>

<%	if(newList != null && !newList.isEmpty()) { %>
	<section class="section">
		<h2 class="page-title">NEW CLASS</h2>
		<div class="card-list">
<%		for(ClassBoardDTO boardDTO : newList) { %>
			<a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>" class="card">
				<img src="<%=Html.classImage(boardDTO.getClassFile()) %>" class="card-img" alt="">
				<div class="card-title"><%=Html.escape(boardDTO.getClassSubject()) %></div>
				<div class="card-price"><%=boardDTO.getClassPrice() %>원</div>
			</a>
<%		} %>
		</div>
	</section>
<%	} %>
</main>

<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
