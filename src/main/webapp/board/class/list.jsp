<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.MemberDTO"%>
<%@page import="com.itwillbs.domain.PageDTO"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>클래스 목록 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
List<ClassBoardDTO> boardList =(List<ClassBoardDTO>)request.getAttribute("boardList");
PageDTO pageDTO = (PageDTO)request.getAttribute("pageDTO");
List<String> categoryList = (List<String>)request.getAttribute("categoryList");
String search = pageDTO.getSearch();
String category = pageDTO.getCategory();

// 페이지 이동해도 검색어, 카테고리 유지 => 페이징 주소 뒤에 붙임
String param = "";
if(search != null) {
	param += "&search=" + Html.encode(search);
}
if(category != null) {
	param += "&category=" + Html.encode(category);
}

// 제목 => 검색어 있으면 검색 결과, 카테고리 있으면 카테고리 이름
String title = "OUR CLASS";
if(search != null) {
	title = "'" + Html.escape(search) + "' 검색 결과";
} else if(category != null) {
	title = Html.escape(category);
}
%>
<main class="content wrap">
	<h2 class="page-title"><%=title %></h2>

	<%-- 카테고리 => 클릭하면 해당 카테고리 클래스만 조회 (검색어 유지) --%>
	<div class="category-list">
		<a href="classList.cbo<%=search != null ? "?search=" + Html.encode(search) : "" %>" class="<%=category == null ? "current" : "" %>">전체</a>
<%	if(categoryList != null) {
		for(String c : categoryList) { %>
		<a href="classList.cbo?category=<%=Html.encode(c) %><%=search != null ? "&search=" + Html.encode(search) : "" %>" class="<%=c.equals(category) ? "current" : "" %>"><%=Html.escape(c) %></a>
<%		}
	} %>
	</div>

<%	if(boardList == null || boardList.isEmpty()) { %>
	<p class="empty">조회된 클래스가 없습니다.</p>
<%	} else { %>
	<div class="card-list">
<%		for(int i=0; i<boardList.size(); i++){
			ClassBoardDTO boardDTO = boardList.get(i); %>
		<a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>" class="card">
			<%-- 대표 이미지 없으면 기본 이미지 --%>
			<img src="<%=Html.classImage(boardDTO.getClassFile()) %>" class="card-img" alt="">
			<div class="card-title"><%=Html.escape(boardDTO.getClassSubject()) %></div>
			<div class="card-price"><%=boardDTO.getClassPrice() %>원</div>
		</a>
<%		} %>
	</div>
<%	} %>

	<div class="paging">
<%
// 시작페이지 1페이지 prev 없음
// 시작페이지 11,21,31, prev 보임
if(pageDTO.getStartPage() > pageDTO.getPageBlock()){
	%>
	<a href = "classList.cbo?pageNum=<%=pageDTO.getStartPage()-pageDTO.getPageBlock() %><%=param %>">Prev</a>
	<%
}
%>
<%
for(int i = pageDTO.getStartPage(); i<=pageDTO.getEndPage(); i++){
	%>
	<a href = "classList.cbo?pageNum=<%=i %><%=param %>" class="<%=i == pageDTO.getCurrentPage() ? "current" : "" %>"><%=i %></a>
	<%
}
	%>
<%
//끝페이지번호  전체페이지수 비교 => 전체페이지수 크면 => Next보임
if(pageDTO.getEndPage() < pageDTO.getPageCount()){
	%>
	<a href="classList.cbo?pageNum=<%=pageDTO.getStartPage()+pageDTO.getPageBlock()%><%=param %>">Next</a>
	<%
}
%>
	</div>

<%
// 로그인한 회원정보 => 멤버 타입이 'host'인 경우만 클래스 등록 버튼 보이기
// (수정, 삭제는 클래스 상세페이지에서 등록한 호스트 본인만 가능)
MemberDTO memberDTO = (MemberDTO)request.getAttribute("memberDTO");
%>
<%if (memberDTO != null && "host".equals(memberDTO.getMemberType())) {%>
	<div class="btn-group">
		<input type="button" value="클래스 등록" class="btn btn-primary" onclick="location.href='classWrite.cbo'">
		<input type="button" value="나의 클래스 관리" class="btn" onclick="location.href='myClass.cbo'">
	</div>
<%}%>
</main>
<jsp:include page="/inc/bottom.jsp" />
</body>
</html>
