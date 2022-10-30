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
if(request.getParameter("levelInput") != null) {param = request.getParameter("levelInput");}
String sql = "CREATE TABLE COMPANY (ID INT PRIMARY KEY NOT NULL, NAME TEXT NOT NULL,AGE INT NOT NULL,ADDRESS CHAR(50), SALARY REAL)";
imdb.CreateTable(sql);
sql = "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, \'Paul\', 32, \'California\', 20000.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, \'Mark\', 23, \'Dublin\', 90000.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (7531, \'jason flood\', 43, \'Administrator town\', 180000.00 );";
imdb.InsertTableData(sql);
sql = "SELECT * FROM COMPANY WHERE ID = ";
String htmlTable = imdb.inMemorySelectOperation(sql, param);%>

<h1  class="title">SQL Injection 1</h1>
<p class="levelText">This is an SQL injection challenge. Your objective is to find the name of the administrator of the application. 

<br>If you would like to read more about SQL injection you can do so <a href=" https://owasp.org/www-community/attacks/SQL_Injection" target="_blank">here</a>.

</p>
<form id="levelForm"><em class="formLabel">User Input: </em>
<input id="levelInput" name="levelInput" type='text' autocomplete="off"><input type="submit" value="Submit"></form>
<div id="formResults">
<%= htmlTable %>

</div><% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
<% /* Common Footer */ %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>

</body></html>

<% } else { %>
You are not currently signed in. Please Sign in<% } %>


