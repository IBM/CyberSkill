<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%
HttpSession ses = request.getSession(true);

%>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Honeyn3t</title>
<link href="css/styles.css" rel="stylesheet" type="text/css">
</head>
<body>
<div class="container">
	<div class="logo">
	</div>
	
	<div class="submitLevel">
		<jsp:include page="/includes/fileList.jsp"/>
	</div>
</body>
</html>