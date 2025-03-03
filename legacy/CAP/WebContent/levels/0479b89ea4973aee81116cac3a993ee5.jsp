 %>
<%@ page import="utils.SessionValidator"%>
<% HttpSession ses = request.getSession(true);
if(SessionValidator.validate(ses)){

%>

<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Cyber Awareness Platform - Level</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0;"><link href="css/global.css" rel="stylesheet" type="text/css" media="screen" /></head>
<body>
<script type="text/javascript" src="../js/jquery-2.1.1.min.js"></script>
<jsp:include page="../header.jsp" /> <% //Header Entry %><jsp:include page="../levelFront.jsp" /> <% //Level Front Entry %>
<%@ page import="java.util.Random"%>
<% 
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
%>
<h1  class="title">Weak Session IDs</h1>
<p class="levelText"> Are session management assets like user credentials and session IDs properly protected? This session management challenge is vulnerable to session tampering due to weak account management functions responsible for generating session IDs. To complete this challenge you must hijack the administrators session.

<br>If you would like to read more about session management you can do so <a href="https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html" target="_blank">here</a>.


</p>
<div id="formResults">
<%= result %>
</div></p>
<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
 %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>

</body></html>

<% } else { %>
You are not currently signed in. Please Sign in<% } %>


