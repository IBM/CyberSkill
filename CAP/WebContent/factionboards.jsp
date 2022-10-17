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
			<body >
				<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.5.1/chart.min.js" integrity="sha512-Wt1bJGtlnMtGP0dqNFH1xlkLBNpEodaiQ8ZN5JLA5wpc1sUlk/O5uuOMNgvzddzkpvZ9GLyYNa8w2s7rqiTk5Q==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
				<script	src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>

				<jsp:include page="dashboard_header.jsp" /> <% //Header Entry %>
				<script>
					window.onload = (e) => {
						var myUserId = "<%= (String)ses.getAttribute("userName") %>";
						loadFactionBoardData(myUserId);
					}
				</script>


				<section class="d-flex graph-contain">
					<section id="playerTeamStats" class="player-team-stats">
						<h3>Your Faction</h3>

						<h4 class="stat-header">Faction Name</h4>
						<div id="teamName"></div>
						<h4 class="stat-header">Faction Score</h4>
						<div id="teamScore"></div>
						<h4 class="stat-header">Faction Members</h4>
						<div id="teamMembers"></div>
					</section>

					<section id="chartListSection" class="player-team-chart" style="min-height: 600px;">
						<div style="text-align: center">
							<br>
							<h1 onClick="history.go(0);">Faction Board</h1>
						</div>
						<br>
						<br>
						<canvas id="factionboardGraphDiv" width="400" height="170">
						
						</canvas>
						
					</section>
				</section>
				<footer>
				</footer>
			</body>
		</html>		
	<%
	}
}
%>
<script type="text/javascript" src="js/factionboard.js"></script>