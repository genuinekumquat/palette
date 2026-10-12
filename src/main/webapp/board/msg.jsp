<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>board/msg.jsp</title>
</head>
<body>
<%
// 컨트롤러에서 담아온 알림 메시지, 이동할 주소 (없으면 뒤로이동)
String msg = (String)request.getAttribute("msg");
String url = (String)request.getAttribute("url");
%>
	<script type="text/javascript">
	alert("<%=msg %>");
<% if(url != null) { %>
	location.href = "<%=url %>";
<% } else { %>
	history.back();
<% } %>
	</script>
</body>
</html>
