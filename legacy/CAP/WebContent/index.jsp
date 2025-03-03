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


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Cyber Awareness Platform (CAP)</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/global.css" rel="stylesheet" type="text/css" media="screen" />
	<link href="css/theResponsiveCss.css" rel="stylesheet" type="text/css" media="screen">
</head>
<body>
	<script type="text/javascript" src="js/jquery-2.1.1.min.js"></script>
		<div class="index-contain"> 
		<header>
			<h1><span>Login to</span> CAP</h1>
			<form name="loginForm" method="POST" action="Login">
				<input type="text" class="text-input" name="login" value="" placeholder="Username / Email" autocomplete="OFF" autofocus />
				<input type="password" class="text-input" name="pwd" placeholder="Password" autocomplete="OFF" />
				<input type="submit" class="submit" name="loginButton" value="Sign In" />
				<%
					if(errors)
					{
						%>
						<br><%=errorCode%>
						<%
					}
				%>
			</form>
			
		</header>
		<footer onclick="window.location.href = 'https://www.youtube.com/watch?v=2Q_ZzBGPdqE';">Problems? Click here to access the support forum</footer>
		</div>
	
</body>
</html>
