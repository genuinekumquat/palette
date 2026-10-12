<%@page import="com.itwillbs.util.Html"%>
<%@page import="com.itwillbs.domain.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 | palette</title>
<jsp:include page="/inc/head.jsp" />
</head>
<body>
<jsp:include page="/inc/top.jsp" />
<%
// 로그인한 회원정보
MemberDTO memberDTO = (MemberDTO)request.getAttribute("memberDTO");
boolean isHost = "host".equals(memberDTO.getMemberType());
String nickname = memberDTO.getMemberNickname() != null ? memberDTO.getMemberNickname() : memberDTO.getMemberId();
%>
<main class="content wrap">
	<div class="mypage">
		<div class="profile">
<%	if(memberDTO.getMemberFile() != null) { %>
			<img src="upload/<%=Html.encodePath(memberDTO.getMemberFile()) %>" class="profile-img" alt="">
<%	} else { %>
			<%-- 프로필 사진 없으면 닉네임 첫 글자 --%>
			<div class="profile-initial"><%=Html.escape(nickname.substring(0, 1)) %></div>
<%	} %>
			<div>
				<div class="profile-label">닉네임</div>
				<div class="profile-name"><%=Html.escape(nickname) %></div>
				<span class="profile-type"><%=isHost ? "호스트" : "게스트" %></span>
			</div>
		</div>

		<input type="button" value="개인정보수정" class="btn" onclick="ready()">
<%
// 멤버 타입이 'host'인 경우 => 클래스 관리, 예약 관리
// 멤버 타입이 'guest'인 경우 => 예약 내역, 해당 아이디로 작성된 리뷰
if(isHost) {
%>
		<input type="button" value="클래스관리" class="btn" onclick="location.href='myClass.cbo'">
		<input type="button" value="예약관리" class="btn" onclick="ready()">
<%
} else {
%>
		<input type="button" value="예약내역" class="btn" onclick="ready()">
		<input type="button" value="나의리뷰" class="btn" onclick="location.href='reviewList.rbo'">
<%
}
%>
		<input type="button" value="계정삭제" class="btn btn-danger" onclick="ready()">
	</div>
</main>
<jsp:include page="/inc/bottom.jsp" />

<script type="text/javascript">
// 아직 구현되지 않은 기능 (개인정보수정, 예약, 계정삭제)
function ready() {
	alert("준비 중인 기능입니다.");
}
</script>
</body>
</html>
