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
<%@ page import="java.math.BigInteger, java.security.SecureRandom, java.util.regex.Matcher, java.util.regex.Pattern"%>
<% 
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
%>
<h1  class="title">Verbose Error Message</h1>
<p class="levelText">Applications should be ready for unexpected user input, often error messages can give away details about network topology through stack traces. Find the details of the server and enter it into the Solution key box to complete this level. </br> For more information on this issue check out <a href="https://owasp.org/www-community/Improper_Error_Handling" target="_blank">here</a></p>
<script>function validateFileName() {    var f = document.forms["levelForm"]["fileName"].value;    var ext = f.substring(f.lastIndexOf('.') + 1);    if(ext == "gif" || ext == "GIF" || ext == "JPEG" || ext == "jpeg" || ext == "jpg" || ext == "JPG" || ext == "png" || ext == "PNG" || ext == "bmp" || ext == "BMP" ext == "SVG" || ext == "svg") {        return true;    }  else if(ext == "exe" || ext == "bat" || ext == "sh" || ext == "jar" || ext == "py"){        document.getElementById('jsresult').innerHTML = '<h4 style="color:red;">Unable to view this file. The DLE is unavailable to respond to requests. Please try again later. (org.apach.http.conn ConnectionTimeoutException: Connect to 103.22.17.3:5000 failed: Connection timed out.)</h4>';        return false;    }	   else{        document.getElementById('jsresult').innerHTML = '<h4 style="color:red;">Please upload image files only.</h4>';			return false;			}}</script><form onsubmit="return validateFileName()" id="levelForm"><em class="formLabel">File Name: </em>
<input id="csrfToken" name="csrfToken" type="hidden" value="<%= csrfToken %>"><input id="fileName" name="fileName" type='text' autocomplete="off" required><input type="submit" value="Upload File"></form>
<div id="jsresult"></div>
<div id="formResults">
<%= result %>
</div>
<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
 %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>

</body></html>

<% } else { %>
You are not currently signed in. Please Sign in<% } %>


