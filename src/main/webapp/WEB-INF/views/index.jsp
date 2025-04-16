<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
	<jsp:include page="${contextPath }header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
	
			<h1>index.jsp</h1>
		</div>
	</div>
	<jsp:include page="${contextPath }footer.jsp"></jsp:include>
</body>
</html>