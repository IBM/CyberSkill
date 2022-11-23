<% /* Common Header */ %>
<%@ page import="utils.SessionValidator"%>
<% HttpSession ses = request.getSession(true);
if(SessionValidator.validate(ses)){
%>

<html xmlns="http://www.w3.org/1999/xhtml"><head><title>Sanctuary Project - Level</title>
<meta name="viewport" content="width=device-width; initial-scale=1.0;"><link href="css/global.css" rel="stylesheet" type="text/css" media="screen" /></head>
<body>
<script type="text/javascript" src="../js/jquery-2.1.1.min.js"></script>
<jsp:include page="../header.jsp" /> <% //Header Entry %><jsp:include page="../levelFront.jsp" /> <% //Level Front Entry %>
<%@ page import="levelUtils.InMemoryDatabase, java.sql.Connection, java.sql.ResultSet, java.sql.Statement"%>
<% 
response.setHeader("X-XSS-Protection", "0");
String randomString = new String();
String csrfToken = new String();
boolean csrfCheck = false;
boolean newCsrfTokenNeeded = true;
boolean showResult = false;
boolean userFound = false;
boolean userAuthenticated = false;String result = new String();
String htmlOutput = new String();
String retrievedUsername = new String();
String errorString = new String();InMemoryDatabase imdb = new InMemoryDatabase();
imdb.Create();
String sql = "CREATE TABLE users (ID INT PRIMARY KEY NOT NULL, username TEXT NOT NULL, PASSW CHAR(64), question TEXT, answer TEXT);";
imdb.CreateTable(sql);
sql = "INSERT INTO users (ID,username,passw,question,answer) VALUES (1, \'john\', \'89oi2qeflkasncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (2, \'administrator\', \'89oi2qe3flkasncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (3, \'root\', \'89oi25qeflkasncs1\', \'What is your favourite colour?\', \'Yellow\');INSERT INTO users (ID,username,passw,question,answer) VALUES (4, \'superuser\', \'89oi2hqeflkasncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (5, \'mark\', \'89oi2qe8flkasncs1\', \'What is your favourite colour?\', \'Yellow\');INSERT INTO users (ID,username,passw,question,answer) VALUES (6, \'jason\', \'89oi2qe7flkasncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (7, \'alexis\', \'89oi2qefl2kasncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (8, \'trevor\', \'89oi2qekflkasncs1\', \'What is your favourite colour?\', \'Yellow\');INSERT INTO users (ID,username,passw,question,answer) VALUES (10, \'aidan\', \'89oi22qeflkassncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (11, \'karl\', \'89oi2qeflkasgncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (12, \'brendan\', \'89oi2qekflkasncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (13, \'maria\', \'89oi2qeflkasncs1\', \'What is your favourite colour?\', \'Yellow\');INSERT INTO users (ID,username,passw,question,answer) VALUES (14, \'josh\', \'89oi2qeflkxasncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (15, \'paul\', \'89oi2qeflkassncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (16, \'robert\', \'89oi2qeflkdasncs1\', \'What is your favourite colour?\', \'Orange\');INSERT INTO users (ID,username,passw,question,answer) VALUES (17, \'william\', \'89oi2qeflfkasncs1\', \'What is your favourite colour?\', \'Purple\');INSERT INTO users (ID,username,passw,question,answer) VALUES (18, \'gerry\', \'89oi2qeflmgkasncs1\', \'What is your favourite colour?\', \'Yellow\');";
imdb.InsertTableData(sql);
String param = new String();
if(request.getParameter("levelInput") != null) {param = request.getParameter("levelInput");}
String param2 = new String();
if(request.getParameter("levelInput2") != null) {param2 = request.getParameter("levelInput2");}
String answerString = new String();
if(request.getParameter("answer") != null) {answerString = request.getParameter("answer");}
Connection myInMemoryConnection = imdb.Create();
Statement stmt = null;
ResultSet rs = null;
try{
stmt = myInMemoryConnection.createStatement();
if(!answerString.isEmpty() && !param.isEmpty()) {
	sql = "SELECT answer, passw FROM users WHERE username = '" + param.replaceAll("'", "''") + "';";
	rs = stmt.executeQuery(sql);
 if(rs.next()) {
		if(rs.getString(1).equalsIgnoreCase(answerString)) { 
			result = "<h2>Correct Answer</h2><p>Your password is: <b>" + rs.getString(2) + "</b></p>";		} else { 
			result = "<h2>Incorrect Answer</h2><p>That is not the correct answer. We have something Different in our storage</p>";		}
	} else {
		result = "Answer Look up Error";
	}
} else if (!param.isEmpty() && !param2.isEmpty()) {
sql = "SELECT username FROM users WHERE username = '" + param + "';";
try
{
 myInMemoryConnection.setAutoCommit(false);
 rs = stmt.executeQuery(sql);
	if(rs.next()) {
		retrievedUsername = rs.getString(1);
		userFound = true;
		sql = "SELECT username FROM users WHERE username = '" + param.replaceAll("'", "''") + "' AND passw = '" + param2.replaceAll("'", "''") + "'";
		rs = stmt.executeQuery(sql);
		if(rs.next()) {
			userAuthenticated = true;		}
		if(userAuthenticated) {
			result = "<h2>Authenticated</h2><p>Congratulations, you have successfully authenticated. 			The solution key to this challenge is 39366FBFA18925BC1680B2E968931324BDA28EA6E017AE1976FA5BFE63BAAFE6</p>";
		} else if (userFound) {
			String question = new String();
			sql = "SELECT question FROM users WHERE username = '" + param.replaceAll("'", "''") + "';";
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				question = rs.getString(1);
			} else if (retrievedUsername.isEmpty()){ 
				question = "Could not find question for user name submitted.";
			} else {
				question = "Could not find question for user name submitted.<!-- " + retrievedUsername + " -->";			}
			result = "<h2>Incorrect Password</h2><p>Have you forgotten your password?</p><form id=\"questionForm\">"
				+ "<div id=\"forgotPassDiv\" ><table><tr><td>"
				+ "<em class=\"formLabel\">Question: </em>"
				+ "</td><td>"
				+ question
				+ "</td></tr><tr><td><em class=\"formLabel\">Answer: </em>"
				+ "</td><td>"
				+ "<input id=\"answer\" name=\"answer\" type=\"text\">"
				+ "<input id=\"levelInput\" name=\"levelInput\" type=\"hidden\" value=\"" + retrievedUsername + "\">"
				+ "</td></tr><tr><td colspan=\"2\">"
				+ "<input type=\"submit\" value=\"Retrieve Password\">"
				+ "</td></tr></table></div>"
			+ "</form>";
		}
	} else {
		result = "<h2>Authentication Failure</h2><p>The System was unable to Authenticate you with those credentials</p>";
	}
 rs.close();
 stmt.close();
}
catch ( Exception e )
{
	if(!userFound) {
		errorString = "User Look Up Failed: " + e.toString();
	} else { 
		errorString = "Auth Failed: " + e.toString();
	}
	result = "<h2>Authentication Failure</h2><p>The System was unable to Authenticate you with those credentials</p><!-- " + errorString + " -->";
}
} else {
	result = new String();
}}
catch ( Exception e )
{
		result = "Answer Look Up Fail";
}
%>
<h1  class="title">Just Log In</h1>
<p class="levelText"> To complete this challenge you must sign in as a user. Once authenticated you will recieve the solution key. <br>For more information on this issue check out: <a href="https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html" target="_blank">here</a></p>
<form id="levelForm"><table><tr><td>
<em class="formLabel">User Name: </em>
</td><td>
<input id="levelInput" name="levelInput" type='text' autocomplete="off"></td></tr><tr><td>
<em class="formLabel">Password : </em>
</td><td>
<input id="levelInput2" name="levelInput2" type='password'>
</td></tr><tr><td colspan="2">
<input type="submit" value="Submit">
</td></tr><tr><td colspan="2" style="display: none;">
<a id="forgotPass" href="javascript;">Forgot Your Password?</a>
</td></tr></table></form>
<div id="formResults">
<%= result %>
</div></p>
<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
<% /* Common Footer */ %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>
</body></html>
<% } else { %>
You are not currently signed in. Please Sign in<% } %>