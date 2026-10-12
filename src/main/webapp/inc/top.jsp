<%@page import="com.itwillbs.util.Html"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 모든 페이지 상단 공통 => 로고, 메뉴, 검색창, 로그인 상태
String ctx = request.getContextPath();
String loginId = (String)session.getAttribute("memberId");
// 검색 후에도 검색창에 검색어 유지
String keyword = request.getParameter("search");
%>
<header class="header">
	<div class="wrap">
		<a href="<%=ctx %>/main.me" class="logo"><img src="<%=ctx %>/images/palette-logo.png" alt="palette"></a>

		<nav class="menu">
			<a href="<%=ctx %>/noticeList.nbo">공지사항</a>
			<a href="#">Q&amp;A</a>
			<a href="<%=ctx %>/classList.cbo">카테고리</a>
		</nav>

		<%-- 검색창 => 제목에 키워드가 포함된 클래스 조회 --%>
		<form action="<%=ctx %>/classList.cbo" method="get" class="search">
			<input type="search" name="search" value="<%=Html.escape(keyword) %>" placeholder="지금 생각나는 취미를 검색하세요!">
			<button type="submit">검색</button>
		</form>

		<div class="user">
<%	if(loginId == null) { %>
			<a href="<%=ctx %>/ghselect.me">회원가입</a>
			<a href="<%=ctx %>/login.me">로그인</a>
<%	} else { %>
			<a href="<%=ctx %>/logout.me">로그아웃</a>
			<a href="<%=ctx %>/mypage.me">마이페이지</a>
<%	} %>
		</div>
	</div>
</header>
