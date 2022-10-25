<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" import="utils.*" errorPage="" %>
<%@ page import="java.util.Properties"%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="utils.JWT"%>
<%@ page import="io.jsonwebtoken.Claims"%>


<%-- Get a reference to the logger for this class --%>
<% Logger logger  = LoggerFactory.getLogger( this.getClass(  ) ); %>

<%
 
if (request.getSession() == null)
{
	StringBuffer requestURL = request.getRequestURL();
	if (request.getQueryString() != null) {
	    requestURL.append("?").append(request.getQueryString());
	}
	String completeURL = requestURL.toString();
	logger.error("Attempt to access a page without a session:" + completeURL+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
	response.sendRedirect("index.jsp");
}
else
{
	StringBuffer requestURL = request.getRequestURL();
	if (request.getQueryString() != null) {
	    requestURL.append("?").append(request.getQueryString());
	}
	String completeURL = requestURL.toString();
	
	HttpSession ses = request.getSession();
	if(!SessionValidator.validate(ses))
	{
		logger.error("Attempt to access a page without an valid session:" + completeURL+" Submitter IP: " + request.getHeader("X-FORWARDED-FOR") + " Submitter IP no proxy: " + request.getRemoteAddr());
		response.sendRedirect("index.jsp");
	} 
	else
	{
	JWT jwt = new JWT();
	String JWT_session = ses.getAttribute("JWT").toString();
	logger.debug("JWT_session: " + JWT_session);
	Claims claim = jwt.decodeJWT(JWT_session);
	logger.debug("username: " + claim.get("username"));	
%>
	<!DOCTYPE html>
	<html>
	<head>
	<title>Cyber Awareness Platform - Dashboard</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/beta/w3.css">
	<link rel="stylesheet" href="css/beta/overRideDashBoard.css">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="https://d3js.org/d3.v4.js"></script>
	
	
	<script>
	function genenerateScatterChart()
	{
		// Set Dimensions
		const xSize = 500; 
		const ySize = 250;
		const margin = 20;
		const xMax = xSize - margin*2;
		const yMax = ySize - margin*2;
		
		// Create Random Points
		const numPoints = 100;
		const data = [];
		for (let i = 0; i < numPoints; i++) {
		  data.push([Math.random() * xMax, Math.random() * yMax]);
		}
		
		// Append SVG Object to the Page
		const svg = d3.select("#myPlot")
		  .append("svg")
		  .append("g")
		  .attr("transform","translate(" + margin + "," + margin + ")");
		
		// X Axis
		const x = d3.scaleLinear()
		  .domain([0, 500])
		  .range([0, xMax]);
		
		svg.append("g")
		  .attr("transform", "translate(0," + yMax + ")")
		  .call(d3.axisBottom(x));
		
		// Y Axis
		const y = d3.scaleLinear()
		  .domain([0, 500])
		  .range([ yMax, 0]);
		
		svg.append("g")
		  .call(d3.axisLeft(y));
		
		// Dots
		svg.append('g')
		  .selectAll("dot")
		  .data(data).enter()
		  .append("circle")
		  .attr("cx", function (d) { return d[0] } )
		  .attr("cy", function (d) { return d[1] } )
		  .attr("r", 3)
		  .style("fill", "Red");
	}
	</script>
	
	
	<script>
	function genenerateBarChart()
	{
		// Set graph margins and dimensions
		var margin = {top: 20, right: 20, bottom: 30, left: 40},
		    width = 600 - margin.left - margin.right,
		    height = 500 - margin.top - margin.bottom;

		// Set ranges
		var x = d3.scaleBand()
		          .range([0, width])
		          .padding(0.1);
		var y = d3.scaleLinear()
		          .range([height, 0]);
		var svg = d3.select("#myFactionScore").append("svg")
		    .attr("width", width + margin.left + margin.right)
		    .attr("height", height + margin.top + margin.bottom)
		    .attr("align","center")
		  .append("g")
		    .attr("transform", 
		          "translate(" + margin.left + "," + margin.top + ")");

		// Get data
		d3.csv("XYZ.csv", function(error, data){

		  // Format data
		  data.forEach(function(d) 
		  {
		    d.value = +d.value;
		  });

		  // Scale the range of the data in the domains
		  x.domain(data.map(function(d) { return d.year; }));
		  y.domain([0, d3.max(data, function(d) { return d.value; })]);

		  // Append rectangles for bar chart
		  svg.selectAll(".bar")
		      .data(data)
		    .enter().append("rect")
		      .attr("class", "bar")
		      .attr("x", function(d) { return x(d.year); })
		      .attr("width", x.bandwidth())
		      .attr("y", function(d) { return y(d.value); })
		      .attr("height", function(d) { return height - y(d.value); });

		  // Add x axis
		  svg.append("g")
		      .attr("transform", "translate(0," + height + ")")
		      .call(d3.axisBottom(x));

		  // Add y axis
		  svg.append("g")
		      .call(d3.axisLeft(y));

		});
		
		
		
		
				}
</script>
	
	
	</head>
	<body class="w3-light-grey">
	
	 <div id="id01" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-red"> 
	        <span onclick="document.getElementById('id01').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Faction Chat</h2>
	      </header>
	      <div class="w3-container">
	        <p>This is faction chat, this feature allows teams to talk to each other and solve challenges co-operatively</p>
	        <p>This feature is coming soon!</p>
	      </div>
	      <footer class="w3-container w3-red">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
  	
  	 <div id="id02" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-blue"> 
	        <span onclick="document.getElementById('id02').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Scoreboard</h2>
	      </header>
	      <div class="w3-container">
	        <p>Some text..</p>
	        <p style="fill: steelblue;  align-content: center;"> <svg id="myFactionScore" style="width:600px; height:500px;"></svg></p>
	      </div>
	      <footer class="w3-container w3-blue">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
  	
  	 <div id="id03" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-teal"> 
	        <span onclick="document.getElementById('id03').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Challenges</h2>
	      </header>
	      <div class="w3-container">
	        <p>Some text..</p>
	        <p>Some text..</p>
	      </div>
	      <footer class="w3-container w3-teal">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
  	
  	 <div id="id04" class="w3-modal">
	    <div class="w3-modal-content w3-animate-top w3-card-4">
	      <header class="w3-container w3-orange"> 
	        <span onclick="document.getElementById('id04').style.display='none'" 
	        class="w3-button w3-display-topright">&times;</span>
	        <h2>Users</h2>
	      </header>
	      <div class="w3-container">
	        <p>Some text..</p>
	        <p>Some text..</p>
	      </div>
	      <footer class="w3-container w3-orange">
	        <p>Powered by OpenSource</p>
	      </footer>
	    </div>
  	</div>
	
	
	
	
	
	
	
	<!-- Top container -->
	<div class="w3-bar w3-top w3-black w3-large" style="z-index:4">
	  <button class="w3-bar-item w3-button w3-hide-large w3-hover-none w3-hover-text-light-grey" onclick="w3_open();"><i class="fa fa-bars"></i>  Menu</button>
	   <jsp:include page="dashboard_header.jsp" />
	</div>
	
	<!-- Sidebar/menu -->
	<nav class="w3-sidebar w3-collapse w3-white w3-animate-left" style="z-index:3;width:300px;" id="mySidebar"><br>
	  <div class="w3-container w3-row">
	    <div class="w3-col s4">
	      <img src="css/images/beta/avatars/avatar2.png" class="w3-circle w3-margin-right" style="width:46px">
	    </div>
	    <div class="w3-col s8 w3-bar">
	      <span>Welcome, <strong><%=claim.get("username")%></strong></span><br>
	      <a href="#" class="w3-bar-item w3-button"><i class="fa fa-envelope"></i></a>
	      <a href="#" class="w3-bar-item w3-button"><i class="fa fa-user"></i></a>
	      <a href="#" class="w3-bar-item w3-button"><i class="fa fa-cog"></i></a>
	    </div>
	  </div>
	  <hr>
	  <div class="w3-container">
	    <h5>Dashboard</h5>
	  </div>
	  <div class="w3-bar-block">
	    <a href="#" class="w3-bar-item w3-button w3-padding-16 w3-hide-large w3-dark-grey w3-hover-black" onclick="w3_close()" title="close menu"><i class="fa fa-remove fa-fw"></i>  Close Menu</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding w3-blue" ><i class="fa fa-users fa-fw"></i>  Overview</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById('id01').style.display='block'"><i class="fa fa-eye fa-fw"></i>  Faction Chat</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById('id02').style.display='block'"><i class="fa fa-users fa-fw"></i>  Scoreboard</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById('id03').style.display='block'"><i class="fa fa-bullseye fa-fw"></i>  Challenges</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById('id04').style.display='block'"><i class="fa fa-diamond fa-fw"></i>  Users</a>
	    <a href="#" class="w3-bar-item w3-button w3-padding"><i class="fa fa-cog fa-fw"></i>  Settings</a><br><br>
	  </div>
	</nav>
	
	
	<!-- Overlay effect when opening sidebar on small screens -->
	<div class="w3-overlay w3-hide-large w3-animate-opacity" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div>
	
	<!-- !PAGE CONTENT! -->
	<div class="w3-main" style="margin-left:300px;margin-top:43px;">
	
	  <!-- Header -->
	  <header class="w3-container" style="padding-top:22px">
	    <h5><b><i class="fa fa-dashboard"></i> My Dashboard</b></h5>
	  </header>
	
	  <div class="w3-row-padding w3-margin-bottom">
	    <div class="w3-quarter" onclick="document.getElementById('id01').style.display='block'">
	      <div class="w3-container w3-red w3-padding-16">
	        <div class="w3-left"><i class="fa fa-comment w3-xxxlarge"></i></div>
	        <div class="w3-right">
	          <h3>52</h3>
	        </div>
	        <div class="w3-clear"></div>
	        <h4>Faction Chat</h4>
	      </div>
	    </div>
	    <div class="w3-quarter" onclick="document.getElementById('id02').style.display='block'">
	      <div class="w3-container w3-blue w3-padding-16">
	        <div class="w3-left"><i class="fa fa-eye w3-xxxlarge"></i></div>
	        <div class="w3-right">
	          <h3>99</h3>
	        </div>
	        <div class="w3-clear"></div>
	        <h4>Scoreboard</h4>
	      </div>
	    </div>
	    <div class="w3-quarter" onclick="document.getElementById('id03').style.display='block'" >
	      <div class="w3-container w3-teal w3-padding-16">
	        <div class="w3-left"><i class="fa fa-share-alt w3-xxxlarge"></i></div>
	        <div class="w3-right">
	          <h3>23</h3>
	        </div>
	        <div class="w3-clear"></div>
	        <h4>Challenges</h4>
	      </div>
	    </div>
	    <div class="w3-quarter" onclick="document.getElementById('id04').style.display='block'">
	      <div class="w3-container w3-orange w3-text-white w3-padding-16">
	        <div class="w3-left"><i class="fa fa-users w3-xxxlarge"></i></div>
	        <div class="w3-right">
	          <h3>50</h3>
	        </div>
	        <div class="w3-clear"></div>
	        <h4>Users</h4>
	      </div>
	    </div>
	  </div>
	
	  <div class="w3-panel">
	    <div class="w3-row-padding" style="margin:0 -16px">
	      <div class="w3-third">
	        <h5>Performance Data</h5>
	        <svg id="myPlot" style="width:100%; height:250px;"></svg>
	      </div>
	      <div class="w3-twothird">
	        <h5>Open Challenges</h5>
	        <table class="w3-table w3-striped w3-white">
	          <tr>
	            <td><i class="fa fa-user w3-text-blue w3-large"></i></td>
	            <td>New record, over 90 views.</td>
	            <td><i>10 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-bell w3-text-red w3-large"></i></td>
	            <td>Database error.</td>
	            <td><i>15 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-users w3-text-yellow w3-large"></i></td>
	            <td>New record, over 40 users.</td>
	            <td><i>17 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-comment w3-text-red w3-large"></i></td>
	            <td>New comments.</td>
	            <td><i>25 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-bookmark w3-text-blue w3-large"></i></td>
	            <td>Check transactions.</td>
	            <td><i>28 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
	            <td>CPU overload.</td>
	            <td><i>35 mins</i></td>
	          </tr>
	          <tr>
	            <td><i class="fa fa-share-alt w3-text-green w3-large"></i></td>
	            <td>New shares.</td>
	            <td><i>39 mins</i></td>
	          </tr>
	        </table>
	      </div>
	    </div>
	  </div>
	  <hr>
	  <div class="w3-container">
	    <h5>Faction Data</h5>
	    <p>Challenges Solved</p>
	    <div class="w3-grey">
	      <div class="w3-container w3-center w3-padding w3-green" style="width:25%">+25%</div>
	    </div>
	
	    <p>Challenges Open</p>
	    <div class="w3-grey">
	      <div class="w3-container w3-center w3-padding w3-orange" style="width:50%">50%</div>
	    </div>
	
	    <p>Incorrect Submissions</p>
	    <div class="w3-grey">
	      <div class="w3-container w3-center w3-padding w3-red" style="width:75%">75%</div>
	    </div>
	  </div>
	  <hr>
	
	  <div class="w3-container">
	    <h5>Faction Player First Solve</h5>
	    <table class="w3-table w3-striped w3-bordered w3-border w3-hoverable w3-white">
	      <tr>
	        <td>John Doe</td>
	        <td>65%</td>
	      </tr>
	      <tr>
	        <td>Jane Doe</td>
	        <td>15.7%</td>
	      </tr>
	      <tr>
	        <td>Blink 182</td>
	        <td>5.6%</td>
	      </tr>
	      <tr>
	        <td>Jeremy Jones</td>
	        <td>2.1%</td>
	      </tr>
	      <tr>
	        <td>John Clarke</td>
	        <td>1.9%</td>
	      </tr>
	      <tr>
	        <td>Jason Flood</td>
	        <td>1.5%</td>
	      </tr>
	    </table><br>
	    <button class="w3-button w3-dark-grey">More Player Data<i class="fa fa-arrow-right"></i></button>
	  </div>
	  <hr>
	  <div class="w3-container">
	    <h5>Recent Faction Logins</h5>
	    <ul class="w3-ul w3-card-4 w3-white">
	      <li class="w3-padding-16">
	        <img src="css/images/beta/avatars/avatar1.png" class="w3-left w3-circle w3-margin-right" style="width:35px">
	        <span class="w3-xlarge">Mike</span><br>
	      </li>
	      <li class="w3-padding-16">
	        <img src="css/images/beta/avatars/avatar3.png" class="w3-left w3-circle w3-margin-right" style="width:35px">
	        <span class="w3-xlarge">Jill</span><br>
	      </li>
	      <li class="w3-padding-16">
	        <img src="css/images/beta/avatars/avatar5.png" class="w3-left w3-circle w3-margin-right" style="width:35px">
	        <span class="w3-xlarge">Jane</span><br>
	      </li>
	    </ul>
	  </div>
	  <hr>
	
	  <div class="w3-container">
	    <h5>Recent Faction Comments</h5>
	    <div class="w3-row">
	      <div class="w3-col m2 text-center">
	        <img class="w3-circle" src="css/images/beta/avatars/avatar2.png" style="width:96px;height:96px">
	      </div>
	      <div class="w3-col m10 w3-container">
	        <h4>John <span class="w3-opacity w3-medium">Sep 29, 2014, 9:12 PM</span></h4>
	        <p>Keep up the GREAT work! I am cheering for you!! Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><br>
	      </div>
	    </div>
	
	    <div class="w3-row">
	      <div class="w3-col m2 text-center">
	        <img class="w3-circle" src="css/images/beta/avatars/avatar5.png" style="width:96px;height:96px">
	      </div>
	      <div class="w3-col m10 w3-container">
	        <h4>Bo <span class="w3-opacity w3-medium">Sep 28, 2014, 10:15 PM</span></h4>
	        <p>Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p><br>
	      </div>
	    </div>
	  </div>
	  <br>
	  <div class="w3-container w3-dark-grey w3-padding-32">
	    <div class="w3-row">
	      <div class="w3-container w3-third">
	        <h5 class="w3-bottombar w3-border-green">OWASP</h5>
	        <p>About</p>
	        <p>Location</p>
	        <p>Getting Involved</p>
	      </div>
	      <div class="w3-container w3-third">
	        <h5 class="w3-bottombar w3-border-red">Sans</h5>
	        <p>About</p>
	        <p>Location</p>
	        <p>Getting Involved</p>
	      </div>
	      <div class="w3-container w3-third">
	        <h5 class="w3-bottombar w3-border-orange">Honeynet</h5>
	        <p>About</p>
	        <p>Location</p>
	        <p>Getting Involved</p>
	      </div>
	    </div>
	  </div>
	
	  <!-- Footer -->
	  <footer class="w3-container w3-padding-16 w3-light-grey">
	    <h4>FOOTER</h4>
	    <p>Powered by OpenSource</p>
	  </footer>
	
	  <!-- End page content -->
	</div>
	
	<script>
	// Get the Sidebar
	var mySidebar = document.getElementById("mySidebar");
	
	// Get the DIV with overlay effect
	var overlayBg = document.getElementById("myOverlay");
	
	// Toggle between showing and hiding the sidebar, and add overlay effect
	function w3_open() {
	  if (mySidebar.style.display === 'block') {
	    mySidebar.style.display = 'none';
	    overlayBg.style.display = "none";
	  } else {
	    mySidebar.style.display = 'block';
	    overlayBg.style.display = "block";
	  }
	}
	
	// Close the sidebar with the close button
	function w3_close() {
	  mySidebar.style.display = "none";
	  overlayBg.style.display = "none";
	}
	</script>
	
	<script>
	genenerateBarChart();
	genenerateScatterChart();
	
	</script>
	
	
	
	
	</body>
	</html>
		
	<%
	}
}
%>		