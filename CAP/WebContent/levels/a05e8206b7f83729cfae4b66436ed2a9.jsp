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
<%@ page import="levelUtils.InMemoryDatabase"%>
<% InMemoryDatabase imdb = new InMemoryDatabase();
imdb.Create();
String param1 = new String();
String param2 = new String();
String answerKey = new String();
if(request.getParameter("username") != null && request.getParameter("password") != null){
	 param1 = request.getParameter("username");
	 param2 = request.getParameter("password");
if (param1.equals("admin0") && param2.equals("d41d8cd98f00b204e9800998ecf8427e")) {
 	 answerKey = " 39F8AD24BA58094DAE474E312DBB1157E321AD30C0F958E0B4A8D5205B86662D ";} 
else answerKey = "<p style='color:red'>Wrong Username or Password!</p>"; 
}
String htmlTable = "AnswerKey is: " + answerKey;%>

<h1  class="title">Use of Hard-Coded Creds</h1>
<p class="levelText">The developers left some hard-coded credentials somewhere. You need to find them. </br> For more information on this issue check out <a href="https://owasp.org/www-community/vulnerabilities/Use_of_hard-coded_password" target="_blank">here</a></p>
<form id="levelForm"><em class="username">username: </em>
<input id="levelInput" name="username" type='text' autocomplete="off"><em class="password">password: </em>
<input id="levelInput" name="password" type='text' autocomplete="off"><input type="submit" value="Submit"></form>
<div id="formResults">
<%= htmlTable %>
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


