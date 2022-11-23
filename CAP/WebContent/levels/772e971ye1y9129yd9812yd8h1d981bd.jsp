<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>

<%//cipher1 %>

<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>

<% Logger logger  = LoggerFactory.getLogger(this.getClass()); %>

<% 

HttpSession ses = request.getSession(true);
String username;

boolean answerCorrect = false;

if(SessionValidator.validate(ses))
{
	logger.debug("Session has been validated");
	
	JWT jwt = new JWT();
	String JWT_session = ses.getAttribute("JWT").toString();
	logger.debug("JWT_session: " + JWT_session);
	Claims claim = jwt.decodeJWT(JWT_session);
	username = claim.get("username").toString();
	logger.debug("username: " + username);	
	
	StringBuffer accessURL = request.getRequestURL();
	String accessPage = accessURL.substring(accessURL.lastIndexOf("/")+1, accessURL.lastIndexOf(".jsp"));
	logger.debug("Validating page accessed: " + accessPage + " is open for play");
	utils.Api api = new utils.Api();
	boolean levelOpen = api.validateLevelIsOpen(accessPage);
	
	
	
	
	if(levelOpen)
	{
		logger.debug("level " + accessPage + " is open for play");
		String answer = (String) request.getParameter("answer");
		logger.debug("Answer: " + answer);
		
		/*Get Level Info*/
		JSONArray json = new JSONArray();
		
		json = api.getLevelDetailsByDirectory(accessPage);
		JSONObject rec = (JSONObject)json.get(0);
		
		String rec_name = rec.get("name").toString();
		
		if(answer != null)
		{
			if(answer.compareToIgnoreCase("too many") == 0)
			{
				answerCorrect = true;
			}
		}
		else
		{
			answer = "";
		}
		
		
	%>			
		<!DOCTYPE html>
		<html>
		<head>
		<title><%=rec_name%></title>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="css/beta/w3.css">
		</head>
		<body class="w3-content" style="max-width:1300px">
		
		<div id="id01" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-cyan"> 
	        <span onclick="document.getElementById('id01').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>About This Challenge</h2>
	      </header>
	      <div class="w3-container">
	        <p>This is faction chat, this feature allows teams to talk to each other and solve challenges co-operatively</p>
	      </div>
	      <footer class="w3-container w3-cyan">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
  	
  	 <div id="id02" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-cyan"> 
	        <span onclick="document.getElementById('id02').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Challenge Clue</h2>
	      </header>
	      <div class="w3-container">
	        <p>This is your faction score breakdown.</p>
	       </div>
	      <footer class="w3-container w3-cyan">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
		
		
		<!-- First Grid: Logo & About -->
		<div class="w3-row">
		  <div class="w3-half w3-black w3-container w3-center" style="height:700px">
		    <div class="w3-padding-64">
		      <h1>Challenge Assistance</h1>
		    </div>
		    <div class="w3-padding-64">
		      <a href="#" onclick="document.getElementById('id01').style.display='block'" class="w3-button w3-black w3-block w3-hover-blue-grey w3-padding-16">About</a>
		      <a href="#" onclick="document.getElementById('id02').style.display='block'" class="w3-button w3-black w3-block w3-hover-blue-grey w3-padding-16">Clue</a>
		      <a href="../dashboard.jsp" class="w3-button w3-black w3-block w3-hover-blue-grey w3-padding-16">Dashboard</a>
		    </div>
		  </div>
		  <div class="w3-half w3-blue-grey w3-container" style="height:700px">
		    <div class="w3-padding-64 w3-center">
		      <h1><%=rec_name%></h1>
		      <img src="css/images/7.svg" class="w3-margin w3-circle" alt="Person" style="width:50%">
		      <div class="w3-left-align w3-padding-large">
		        
		        <%
		        if(!answerCorrect)
		        {
		       	%>
			        <p>Soup soup and more soup</p>
			        
			        
			        <p>
			        	<form action="#" method="get">
							<!-- Here is where we ask the question, change nothing only the question. -->
							 ryg wkxi myyuc czysz dro lbydr?
							
							<p align=center> 
							<input class="textbox" name="answer" id="answer" type="text" autocomplete="off" value="Answer">
							</p>
						    	<p align=center> <input type="submit" name="Submit" value="Submit" > </p>
						</form> 
					</p>
				<%
		        }
		        else
		        {
				%>
					<p>Congratulations you are correct</p>
				
				<%
					boolean bool = api.submitValidSolution(username, accessPage);
					if(bool)
					{
						%>
						<p>You have been awarded points for this submission!</p>
						<%
					}
					else
					{
						%>
						<p>You have not been awarded points for this submission!</p>
						<%
					}
		        }
		        %>				
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
		logger.debug("level " + accessPage + " is NOT open for play");
	}

%>
	



	
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