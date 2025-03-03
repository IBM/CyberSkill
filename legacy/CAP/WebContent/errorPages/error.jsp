<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII" isErrorPage="true"%>
<%@ page import="utils.ErrrorCodes"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>


<%-- Get a reference to the logger for this class --%>
<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "https://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Error Page</title>
</head>
<body>

<%
ErrrorCodes EC = new ErrrorCodes();
String temp = EC.getNewSQLErrorCode();
//
String originalUri = (String)request.getAttribute(RequestDispatcher.FORWARD_REQUEST_URI);


logger.error("JSP error code: "+response.getStatus()+ " for page: " + originalUri+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
%>

<%=temp %>

</body>
</html>