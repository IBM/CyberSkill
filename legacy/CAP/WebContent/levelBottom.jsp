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
		//HTML elements Started by levelFront.jsp
	%>
				</div>
			</article>
			</section>
		</section>
		<footer></footer>
		<script>
		var moduleJsonList;
		var scoreboardList;
		
		function refreshScore() {
			
			var myUserId = "<%= (String)ses.getAttribute("userName") %>";
			
			
			$.ajax({
				url: "../userStats",
				type: "POST",
				dataType: 'json'
			})
			.done(function (data) {
				
				var scoresData;
				try {
					
					scoresData = data;
					
					processScores(scoresData);
				} catch (e) {
					// Could not parse scores (no scoreboard data)
				//	$("#ranking-points-overall").text("0");
					//$("#ranking-points-average").text("0");
					//$("#ranking-starts-held").text("0");
					//$("#ranking-rank").text("0");
				}
			});
		
			function processScores(scoresData) {
				
				var totalScores = 0;
				var scoreCount = 0;
				var myScore = 0;
				var myRank = 0;
				var myGoldMedalCount = 0;
				var mySilverMedalCount = 0;
				var myBronzeMedalCount = 0;
			
				scoresData.forEach(function (el) {
					totalScores += el.score;
					scoreCount++;
				
					if (el.username === myUserId) {
						
						myScore = el.score;
						myRank = el.rank;
						myGoldMedalCount = el.goldMedalCount;
						mySilverMedalCount = el.silverMedalCount;
						myBronzeMedalCount = el.bronzeMedalCount;
						
						$("#goldBadge").text(" " + String(myGoldMedalCount) + "  ");
						$("#silverBadge").text(" " + String(mySilverMedalCount) + "  ");
						$("#bronzeBadge").text(" " + String(myBronzeMedalCount) + "  ");
						$("#ranking-points-overall").text(String(myScore));
						$("#ranking-points-average").text(String(Math.floor(totalScores / scoreCount)));
						$("#ranking-starts-held").text("0");
						$("#ranking-rank").text(String(myRank));
					}
					else {
						
					}
				});
			}
		}
		
		function makeModuleList(){
			//create entry
			
			$("#moduleList").append("<ul>");
			for(i=0;i<=moduleJsonList.length-1;i++)
			{
				if(moduleJsonList[i].completedStatus == "true")
				{
					var levelEntry = "<a id= '"+moduleJsonList[i].moduleId+ "' class='lesson' href='" + encodeURIComponent(moduleJsonList[i].moduleDirectory) + ".jsp'> <img class='logos' style='filter: blur(2px) contrast(30%) brightness(140%);-webkit-filter: blur(2px) contrast(30%) brightness(140%);' src='css/images/sans25/svg/" + moduleJsonList[i].moduleCategory + ".svg' title='"+moduleJsonList[i].moduleName+"' alt='" + moduleJsonList[i].moduleName + "' />";
					$("#moduleList").append(levelEntry);
					
				}
				else
				{
					var levelEntry = "<a id= '"+moduleJsonList[i].moduleId+ "' class='lesson' href='" + encodeURIComponent(moduleJsonList[i].moduleDirectory) + ".jsp'> <img class='logos'  title='"+moduleJsonList[i].moduleName+"' src='css/images/sans25/svg/" + moduleJsonList[i].moduleCategory + ".svg' alt='" + moduleJsonList[i].moduleName + "' />";
					$("#moduleList").append(levelEntry);
				}
			}
			$("#moduleList").append("</ul>");
		}
		
		function updateUserScore()
		{
			//work out amount completed
			var challengesCompleted =0;
			var challengesRemaining =0;
			for(i=0;i<moduleJsonList.length;i++)
			{
				if(moduleJsonList[i].completedStatus=="true")
				{
					challengesCompleted++;
				}
				else
				{
					challengesRemaining++;
				}
			}
			
			//work out total score
			var scoreTotal=0;
			var rewards=0;
			var myUserId = "<%= (String)ses.getAttribute("userName") %>";
			var currentRank="beginner";
		
			if(scoreboardList!=null)
			{
				for(i=0;i<scoreboardList.length;i++)
				{
					if(scoreboardList[i].username == myUserId )
					{
						scoreTotal=scoreboardList[i].score;
						rewards= rewards+scoreboardList[i].goldMedalCount;
						rewards= rewards+scoreboardList[i].silverMedalCount;
						rewards= rewards+scoreboardList[i].bronzeMedalCount;
						currentRank = getGetOrdinal(scoreboardList[i].place);
						break;	
					}
				}
			}
			else
			{
				scoreTotal=0;
				rewards=0;
				currentRank="Beginner";
			}
			
			$("#ranking-points-overall").html(scoreTotal);
			$("#starsHeld").html(""+rewards);
			$("#ranking-starts-held").html(""+rewards);
			$("#lessonsComplete").html(""+challengesCompleted);
			$("#ranking-rank").html(""+currentRank);
			
			
		}
		function callApis(){
			//Call Module List Api
			var ajaxCall = $.ajax({
				type: "POST",
				url: "../moduleFeed",
				dataType: 'json',
				async: false,
				success: function(o){
					moduleJsonList = o;
				}
			});
			if(ajaxCall.status != 200)
			{
				console.error("Failed to call moduleFeed API Successfuly");
			}
		}
		
		$( document ).ready(function(){
			refreshScore();
		});
		
		$("#solutionInput").submit(function(){
			var theSolution =  $("#key").val();
			var theLevel =  $("#level").val();
			var result = "";
			$("#solutionSubmitResults").hide("fast", function(){
				var ajaxCall = $.ajax({
					type: "POST",
					url: "../Submit",
					async: false,
					data: {
						key: theSolution,
						level: theLevel
					}				
				});
				if(ajaxCall.status != 200)
				{
					console.error("Failed to call moduleFeed API Successfuly: " + ajaxCall.responseText);
					result = "Key Submission Failure: " + ajaxCall.status;
				}
				else
				{
					result = ajaxCall.responseText;
				}
				$("#solutionSubmitResults").html(result);
				$("#solutionSubmitResults").show("slow");
			});
		});
		
		callApis();
		updateUserScore();
		makeModuleList();
		</script>
	<%
	}
}
%>