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
		<header class="header">
			<link rel="stylesheet" href="css/font-awesome-4.7.0/css/font-awesome.min.css">
		
			<a id="headerLogo" class="header-link" href="dashboard.jsp"><strong>Cyber</strong> Awareness Platform</a>	
			<ul>
			
			<%
				String globalLeaderboards = (String) ses.getAttribute("globalLeaderboards");
				String globalLeaderboardsLinkHTML = "";
				if( globalLeaderboards != null &&  globalLeaderboards.equals("true")) {
					globalLeaderboardsLinkHTML =  "<li style=\"font-size: large; vertical-align: middle;\"><a id=\"globalScoreboardLink\" href=\"factionboards.jsp\">Global Leaderboards &nbsp;<i class=\"fa fa-globe\" aria-hidden=\"true\"></i>&nbsp;<i class=\"fa fa-bar-chart\" aria-hidden=\"true\"></i></a>&nbsp;</li>";
				}
			%>
				<%= globalLeaderboardsLinkHTML %>
			
			
				<li style="vertical-align: middle;"><a id="leaderboardsLink" href="factionboards.jsp">Leaderboards &nbsp;<i class="fa fa-bar-chart" aria-hidden="true"></i></a></li>
				<li>&nbsp;&nbsp;&nbsp;</li>
				<li>
					<div class="dropdown">
						<span><img src="css/images/notification-arrow.png" height="22px" width="22px" alt="Profile"/></span>
						<div class="dropdown-content">
							<a href="Logout" id="logout">Logout</a>
						</div>
					</div>
				</li>
			</ul>
			<script>
				$("#logout").click(function() {
					window.location.href = "Logout";
				});
			</script>
		</header>
		<section class="banner">
			<article class="user-profile">
				<h2>Welcome, <span class="txt-accent-purple">
				<%= String.valueOf(ses.getAttribute("userName")).split("@", 2)[0].substring(0, 1).toUpperCase() + String.valueOf(ses.getAttribute("userName")).split("@", 2)[0].substring(1) %></span></h2>
				
				<article class="banner-rank">
					<p id="challengesRemaining"></p>
					<p id="currentRank"></p>
				</article>
				<input id="next-challenge" type="submit" value="Take Me To My Next Challenge" /> 
			</article>
			
			<article class="banner-achievements">
				<div>
					<div class="achievement-stat">
						<img class="status-icon purple-tone" src="css/images/flag--filled.svg" alt="Profile"/> 
						<h2 id='challengesCompleted'>0</h2>
					</div>
					<p>Challenges Completed</p>
				</div>
				<div>
					<div class="achievement-stat">
						<img class="status-icon gold-star" src="css/images/star.svg" alt="Profile"/>
						<h2 id="rewards">0</h2>
					</div>
					<p>Rewards</p>
				</div>
				<div>
					<h2 id="scoreTotal">0</h2>
					<p>Total Number of points</p>
				</div>								
			</article>
			

			<script>
			console.log("Script Running");
			var moduleJsonList;
			var scoreboardList;
			const path = window.location.pathname.toString()
			
			function callApis(){
				console.log("Calling APIs...");
				//Call Module List Api
				console.log("Caling Module List JSON API");
				<% //TODO - Point this at an Actual API %>
				var ajaxCall = path.includes("levels") ? $.ajax({
					type: "POST",
					url: "../moduleFeed",
					dataType: 'json',
					async: false,
					success: function(o){
						console.log("Success, Storing data in moduleJsonList");
						moduleJsonList = o;
					}
				}) : $.ajax({
					type: "POST",
					url: "moduleFeed",
					dataType: 'json',
					async: false,
					success: function(o){
						console.log("Success, Storing data in moduleJsonList");
						moduleJsonList = o;
					}
				});
				if(ajaxCall.status != 200) {
					console.error("Failed to call getJsonModules API Successfuly");
				}
				
				//Call User Stat Api
				console.log("Caling User Stat API");
				var ajaxCall = path.includes("levels") ? $.ajax({
					type: "POST",
					url: "../userStats",
					dataType: 'json',
					async: false,
					success: function(o) {
						console.log("Success, Storing data in scoreboard");
						scoreboardList = o;
					}
				}) : $.ajax({
					type: "POST",
					url: "userStats",
					dataType: 'json',
					async: false,
					success: function(o){
						console.log("Success, Storing data in moduleJsonList");
						scoreboardList = o;
					}
				});
				if(ajaxCall.status != 200) {
					console.error("Failed to call scoreboard Successfuly");
				}
			}
				function updateUserScore(){
						//work out amount completed
						var challengesCompleted =0;
						var challengesRemaining =0;
						for(i=0;i<moduleJsonList.length;i++){
							if(moduleJsonList[i].completedStatus=="true"){
								challengesCompleted++;
							} else {
								challengesRemaining++;
							}
						}
						$("#challengesCompleted").html(""+challengesCompleted);
						
						//work out total score
						var scoreTotal=0;
						var rewards=0;
						var myUserId = "<%= ses.getAttribute("userName") %>";
						var currentRank = "Beginner";
						if(scoreboardList!=null) {
							for(i=0; i<scoreboardList.length; i++) {
								if(scoreboardList[i].username == myUserId ) {
									console.log("Found user: " + myUserId);
									scoreTotal=scoreboardList[i].score;
									rewards= rewards+scoreboardList[i].goldMedalCount;
									rewards= rewards+scoreboardList[i].silverMedalCount;
									rewards= rewards+scoreboardList[i].bronzeMedalCount;
									currentRank = getGetOrdinal(scoreboardList[i].rank);
									break;	
								}
							}
						} else {
							scoreTotal = 0;
							rewards = 0;
							currentRank = "Beginner";
						}
						console.log("score total:" + scoreTotal);
						$("#scoreTotal").html(scoreTotal);
						$("#rewards").html("" + rewards);
						$("#challengesRemaining").html("Remaining Challenges: "+challengesRemaining);
						$("#currentRank").html("Individual Performance: "+currentRank);

						//when a user clicks on the next challenge button
					$( "#next-challenge" ).click(function() {
						//let's set this to the very first uncompleted challenge we encounter in our loop of all challenges
						for(i=0;i<moduleJsonList.length;i++) {
							console.log(moduleJsonList[i].completedStatus);
							if(moduleJsonList[i].completedStatus=="false") {
								var lessonURL=encodeURIComponent(moduleJsonList[i].moduleDirectory) + ".jsp";
								window.location.href = lessonURL;
							}
						}
					});
				}

					function getGetOrdinal(n) {
						   var s=["th","st","nd","rd"],
							   v=n%100;
						   return n+(s[(v-20)%10]||s[v]||s[0]);
					}
					


					callApis();
					updateUserScore();
 			</script>
		</section>
	<%
	}
}
%>