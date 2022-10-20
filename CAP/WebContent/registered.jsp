<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java"  errorPage="" %>
<%@ page import="utils.PropertiesReader"%>
<%@ page import="java.util.Properties, utils.*"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>

<%-- Get a reference to the logger for this class --%>
<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>



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
   <a href="index.jsp">LOGIN</a>
  </div>
  <div class="w3-display-middle">
    <h1 class="w3-jumbo w3-animate-top">Cyber Awareness Platform</h1>
    <hr class="w3-border-grey" style="margin:auto;width:40%">
    <p class="w3-large w3-center">
  <div>
  <section class="banner">
			<article class="signup">
		
				<h1>Congratulations</h1>
				<h1>You have successfully signed up for the Cyber Awareness Platform</h1>
				<h1>Your account will be activated by an admin shortly</h1>
				<h1>Please follow the login link to access your account</h1>
				
			</article>
		</section></div>
  <div class="w3-display-bottomleft w3-padding-large">
    Powered by <a href="" target="_blank">OpenSource</a>
  </div>
</div>

</body>
</html>



