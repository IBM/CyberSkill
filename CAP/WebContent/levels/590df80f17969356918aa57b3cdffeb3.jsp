<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%//Verbose Error Message%>

<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.math.BigInteger, java.security.SecureRandom, java.util.regex.Matcher, java.util.regex.Pattern"%>

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
		String randomString = new String();
		String csrfToken = new String();
		boolean csrfCheck = false;
		boolean newCsrfTokenNeeded = true;
		boolean showResult = false;
		String result = new String();
		try
		{
			byte byteArray[] = new byte[16];
			SecureRandom psn1 = SecureRandom.getInstance("SHA1PRNG");
			psn1.setSeed(psn1.nextLong());
			psn1.nextBytes(byteArray);
			BigInteger bigInt = new BigInteger(byteArray);
			randomString = bigInt.toString();
		}
		catch(Exception e)
		{
			System.out.println("Random Number Error : " + e.toString());
		}
		String param = new String();
		if(request.getParameter("fileName") != null) {
		param = request.getParameter("fileName");}
		if(ses.getAttribute("fileCsrfToken") != null){
		if(ses.getAttribute("fileCsrfToken").toString().isEmpty()){
		newCsrfTokenNeeded = true;
		} else if(!param.isEmpty()){
		//Check CSRF Token
		if(request.getParameter("csrfToken") != null) {csrfToken = request.getParameter("csrfToken");}
		if(csrfToken.equalsIgnoreCase(ses.getAttribute("fileCsrfToken").toString())) {
		newCsrfTokenNeeded = false;
		String mfileRegex = "([^\\s]+(\\.(?i)(regcmddmgisohta))$)";
		String ifileRegex = "([^\\s]+(\\.(?i)(jpg|jpeg|gif|png|bmp|svg))$)";
		String exefileRegex = "([^\\s]+(\\.(?i)(exe|jar|py|sh))$)";
		Pattern maliciousFileRegex = Pattern.compile(mfileRegex);
		Pattern imageFileRegex = Pattern.compile(ifileRegex);
		Pattern executableFileRegex = Pattern.compile(exefileRegex);
		Matcher exeMatch = executableFileRegex.matcher(param);
		Matcher maliciousMatch = maliciousFileRegex.matcher(param);
		Matcher imageMatch = imageFileRegex.matcher(param);
		if(maliciousMatch.matches()){
		result = "File <b>" + param + "</b> uploaded successfully. Looks like this executable file could be dangerous...";
		showResult = false;
		}
		else if (imageMatch.matches()){
		result = "File <b>" + param + "</b> uploaded successfully.";
		}
		else if (exeMatch.matches()){
		result = "File <b>" + param + "</b> Unable to view this file. The DLE is unavailable to respond to requests. Please try again later. (org.apach.http.conn ConnectionTimeoutException: Connect to 103.22.17.3:5000 failed: Connection timed out.)";
		}
		else {
		result = "<b>" + param + "</b> - invalid file name or type. File not uploaded.";
		}
		}
		}
		}
		if(newCsrfTokenNeeded){
		ses.setAttribute("fileCsrfToken", randomString);
		csrfToken = randomString;
		}
		
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
			if(answer.compareToIgnoreCase("103.22.17.3:5000") == 0)
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
	       <p>Read all about Error handling on OWASP <form action="https://owasp.org/www-community/Improper_Error_Handling" target="_blank">
    <input type="submit" value="GO TO OWASP Improper Error Handling" />
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
	        <p>Some files are automatically flagged as suspicious.</p>
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
		      <img src="css/images/7.svg" class="w3-margin w3-circle" alt="Person" style="width:10%">
		      <div class="w3-left-align w3-padding-large">
		        
		        <%
		        if(!answerCorrect)
		        {
		       	%>
			        <p>Applications should be ready for unexpected user input, often error messages can give away details about network topology through stack traces. Find the details of the server and enter it into the Solution key box to complete this level. </p>
			        
			        
			        <p>
			        	<script>function validateFileName() {    var f = document.forms["levelForm"]["levelInput"].value;    var ext = f.substring(f.lastIndexOf('.') + 1);    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG" || ext == "bmp" || ext == "BMP" || +ext == "SVG" || ext == "svg") {        return true;    }  else if(ext == "exe" || ext == "bat" || ext == "sh" || ext == "jar" || ext == "py"){        document.getElementById('jsresult').innerHTML = '<h4 style="color:red;">Unable to view this file. The DLE is unavailable to respond to requests. Please try again later. (org.apach.http.conn ConnectionTimeoutException: Connect to 103.22.17.3:5000 failed: Connection timed out.)</h4>';        return false;    }	   else{        document.getElementById('jsresult').innerHTML = '<h4 style="color:red;">Please upload image files only.</h4>';			return false;			}}</script>

			        	<form onsubmit="return validateFileName()" id="levelForm">
			        		<em class="formLabel">File Name: </em>
							<input id="csrfToken" name="csrfToken" type="hidden" value="<%= csrfToken %>">
							<input id="levelInput" name="levelInput" type='text' autocomplete="off">
							<input type="submit" value="Upload File">
						</form>
			        	<div id="jsresult"></div>
						<div id="formResults">
			        	
			        	<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
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
						<p>You have been awarded points for this submission!</p>
						<%
					}
					else
					{
						%>
						<p>As you have already solved this, you have not been awarded points for this submission!</p>
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