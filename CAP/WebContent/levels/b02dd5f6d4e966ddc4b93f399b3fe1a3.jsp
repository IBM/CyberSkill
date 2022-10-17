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
<%@ page import="java.math.BigInteger, java.security.SecureRandom, levelUtils.XSSCheck"%>
<% 
response.setHeader("X-XSS-Protection", "0");
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
if(request.getParameter("levelInput") != null) {
param = request.getParameter("levelInput");
 // No Filter In this challenge
}
if(ses.getAttribute("xssCsrfToken") != null){
if(ses.getAttribute("xssCsrfToken").toString().isEmpty()){
newCsrfTokenNeeded = true;
} else if(!param.isEmpty()){
//Check CSRF Token
if(request.getParameter("csrfToken") != null) {csrfToken = request.getParameter("csrfToken");}
if(csrfToken.equalsIgnoreCase(ses.getAttribute("xssCsrfToken").toString())) {
newCsrfTokenNeeded = false;
result = "Your user input is included in this message in order to simulate a Reflected Cross Site Scripting Scenario. <a href=\"" + param + "\">" + param + "</a>";
if(XSSCheck.check("<html><head></head><body><a href=\"" + param + "\">" + param + "</a></body></html>")){
showResult = true;}
}
}
}
if(newCsrfTokenNeeded){
ses.setAttribute("xssCsrfToken", randomString);
csrfToken = randomString;
}
%>
<h1  class="title">A XSS</h1>
<p class="levelText">This is an XSS challenge. Your objective is to submit some malicious input that will cause an alert popup to display on the page.</p>
<p class="levelText"><h1>Please note that:</h1><ul><li>An 'XSS' (in terms of the game) means getting a JavaScript alert box, prompt box, or confirm box to display</li><li>The alert box must be displayed within the context of this page, i.e. not in the url or loaded from an external src</li><li>Any code that requires some form of manual user interaction (e.g. click, press a key, etc.) to get an alert dialog to display might not complete the level. The alert dialog should display itself automatically.</li></ul></p>
<form id="levelForm" method="POST"><em class="formLabel">User Input: </em>
<input id="csrfToken" name="csrfToken" type="hidden" value="<%= csrfToken %>"><input id="levelInput" name="levelInput" type='text' autocomplete="off"><input type="submit" value="Submit"></form>
<div id="formResults">
<%= result %>
</div>
<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
<% /* Common Footer */ %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>

</body></html>

<% } else { %>
You are not currently signed in. Please Sign in<% } %>


