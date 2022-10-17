<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%
 
if (request.getSession() == null)
{
	response.sendRedirect("index.jsp");
}
else
{
	
	HttpSession ses = request.getSession();
	String globalLeaderboards = (String) ses.getAttribute("globalLeaderboards");

	if(!SessionValidator.validate(ses))
	{
		response.sendRedirect("index.jsp");
	} else if ( globalLeaderboards == null ||  globalLeaderboards.equals("false")) {
		response.sendRedirect("index.jsp");
	}
	else
	{
%>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>CAP - Global Leaderboards</title>
			</head>
			<body onload="loadLeaderBoardsData()">
				<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
				<script type="text/javascript"	src="https://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
				<script type="text/javascript" src="js/globalLeaderboards.js"></script>	
				<jsp:include page="header.jsp" /> <% //Header Entry %>
				<section class="banner" style="height: 300px;">
					<article class="blur-img" style="height: 300px;"></article>
				</section>
				<section id="chartListSection" style="min-height: 600px;">
					<div style="text-align: center">
						<br>
						<h1>Global Leaderboards</h1>
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
				<footer></footer>
			</body>
		</html>		
	<%
	}
}
%>
