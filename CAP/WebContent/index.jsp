<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"  errorPage="" %>
<%@ page import="utils.PropertiesReader"%>
<%@ page import="java.util.Properties, utils.*"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>

<%-- Get a reference to the logger for this class --%>
<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>


<%
String error = request.getParameter("error");
boolean errors = true;
String errorCode = "A generic error has occured";
if(error==null)
{
	errors = false;
}
else
{
	if(error.compareTo("1")==0){errorCode="LDAP Authentication Failed";}
	if(error.compareTo("2")==0){errorCode="Cloud/Ldap mismatch - please try again";}
	if(error.compareTo("3")==0){errorCode="Cloud login failure";}
	if(error.compareTo("4")==0){errorCode="Username/Password does not exist";}
	if(error.compareTo("5")==0){errorCode="Blank Username/Password Submitted";}
	if(error.compareTo("6")==0){errorCode="Blank Username/Password Submitted";}
	if(error.compareTo("7")==0){errorCode="Cloud Authentication failure";}
	if(error.compareTo("8")==0){errorCode="Ldap Authentication failure";}
	if(error.compareTo("9")==0){errorCode="Cloud persistant storage failure";}
	if(error.compareTo("10")==0){errorCode="Ldap persistant storage failure";}
	if(error.compareTo("11")==0){errorCode="We could not retrieve your Serial Number: you dont have one";}
	if(error.compareTo("12")==0){errorCode="Invalid e-mail address";}
	if(error.compareTo("13")==0){errorCode="Email address already registered";}
	if(error.compareTo("14")==0){errorCode="Account not activated";}
	
	String originalUri = (String)request.getAttribute(RequestDispatcher.FORWARD_REQUEST_URI);
	logger.error("Index error: "+errorCode+ " for page: " + originalUri+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());

}

String registererror = request.getParameter("registererror");
boolean registererrors = true;
String registererrorCode = "A generic error has occured";
if(registererror==null)
{
	registererrors = false;
}
else
{
	if(registererror.compareTo("1")==0){registererrorCode="LDAP Authentication Failed";}
	if(registererror.compareTo("2")==0){registererrorCode="Cloud/Ldap mismatch - please try again";}
	if(registererror.compareTo("3")==0){registererrorCode="Cloud login failure";}
	if(registererror.compareTo("4")==0){registererrorCode="Username/Password does not exist";}
	if(registererror.compareTo("5")==0){registererrorCode="Blank Username/Password Submitted";}
	if(registererror.compareTo("6")==0){registererrorCode="Blank Username/Password Submitted";}
	if(registererror.compareTo("7")==0){registererrorCode="Cloud Authentication failure";}
	if(registererror.compareTo("8")==0){registererrorCode="Ldap Authentication failure";}
	if(registererror.compareTo("9")==0){registererrorCode="Cloud persistant storage failure";}
	if(registererror.compareTo("10")==0){registererrorCode="Ldap persistant storage failure";}
	if(registererror.compareTo("11")==0){registererrorCode="We could not retrieve your Serial Number: you dont have one";}
	if(registererror.compareTo("12")==0){registererrorCode="Invalid e-mail address";}
	if(registererror.compareTo("13")==0){registererrorCode="Email address already registered";}
	
	String originalUri = (String)request.getAttribute(RequestDispatcher.FORWARD_REQUEST_URI);
	logger.error("Register error: "+errorCode+ " for page: " + originalUri+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());

}


if (request.getSession() != null)
{
	HttpSession ses = request.getSession();
	if(SessionValidator.validate(ses))
	{
		response.sendRedirect("dashboard.jsp");
	}
}


%>

<!DOCTYPE html>
<html>
<head>
<title>Cyber Awareness Platform</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/beta/w3.css">
<link rel="stylesheet" href="css/beta/overRides.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">

<style>

</style>
</head>
<body>

<div class="bgimg w3-display-container w3-animate-opacity w3-text-white">
  <div class="w3-display-topleft w3-padding-large w3-xlarge">
    CAP
  </div>
   <div class="w3-display-topright w3-padding-large w3-xlarge">
    <a href="register.jsp">REGISTER</a>
  </div>
  <div class="w3-display-middle">
    <h1 class="w3-jumbo w3-animate-top">Cyber Awareness Platform</h1>
    <hr class="w3-border-grey" style="margin:auto;width:40%">
    <p class="w3-large w3-center">
    
    		<div>
			  <form method="POST"  action="Login">
			    <label for="login">Email</label>
			    <input type="text" id="login" name="login" placeholder="Your name">
			
			    <label for="password">Password</label>
			    <p></p>
			    <input type="password" id="password" name="password" placeholder="Your password">
			<p></p>
			    <label for="faction">Faction</label>
			    <select id="faction" name="faction">
			    <option selected=true disabled>Select a Faction</option>
			      <option value="unknown">unknown</option>
			      <option value="open">open</option>
			      <option value="private">private</option>
			    </select>
			  	<%
					if(errors)
					{
						%>
						<br><%=errorCode%>
						<%
					}
				%>
			    <input type="submit" value="Submit">
			  </form>
			</div>
    </p>
    
  </div>
  <div class="w3-display-bottomleft w3-padding-large">
    Powered by <a href="" target="_blank">OpenSource</a>
  </div>
</div>

</body>
</html>



