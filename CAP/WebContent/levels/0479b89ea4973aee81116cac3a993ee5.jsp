<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%//Weak Session Ids %>

<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.util.Random"%>

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
		response.setHeader("X-XSS-Protection", "0");
		String randomString = new String();
		String csrfToken = new String();
		boolean csrfCheck = false;
		boolean newCsrfTokenNeeded = true;
		boolean showResult = false;
		String result = new String();
		String htmlOutput = new String();
		Cookie[] cookies = request.getCookies();

			String sessionArray[] = {"Session1", "Session2", "Session4", "Session5", "Session6", "Session7", "Session8", "Session9", "Session10", "Session0"};
			
		boolean cookieFound = false;
		boolean adminSesh = false;
		boolean validSesh = false;
		for (int i = 0; i < cookies.length; i++)
		{
		if(cookies[i].getName().equalsIgnoreCase("sessionCookie"))
			{
				cookieFound = true;
				if(cookies[i].getValue().equalsIgnoreCase(sessionArray[9]))
				{
					adminSesh = true;
				} else {
					for(int j = 0; j < sessionArray.length; j++) {
						if(cookies[i].getValue().equalsIgnoreCase(sessionArray[j]))
							validSesh = true;
					}
				}
				break;
			}
		}
		if(!cookieFound)
		{
		Random r = new Random();
		int random = r.nextInt(9);
		Cookie cookie = new Cookie("sessionCookie", sessionArray[random]);
		response.addCookie(cookie);}
		if(adminSesh)
		{
			result = "<h2>Welcome Administrator</h2><p>The key for this challenge is: <b>577e4507d8cfeff13e3680a2c4c6ba6df94b506e94f4e9fb5498440ebab0259f</b></p>";
		} else if (validSesh){
		 result = "<h2>Welcome User</h2>You are authenciated as a user, and currently have an active session.";
		} else {
		 result = "<h2>Invalid Session Detected</h2>";
		}
		String answer = (String) request.getParameter("answer");
		logger.debug("Answer: " + answer);
		
		/*Get Level Info*/
		JSONArray json = new JSONArray();
		
		json = api.getLevelDetailsByDirectory(accessPage);
		JSONObject rec = (JSONObject)json.get(0);
		
		String rec_name = rec.get("name").toString();
		
		if(answer != null)
		{
			if(answer.compareToIgnoreCase("577e4507d8cfeff13e3680a2c4c6ba6df94b506e94f4e9fb5498440ebab0259f") == 0)
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
	       <p>Read all about Session Management on OWASP <form action="https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html" target="_blank">
    <input type="submit" value="GO TO OWASP Session Management Cheat Sheet" />
</form></p></div>
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
	        <p>123 Sesame Street</p>
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
			        <p>Are session management assets like user credentials and session IDs properly protected? This session management challenge is vulnerable to session tampering due to weak account management functions responsible for generating session IDs. To complete this challenge you must hijack the administrators session.</p>
			        
			        
			        
			        <p>
			        	<form ACTION="#" method="GET"><em class="formLabel">Solution: </em>
<input id="answer" name="answer" type='text' autocomplete="off"><input type="submit" value="Submit"></form>
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
						<p>As you have already solved this, you have not been awarded points for this submission!</p>
						<%
					}
					else
					{
						%>
						<p>You have been awarded points for this submission!</p>
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