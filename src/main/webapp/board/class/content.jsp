<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.MemberDTO"%>
<%@page import="com.itwillbs.domain.ReviewBoardDTO"%>
<%@page import="com.itwillbs.domain.ClassBoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
ClassBoardDTO boardDTO = (ClassBoardDTO)request.getAttribute("boardDTO");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=Html.escape(boardDTO.getClassSubject()) %> | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<main class="content wrap">

	<section class="class-detail">
		<img src="<%=Html.classImage(boardDTO.getClassFile()) %>" class="class-detail-img" alt="">
		<div class="class-detail-info">
			<h2><%=Html.escape(boardDTO.getClassSubject()) %></h2>
			<p><%=Html.escape(boardDTO.getClassLocation()) %></p>
			<p><%=Html.escape(boardDTO.getClassCategory()) %></p>
			<p class="price"><%=boardDTO.getClassPrice() %> 원</p>
			<input type="button" value="예약하기" class="btn btn-primary"
       					onclick="location.href='classWrite.cbo'">
		</div>
	</section>

	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">클래스 소개</li>
		<li class="tab-link" data-tab="tab-2">클래스 정보</li>
		<li class="tab-link" data-tab="tab-3">클래스 리뷰</li>
	</ul>

	<div id="tab-1" class="tab-content current">
		<p><%=Html.escapeLines(boardDTO.getClassContent()) %></p>
	</div>

	<div id="tab-2" class="tab-content">
		<table class="info-table">
			<tr><th>호스트</th><td><%=Html.escape(boardDTO.getHostId()) %></td></tr>
			<tr><th>지역</th><td><%=Html.escape(boardDTO.getClassLocation()) %></td></tr>
			<tr><th>카테고리</th><td><%=Html.escape(boardDTO.getClassCategory()) %></td></tr>
			<tr><th>가격</th><td><%=boardDTO.getClassPrice() %> 원</td></tr>
			<tr><th>등록일</th><td><%=Html.date(boardDTO.getClassIssueDate()) %></td></tr>
		</table>
	</div>

	<div id="tab-3" class="tab-content">
		<input type="button" value="리뷰 작성" class="btn"
       					onclick="location.href='reviewWrite.rbo?classNum=<%=boardDTO.getClassNum() %>'">
<%
// 해당 클래스 리뷰 리스트 (최신 작성순)
List<ReviewBoardDTO> reviewList = (List<ReviewBoardDTO>)request.getAttribute("reviewList");
if(reviewList == null || reviewList.isEmpty()) {
%>
		<p class="empty">아직 작성된 리뷰가 없습니다.</p>
<%
} else {
	for(ReviewBoardDTO reviewDTO : reviewList) {
%>
		<div class="review">
			<div class="review-info">
				<b><%=Html.escape(reviewDTO.getReviewId()) %></b><%=Html.date(reviewDTO.getReviewIssueDate()) %>
			</div>
<%		if(reviewDTO.getReviewFile() != null) { %>
			<img src="upload/<%=Html.encodePath(reviewDTO.getReviewFile()) %>" class="review-img" alt="">
<%		} %>
			<p><%=Html.escapeLines(reviewDTO.getReviewContent()) %></p>
		</div>
<%
	}
}
%>
	</div>

	<div class="btn-group">
<%
// 로그인한 회원정보 => 클래스를 등록한 호스트 본인만 수정, 삭제 버튼 보이기
MemberDTO memberDTO = (MemberDTO)request.getAttribute("memberDTO");
if (memberDTO != null && "host".equals(memberDTO.getMemberType())
		&& memberDTO.getMemberId().equals(boardDTO.getHostId())) {%>
		<input type="button" value="클래스 수정" class="btn"
       					onclick="location.href='classUpdate.cbo?classNum=<%=boardDTO.getClassNum() %>'">
		<input type="button" value="클래스 삭제" class="btn btn-danger"
       					onclick="if(confirm('클래스를 삭제하시겠습니까?')) location.href='classDelete.cbo?classNum=<%=boardDTO.getClassNum() %>'">
<%}%>
		<input type="button" value="클래스 목록으로 돌아가기" class="btn" onclick="location.href='classList.cbo'">
	</div>

</main>
<jsp:include page="/inc/bottom.jsp" />

<script type="text/javascript" src="script/jquery-3.7.0.js"></script>
<script type="text/javascript">
$(document).ready(function(){

	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	})

	// 리뷰 작성 후 이동하면 (tab=review) 리뷰탭 열어주기
	<% if("review".equals(request.getParameter("tab"))) { %>
	$('ul.tabs li[data-tab="tab-3"]').click();
	<% } %>
})
</script>
</body>
</html>
