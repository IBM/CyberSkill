<script>

   $("#headerLogo").attr("href", "../dashboard.jsp");
   $("#logout").attr("href", "../Logout");
   $("#globalScoreboardLink").attr("href", "../globalLeaderboards.jsp");
   $("#leaderboardsLink").attr("href", "../factionboards.jsp");

</script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
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
		
		<section class="lessons">
			<article class="lessons-list" id="moduleList">
				<!-- Dynamic content will go here -->				
			</article>
			
			<section class="lesson-contain d-flex">
			<article class="ranking">
				<h3>Points / Ranking</h3>

				<div class="ranking-stars"> 
				<h4>Stars Held</h4>
					<div>
					<p class="star-stat">
						<span><img class="status-icon gold-star" src="css/images/star.svg" alt="G"/></span>
						<span id="goldBadge">0 </span>
						<span>Gold</span>
					</p>
					<p class="star-stat">
						<span><img class="status-icon silver-star" src="css/images/star.svg"/></span>
						<span id="silverBadge">0</span>
						<span>Silver</span>
					</p>
					<p class="star-stat">
						<span><img class="status-icon bronze-star" src="css/images/star.svg"/></span>
						<span id="bronzeBadge">0 </span>
						<span>Bronze</span>
					</p>
					</div>
				</div>

				<div>
				<h4>Overall Points</h4>
				<h2><span id="ranking-points-overall">0</span></h2>
				</div>

				<div>
				<h4>Stars Held</h4>
				<h2><span id="ranking-starts-held">0</span></h2>
				</div>

				<div>
				<h4>Rank</h4>
				<h2><span id="ranking-rank">Beginner</span></h2>
				</div>
				
			</article>
			<br style="clear: left;" />
			<article class="lesson">
				<div id="contentDiv" style="text-align: left;" >
				<% //Elements closed by LevelBottom.jsp %>
	<%
	}
}
%>