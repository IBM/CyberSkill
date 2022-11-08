<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="utils.Api"%>
<%@ page import="io.jsonwebtoken.Claims"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="levelUtils.InMemoryDatabase"%>

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
		
		InMemoryDatabase imdb = new InMemoryDatabase();
		imdb.Create();
		String param = new String();
		if(request.getParameter("levelInput") != null) {param = request.getParameter("levelInput");}
		String sql = "CREATE TABLE COMPANY (ID INT PRIMARY KEY NOT NULL, NAME TEXT NOT NULL,AGE INT NOT NULL,ADDRESS CHAR(50), SALARY REAL)";
		imdb.CreateTable(sql);

		//No Filter 

		sql = "INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (1, \'Wayland Dennis Dannel\', 32, \'Tehran\', 200.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (2, \'Josiah Ricky Outterridge\', 25, \'Ankara\', 100.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (3, \'Ted Leighton Belanger\', 27, \'Mumbai\', 600.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (4, \'Amias Patrick Hunt\', 26, \'Hong Kong\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (5, \'Kev Marvyn Patrickson\', 43, \'Bangkok\', 920.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (6, \'Kody Lemoine Yap\', 33, \'Hanoi\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (7, \'Quinn Tristram Irvin\', 53, \'Mexico City\', 902.42 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (8, \'Leyton Osborn Hall\', 39, \'Surat\', 500.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (9, \'Ripley Hadley Espenson\', 26, \'Surat\', 600 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (10, \'Chase Nat Washington\', 25, \'Riyadh\', 9030 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (11, \'Aldous Tristram Elliston\', 21, \'Delhi\', 920.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (12, \'Esm\303\251 Selwyn Lacey\', 22, \'Bangkok\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (13, \'Rod Deryck Benjaminson\', 24, \'Mumbai\', 90.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (14, \'Oz Tod Dane\', 32, \'Karachi\', 51.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (15, \'Lauren Seth Gibb\', 29, \'Los Angeles\', 67200.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (16, \'Ivor Raven Frye\', 27, \'Chennai\', 5312300.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (17, \'Isadore Quincy Landon\', 27, \'Dhaka\', 53140.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (18, \'Monty Chase Phillips\', 28, \'Moscow\', 56100.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (19, \'Wil Leyton Bunker\', 39, \'Busan\', 7910.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (20, \'Burt Laurie Alden\', 54, \'Johannesburg\', 970.00 );INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (21, \'Will Goodwin Elwyn\', 34, \'Paris\', 891.12);INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (22, \'Barrett Wynne Goffe\', 33, \'Istanbul\', 90.00 );";
		imdb.InsertTableData(sql);
		sql = "SELECT NAME, ADDRESS FROM COMPANY WHERE NAME=\"" + param + "\" ORDER BY NAME ASC;";
		String htmlTable = imdb.inMemorySelectOperation(sql);
		
		
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
			if(answer.compareToIgnoreCase("Surat") == 0)
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
	      <p>Read all about SQL injection on OWASP <form action="https://owasp.org/www-community/attacks/SQL_Injection" target="_blank">
    <input type="submit" value="GO TO OWASP SQL Injection" />
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
	        <p>Single or Double?</p>
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
			        <p>Can you get the location for user with first name Ripley using SQL injection?</p>
			        
			        
			        <p>
			        	<form id="levelForm">
			        		<em class="formLabel">User Input: </em>
							<input id="levelInput" name="levelInput" type='text' autocomplete="off">
							<input type="submit" value="Submit">
						</form>
			        	
			        	<div id="htmlTable" style="overflow-y: scroll; height:200px;"><%= htmlTable %></div>
			        	
			        	<form action="#" method="get">
							<!-- Here is where we ask the question, change nothing only the question. -->
							 What is the user location?
							
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