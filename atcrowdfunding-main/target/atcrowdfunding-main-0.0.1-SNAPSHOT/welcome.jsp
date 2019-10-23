<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%--  
	在访问welcome.jsp时，转发请求到  "/index"映射上。
	request.getRequestDispatcher("/index").forward(request,response); --%>
	
	
	<%--
		绝对路径：固定不变
			D:\RepMaven\org\springframework\spring-tx\4.3.8.RELEASE\spring-tx-4.3.xsd
			http://192.168.137.3:8080/atcrowdfunding-main/index
			<jsp:forward page="/index"></jsp:forward>
			<link rel="stylesheet" href="/static/bootstrap/css/bootstrap.min.css">
			<link rel="stylesheet" href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css">
		
		相对路径：可变路径。根据【访问路径】进行资源查找(注意：不是资源所在的路径)。
				<jsp:forward page="../../index"></jsp:forward>
				<jsp:forward page="index"></jsp:forward>
				<link rel="stylesheet" href="static/bootstrap/css/bootstrap.min.css">
				
		
		前台路径：浏览器端发起的请求路径。
				<link rel="stylesheet" href="/static/bootstrap/css/bootstrap.min.css">
		
				前台路径以斜杠开头，表示从 ROOT目录下查找资源。
				
				如果希望从 当前项目  上下文路径（/atcrowdfunding-main/） 目录下查找资源，手动增加上下文的根。
				<link rel="stylesheet" href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css">
		
		后台路径：服务器内部资源查找的路径。
				<jsp:forward page="/index"></jsp:forward>
				@RequestMapping("/index")
				后台路径以斜杠开头，表示从 当前项目  上下文路径（/atcrowdfunding-main/） 目录下查找资源。
	 --%>
	
	
	<jsp:forward page="/index"></jsp:forward> 
	<%-- <jsp:forward page="index"></jsp:forward> --%>
</body>
</html>