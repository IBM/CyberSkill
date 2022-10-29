<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>

<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>

<% 

HttpSession ses = request.getSession(true);
if(SessionValidator.validate(ses))
{
	logger.debug("Session has been validated");
	StringBuffer accessURL = request.getRequestURL();
	String accessPage = accessURL.substring(accessURL.lastIndexOf("/")+1, accessURL.lastIndexOf(".jsp"));
	logger.debug("Validating page accessed: " + accessPage + " is open for play");
	utils.Api api = new utils.Api();
	boolean levelOpen = api.validateLevelIsOpen(accessPage);
			
	if(levelOpen)
	{
		logger.debug("level " + accessPage + " is open for play");
	}
	else
	{
		logger.debug("level " + accessPage + " is NOT open for play");
	}

%>
	



	<!DOCTYPE html>
	<html>
	<head>
	<title>W3.CSS Template</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/beta/w3.css">
	</head>
	<body class="w3-content" style="max-width:1300px">
	
	<!-- First Grid: Logo & About -->
	<div class="w3-row">
	  <div class="w3-half w3-black w3-container w3-center" style="height:700px">
	    <div class="w3-padding-64">
	      <h1>Challenge Assistance</h1>
	    </div>
	    <div class="w3-padding-64">
	      <a href="#" class="w3-button w3-black w3-block w3-hover-blue-grey w3-padding-16">About</a>
	      <a href="#" class="w3-button w3-black w3-block w3-hover-blue-grey w3-padding-16">Clue</a>
	    </div>
	  </div>
	  <div class="w3-half w3-blue-grey w3-container" style="height:700px">
	    <div class="w3-padding-64 w3-center">
	      <h1>Challenge</h1>
	      <img src="css/images/7.svg" class="w3-margin w3-circle" alt="Person" style="width:50%">
	      <div class="w3-left-align w3-padding-large">
	        <p>Lorem ipusm sed vitae justo condimentum, porta lectus vitae, ultricies congue gravida diam non fringilla.</p>
	        <p>Lorem ipusm sed vitae justo condimentum, porta lectus vitae, ultricies congue gravida diam non fringilla.</p>
	      </div>
	    </div>
	  </div>
	</div>
	
	
	<!-- Footer -->
	<footer class="w3-container w3-grey w3-padding-16">
	  <p>Powered by OpenSource</p>
	</footer>
	
	</body>
	</html>
<%
}
else
{
	StringBuffer requestURL = request.getRequestURL();
	if (request.getQueryString() != null) 
	{
	    requestURL.append("?").append(request.getQueryString());
	}
	String completeURL = requestURL.toString();
	logger.error("Attempt to access a page without a session:" + completeURL+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
	response.sendRedirect("dashboard.jsp");
}
%>