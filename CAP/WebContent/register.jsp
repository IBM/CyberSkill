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

String registererror = request.getParameter("response");
boolean registererrors = true;
String registererrorCode = "OK";
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
		response.sendRedirect("index.jsp");
	}
}
String firstname=request.getParameter("firstname");
String lastname=request.getParameter("lastname");
String institution=request.getParameter("institution");
String status=request.getParameter("status");
String faction=request.getParameter("faction");
String email=request.getParameter("email");
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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">

</head>
<body>

<div class="bgimg w3-display-container w3-animate-opacity w3-text-white">
  <div class="w3-display-topleft w3-padding-large w3-xlarge">
   <a href="index.jsp">LOGIN</a>
  </div>
  <div class="w3-display-middle">
    <h1 class="w3-jumbo w3-animate-top">Cyber Awareness Platform</h1>
    <hr class="w3-border-grey" style="margin:auto;width:40%">
    <p class="w3-large w3-center">
  <div>
  <section class="banner">
			<article class="signup">
				<%
					Properties siteProperties = PropertiesReader.readSiteProperties();
					String authType = siteProperties.getProperty("authentication");
					String localAuthenticationProperty = new String("local");
					if(authType.equalsIgnoreCase(localAuthenticationProperty))
					{
				%>
				<h1>Sign Up</h1>
				<p>It's Free</p>
				
				<form name="signupForm" method="POST" action="register">
				
					<input class="su-text-input" type="text" name="firstName" id="firstName" autocomplete="OFF" placeholder="<%if(firstname == null || firstname.compareToIgnoreCase("")==0){out.print("First Name");}else{out.print(firstname);}%>"/>
					<input class="su-text-input" type="text" name="lastName" id="lastName" autocomplete="OFF" placeholder="<%if(lastname == null || lastname.compareToIgnoreCase("")==0){out.print("Last Name");}else{out.print(lastname);}%>"/>	
					<input class="su-text-input" type="text" name="faction" id="faction" autocomplete="OFF" placeholder="<%if(faction == null || faction.compareToIgnoreCase("")==0){out.print("Faction");}else{out.print(faction);}%>"/>
					<select id="status" name="status">
			    <option selected=true disabled><%if(status == null || status.compareToIgnoreCase("")==0){out.print("Select current status");}else{out.print(status);}%></option>
			      <option value="student">Student</option>
			      <option value="Professional">Professional</option>
			    </select>	
					<input class="su-text-input" type="text" name="institution" id="institution" autocomplete="OFF" placeholder="<%if(institution == null || institution.compareToIgnoreCase("")==0){out.print("Institution");}else{out.print(institution);}%>"/>					
					<input class="su-text-input" type="text" name="userAddress" id="userAddress" autocomplete="OFF" placeholder="<%if(email == null || email.compareToIgnoreCase("")==0){out.print("Email");}else{out.print(email);}%>"/>
					<input class="su-text-input" type="passWord" name="passWord" id="passWord" autocomplete="OFF" placeholder="Password"/>
					<input class="su-text-input" type="password" name="passWordConfirm" id="passWordConfirm" autocomplete="OFF" placeholder="Confirm Password"/>
					<br>
   
	 <input type="submit" name="submit" value="Sign up!"/>
					<%
						if(registererrors)
						{
							%>
							<br><%=registererrorCode%>
							<%
						}
					%>
				</form>
				<% } %>
			</article>
		</section></div>
		
	
  <div class="w3-display-bottomleft w3-padding-large">
    Powered by <a href="" target="_blank">OpenSource</a>
  </div>
</div>

	<div id="id01" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-red"> 
	        <span onclick="document.getElementById('id01').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Registration result</h2>
	      </header>
	      <div class="w3-container">
	        <p>Registration Status: <%=registererrorCode%></p>
	      </div>
	      <footer class="w3-container w3-red">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>



</body>
<!-- 
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
-->
</html>
<%
if(registererror != null)
{
	%>
		<script>
			document.getElementById('id01').style.display='block';
		</script>
	<%
}
%>

