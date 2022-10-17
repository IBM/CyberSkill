<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>


<%-- Get a reference to the logger for this class --%>
<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>

<%
 
if (request.getSession() == null)
{
	StringBuffer requestURL = request.getRequestURL();
	if (request.getQueryString() != null) {
	    requestURL.append("?").append(request.getQueryString());
	}
	String completeURL = requestURL.toString();
	logger.error("Attempt to access a page without a session:" + completeURL+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
	response.sendRedirect("index.jsp");

}
else
{
	StringBuffer requestURL = request.getRequestURL();
	if (request.getQueryString() != null) {
	    requestURL.append("?").append(request.getQueryString());
	}
	String completeURL = requestURL.toString();
	
	HttpSession ses = request.getSession();
	if(!SessionValidator.validate(ses))
	{
		logger.error("Attempt to access a page without an invalid session:" + completeURL+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
		response.sendRedirect("index.jsp");
	} 
	else
	{
%>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>CAP Project - Leaderboards</title>
				<link href="css/global.css" rel="stylesheet" type="text/css" media="screen" />
			</head>
			<body onload="loadLeaderBoardsData()">
				<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
				<script type="text/javascript"	src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
				<script type="text/javascript" src="js/leaderboards.js"></script>	
				
				<jsp:include page="header.jsp" /> <% //Header Entry %>
				<section class="banner" style="height: 300px;">
					<article class="blur-img" style="height: 300px; margin-top: -3px;"></article>
				</section>
				<section id="chartListSection" style="min-height: 600px;">
					<div style="text-align: center">
						<br>
						<h1>Leaderboards <a href="factionboards.jsp">faction board</a></h1>
					</div>
					<br>
					<br>
					<div id="leaderboardTopGraphDiv">
					
					</div>
					<br>
					<br>
					<div id="leaderboardPlayerGraphDiv">
					
					</div>
				</section>
				<footer>
				</footer>
			</body>
		</html>		
	<%
	}
}
%>