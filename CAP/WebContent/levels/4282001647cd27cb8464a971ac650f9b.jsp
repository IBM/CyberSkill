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

//No Filter 

sql = "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, \'Wayland Dennis Dannel\', 32, \'Tehran\', 200.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, \'Josiah Ricky Outterridge\', 25, \'Ankara\', 100.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (3, \'Ted Leighton Belanger\', 27, \'Mumbai\', 600.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (4, \'Amias Patrick Hunt\', 26, \'Hong Kong\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (5, \'Kev Marvyn Patrickson\', 43, \'Bangkok\', 920.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (6, \'Kody Lemoine Yap\', 33, \'Hanoi\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (7, \'Quinn Tristram Irvin\', 53, \'Mexico City\', 902.42 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (8, \'Leyton Osborn Hall\', 39, \'Surat\', 500.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (9, \'Ripley Hadley Espenson\', 26, \'Surat\', 600 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (10, \'Chase Nat Washington\', 25, \'Riyadh\', 9030 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (11, \'Aldous Tristram Elliston\', 21, \'Delhi\', 920.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (12, \'Esm\303\251 Selwyn Lacey\', 22, \'Bangkok\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (13, \'Rod Deryck Benjaminson\', 24, \'Mumbai\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (14, \'Oz Tod Dane\', 32, \'Karachi\', 51.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (15, \'Lauren Seth Gibb\', 29, \'Los Angeles\', 67200.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (16, \'Ivor Raven Frye\', 27, \'Chennai\', 5312300.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (17, \'Isadore Quincy Landon\', 27, \'Dhaka\', 53140.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (18, \'Monty Chase Phillips\', 28, \'Moscow\', 56100.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (19, \'Wil Leyton Bunker\', 39, \'Busan\', 7910.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (20, \'Burt Laurie Alden\', 54, \'Johannesburg\', 970.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (21, \'Will Goodwin Elwyn\', 34, \'Paris\', 891.12);INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (22, \'Barrett Wynne Goffe\', 33, \'Istanbul\', 90.00 );";
imdb.InsertTableData(sql);
sql = "SELECT NAME, ADDRESS FROM COMPANY WHERE NAME=\"" + param + "\" ORDER BY NAME ASC;";
String htmlTable = imdb.inMemorySelectOperation(sql);%>

<h1  class="title">SQL Injection Quotation</h1>
<p class="levelText">Use SQL Injection to retreive all the data stored in the database table. The key to this challenge is the location of the user whos first name is Ripley <br>If you would like to read more about SQL injection you can do so <a href=" https://owasp.org/www-community/attacks/SQL_Injection" target="_blank">here</a>.
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


