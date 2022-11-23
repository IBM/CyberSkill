<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="levelUtils.InMemoryDatabase,java.sql.Connection, java.sql.ResultSet, java.sql.Statement"%>



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
		/**Just Log In challenge**/
		logger.debug("level " + accessPage + " is open for play");
		
				
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

				
				
		String answer = (String) request.getParameter("answer");
		logger.debug("Answer: " + answer);
		
		/*Get Level Info*/
		JSONArray json = new JSONArray();
		
		json = api.getLevelDetailsByDirectory(accessPage);
		JSONObject rec = (JSONObject)json.get(0);
		
		String rec_name = rec.get("name").toString();
		
		if(answer != null)
		{
			if(answer.compareToIgnoreCase("39366FBFA18925BC1680B2E968931324BDA28EA6E017AE1976FA5BFE63BAAFE6") == 0)
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
	        <p>This is faction chat, this feature allows teams to talk to each other and solve challenges co-operatively</p>
	      </div>
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
	        <p>This is your faction score breakdown.</p>
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
			        <p>To complete this challenge you must sign in as a user. Once authenticated you will receive the solution key.</p>
			        
			        
			        <p>
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
			        	
			        	<div id="htmlTable" style="overflow-y: scroll; height:200px;"><%= result %></div>
			        	
			        	<form action="#" method="get">
							<!-- Here is where we ask the question, change nothing only the question. -->
							 Who is the solution key?
							
							<p align=center> 
							<input class="textbox" name="answer" id="answer" type="text" autocomplete="off" value="Answer">
							</p>
						    	<p align=center> <input type="submit" name="Submit" value="Submit" > </p>
						</form> 
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