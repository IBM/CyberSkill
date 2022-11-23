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
<h1  class="title">Steganography 2</h1>
<p class="levelText">This is a stegonagraphy challenge. Steganography is the art of covered or hidden writing. The purpose of steganography is covert communication-to hide the existence of a message from a third party. To pass this challenge find the hidden message concealed within the image.
<br>If you would like to read more about stegonagraphy you can do so <a href="https://en.wikipedia.org/wiki/Steganography" target="_blank">here</a>.
</p>
<em class="formLabel">Download this zip and find the hidden message.<a href="Steganography 2/questionmark.zip">Click to Download</a></em>
<% /* Common Solution */ String uri = request.getRequestURI();String level = uri.substring(uri.lastIndexOf("/")+1);%>
<form id="solutionInput" ACTION="javascript:;" method="POST"><em class="formLabel">Solution Key: </em>
<input id="key" name="key" type='text' autocomplete="off"><input type="submit" value="Submit"><input type="hidden" id ="level" name="level" value="<%=  java.net.URLDecoder.decode(level, "UTF-8").substring(0, java.net.URLDecoder.decode(level, "UTF-8").length()-4) %>"></form>
<div id="solutionSubmitResults"></div>
<% /* Common Footer */ %>
<jsp:include page="../levelBottom.jsp" /> <% //Level Bottom Entry %>
</body></html>
<% } else { %>
You are not currently signed in. Please Sign in<% } %>
