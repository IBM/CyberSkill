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
String param = new String();
String answerKey = new String();
if(request.getParameter("levelInput") != null) {param = request.getParameter("levelInput");}
if (param.equalsIgnoreCase("the woods are lovely, dark and deep")) { answerKey = "2b72487123dff34e200b155655c04fe3";}
String htmlTable = "AnswerKey is: " + answerKey;%>

<h1  class="title">Broken Cryptography</h1>
<p class="levelText">This is a broken cryptography challenge. To complete this challenge feel free to use tool online tools. The goal is to de-obfuscate the following string. eW1qIGJ0dGl4IGZ3aiBxdGFqcWQsIGlmd3AgZnNpIGlqanU=  

<br>This might take some people a while, some good advice can be found <a href="https://www.youtube.com/watch?v=dQw4w9WgXcQ">here</a>.

</p>
<form id="levelForm"><em class="formLabel">User Input: </em>
<input id="levelInput" name="levelInput" type='text' autocomplete="off"><input type="submit" value="Submit"></form>
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


