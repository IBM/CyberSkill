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
				<title>Cyber Awareness Platform - Dash Board</title>
					<meta name="viewport" content="width=device-width; initial-scale=1.0;">
					<link href="css/global.css" rel="stylesheet" type="text/css" media="screen" />
					<link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Sans&display=swap" rel="stylesheet"/>
					<link href="css/dashboard.css" rel="stylesheet" type="text/css" media="screen"/>		
			</head>
			
			<body>
				<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
				<jsp:include page="dashboard_header.jsp" /> <% //Header Entry %>
				
				<section class="vulnerabilities" >
					<h2 class="bold">Challenge Board</h2>
					<div class="large-vul-contain"id="moduleList"></div>
				</section>
				<footer></footer>
				<script>
					console.log("Script Running");
					var moduleJsonList;
					var scoreboardList;
					
					function callApis(){
						console.log("Calling APIs...");
						//Call Module List Api
						console.log("Caling Module List JSON API");
						<% //TODO - Point this at an Actual API %>
						var ajaxCall = $.ajax({
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
						var ajaxCall = $.ajax({
							type: "POST",
							url: "userStats",
							dataType: 'json',
							async: false,
							success: function(o) {
								console.log("Success, Storing data in scoreboard");
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
							console.log(moduleJsonList[i].completedStatus);
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
						console.log(scoreboardList);
						if(scoreboardList!=null) {
							for(i=0; i<scoreboardList.length; i++) {
								if(scoreboardList[i].username == myUserId ) {
									console.log("Found user: " + myUserId);
									scoreTotal=scoreboardList[i].score;
									console.log("loop value found:"+scoreboardList[i].score);
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
					}
					
					function makeModuleList(){
						//create entry
						console.log("Adding Levels to Module List");
						for(i=0;i<moduleJsonList.length;i++)
						{
							var levelEntry = "<div class='large-vul-div' onclick=\"window.open('levels/"+ encodeURIComponent(moduleJsonList[i].moduleDirectory) + ".jsp', '_blank');\"><img class='logos' src='css/images/sans25/svg/" + moduleJsonList[i].moduleCategory + ".svg' alt='" + moduleJsonList[i].moduleName + "' /><h3>" + moduleJsonList[i].moduleName + "</h3>	<h1>" + moduleJsonList[i].moduleScore + "</h1>";
							if(moduleJsonList[i].completedStatus == "true"){
								if(moduleJsonList[i].gold == 1){
									console.log("Level Completed with Gold Medal");
									levelEntry += "<img src='css/images/star.svg' alt='star' class='status-icon gold-star' title='You completed this challenge first. Well done.' />";		
								} else if (moduleJsonList[i].silver == 1) {
									console.log("Level Completed with Silver Medal");
									levelEntry += "<img src='css/images/star.svg' alt='star' class='status-icon silver-star' title='You completed this challenge second. Well done.'/>";	
								} else if (moduleJsonList[i].bronze == 1) {
									console.log("Level Completed with Bronze Medal");
									levelEntry += "<img src='css/images/star.svg' alt='star' class='status-icon bronze-star' title='You completed this challenge third. Well done.' />";	
								} else {
									console.log("Level Completed without Medal");
									levelEntry += "<img alt='tick' src='css/images/check.svg' class='status-icon complete' title='You have completed this challenge.'>";
								}
							} else {
								console.log("Level Uncompleted");
								levelEntry += "<img alt='tick' src='css/images/unlocked.svg' class='status-icon incomplete' title='You have yet to complete this level'>";
							}
							levelEntry += "<input type='submit' value='Attempt Challenge' style='cursor: pointer;'/></div>";
							$("#moduleList").append(levelEntry);
							console.log("Level Added");
						}
						console.log("Adding Footer");
						var footer ="<p class='foot-text'>More Challenges Coming Soon...</p>";
					}
					
					function getGetOrdinal(n) {
						   var s=["th","st","nd","rd"],
							   v=n%100;
						   return n+(s[(v-20)%10]||s[v]||s[0]);
					}
					
					//when a user clicks on the next challenge button
					$( "#next-challenge" ).click(function() {
						//let's set this to the very first incomplete challenge we encounter in our loop of all challenges
						for(i=0;i<moduleJsonList.length;i++) {
							console.log(moduleJsonList[i].completedStatus);
							if(moduleJsonList[i].completedStatus=="false") {
								var lessonURL="levels/" + encodeURIComponent(moduleJsonList[i].moduleDirectory) + ".jsp";
								window.location.href = lessonURL;
							}
						}
					});
					
					//Run Scripts to Populate Index Page
					callApis();
					updateUserScore();
					makeModuleList();
				</script>
			</body>
		</html>		
	<%
	}
}
%>
