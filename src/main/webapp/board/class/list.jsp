<%@page import="java.net.URLEncoder"%>
<%@page import="com.itwillbs.domain.MemberDTO"%>
<%@page import="com.itwillbs.domain.PageDTO"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!DOCTYPE html>
<html>
<head>
  <title>Shop</title> 
  <style type="text/css">
  .navbar{
    height: 60px;
    padding-left: 30px;
    padding-right: 30px;

}

.hero-header{
    height: 450px;
    background-image: url("images/wine.jpg");
    background-repeat: no-repeat;
    background-size: cover;
    background-position: center center;
    }
      
.navbar #logo{
    line-height: 60px;
}

.navbar #menu{
    float: right;
    list-style-type: none;
    padding: 0;
    margin: 0;
}

.navbar #menu li{
    float: left;
    margin-left: 50px;
    line-height: 60px;
}

.navbar #menu li a{
    color: #545454;
    font-size: 13px;
    text-decoration: none;
}
.product-list{
    width: 735px;
    margin-left: auto;
    margin-right: auto;
}
.products h3{
    font-size: 24px;
    color: #545454;
    margin-top:60px;
    margin-bottom: 60px;
    text-align: center;
}

.product{
    display: block;
    width: 225px;
    text-align: center;
    text-decoration:none;
    color: black;
    float:left;
    margin-left: 10px;
    margin-right: 10px;
    margin-bottom: 30px;
}

.product-name{
    margin-top: 20px;
    margin-bottom: 4px;
}

.clearfix{
    clear: both;
}
.footer{
    text-align: center;
    margin-top: 40px;
    margin-bottom: 40px;
}

.footer a{
    margin-left: 10px;
    margin-right: 10px;
    text-decoration:none;
}

.class-search{
    text-align: center;
    margin-bottom: 20px;
}

.class-search input[type="search"]{
    width: 300px;
    padding: 5px;
}

.category-list{
    text-align: center;
    margin-bottom: 30px;
}

.category-list a{
    display: inline-block;
    padding: 6px 14px;
    margin: 0 4px;
    color: #545454;
    font-size: 13px;
    text-decoration: none;
    border-radius: 15px;
}

.category-list a.current{
    background: #ededed;
}

.empty{
    text-align: center;
    color: #999;
}
  </style>
  <meta charset="utf-8">
  <link rel="stylesheet" href="shopcss.css">
  <link href="https://fonts.googleapis.com/earlyaccess/notosanskr.css" rel="stylesheet">
</head>
<body>

    <div class="navbar">
        <a href="#" id="logo">
            <img src="images/logo-198x66.png" height="60">
        </a>

        <ul id="menu">
            <li><a href="#"><b>Contact</b></a></li>
            <li><a href="#"><b>Login</b></a></li>
        </ul>
    </div>

    <div class="hero-header"></div>

    <div class="products">
<%!
// 검색어, 카테고리 => HTML 태그로 실행되지 않게 변환
String escape(String str) {
	if(str == null) {
		return "";
	}
	return str.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
			.replace("\"", "&quot;").replace("'", "&#39;");
}

// 주소에 붙일 값 => 한글, 특수문자 인코딩
String encode(String str) {
	try {
		return URLEncoder.encode(str, "UTF-8");
	} catch (Exception e) {
		return "";
	}
}
%>
<%
List<ClassBoardDTO> boardList =(List<ClassBoardDTO>)request.getAttribute("boardList");
PageDTO pageDTO = (PageDTO)request.getAttribute("pageDTO");
List<String> categoryList = (List<String>)request.getAttribute("categoryList");
String memberId = (String)session.getAttribute("memberId");
String search = pageDTO.getSearch();
String category = pageDTO.getCategory();

// 페이지 이동해도 검색어, 카테고리 유지 => 페이징 주소 뒤에 붙임
String param = "";
if(search != null) {
	param += "&search=" + encode(search);
}
if(category != null) {
	param += "&category=" + encode(category);
}

// 제목 => 검색어 있으면 검색 결과, 카테고리 있으면 카테고리 이름
String title = "클래스 목록";
if(search != null) {
	title = "'" + escape(search) + "' 검색 결과";
} else if(category != null) {
	title = escape(category);
}
%>
        <h3><%=title %></h3>

        <%-- 검색창 => 제목에 키워드가 포함된 클래스 조회 (선택한 카테고리 유지) --%>
        <form action="classList.cbo" method="get" class="class-search">
<%	if(category != null) { %>
        	<input type="hidden" name="category" value="<%=escape(category) %>">
<%	} %>
        	<input type="search" name="search" value="<%=escape(search) %>" placeholder="지금 생각나는 취미를 검색하세요.">
        	<input type="submit" value="검색" class="btn">
        </form>

        <%-- 카테고리 => 클릭하면 해당 카테고리 클래스만 조회 --%>
        <div class="category-list">
        	<a href="classList.cbo" class="<%=category == null ? "current" : "" %>">전체</a>
<%	if(categoryList != null) {
		for(String c : categoryList) { %>
        	<a href="classList.cbo?category=<%=encode(c) %>" class="<%=c.equals(category) ? "current" : "" %>"><%=escape(c) %></a>
<%		}
	} %>
        </div>

        <div class="product-list">

<%	if(boardList == null || boardList.isEmpty()) { %>
        <p class="empty">조회된 클래스가 없습니다.</p>
<%	} %>
        <%
for(int i=0; boardList != null && i<boardList.size(); i++){
	ClassBoardDTO boardDTO = boardList.get(i);
	%>
             <a href="classContent.cbo?classNum=<%=boardDTO.getClassNum() %>" class="product">
                <%-- 대표 이미지 없으면 기본 이미지 --%>
                <img src="<%=boardDTO.getClassFile() != null ? "upload/" + boardDTO.getClassFile().replace("\"", "&quot;") : "images/cat-space.gif" %>" width="225" height="225px" style="object-fit: cover;">
                <div class="product-name">
                	제목 : <%=escape(boardDTO.getClassSubject()) %>
                </div>
                <div class="product-price">
                	금액 : <%=boardDTO.getClassPrice() %>
                </div>
            </a>        
          
<%
}
%>

<%
// 로그인한 회원정보 => 멤버 타입이 'host'인 경우만 클래스 등록 버튼 보이기
// (수정, 삭제는 클래스 상세페이지에서 등록한 호스트 본인만 가능)
MemberDTO memberDTO = (MemberDTO)request.getAttribute("memberDTO");
%>
<%if (memberDTO != null && "host".equals(memberDTO.getMemberType())) {%>
   <input type="button" value="클래스 등록" class="btn"
       					onclick="location.href='classWrite.cbo'">
   <input type="button" value="나의 클래스 관리" class="btn"
       					onclick="location.href='myClass.cbo'">
<%}%>

 <div id="page_control">
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
	<a href = "classList.cbo?pageNum=<%=i %><%=param %>"><%=i %></a>
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
            <div class="clearfix"></div>
        </div>

        <div class="footer">
            <a href="http://faceboo.com">
                <img src="https://bakey-api.codeit.kr/files/629/images/facebook.png" height="20">
            </a>
            <a href="http://faceboo.com">
                <img src="https://bakey-api.codeit.kr/files/629/images/instagram.png" height="20">
            </a>
            <a href="http://faceboo.com">
                <img src="https://bakey-api.codeit.kr/files/629/images/twitter.png" height="20">
            </a>
        </div>
    </div>
</body>
</html>