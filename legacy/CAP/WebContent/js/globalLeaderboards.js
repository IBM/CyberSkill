//
//Listeners
//
function loadLeaderBoardsData() {
	
	var topGraphDiv = $("#"+"leaderboardTopGraphDiv"),
		playerGraphDiv = $("#"+"leaderboardPlayerGraphDiv");
	
	//creatLeaderBoardChart({},topGraphDiv,"Top Players");
	//creatLeaderBoardChart({},playerGraphDiv,"Your Position");

	Chart_AJAX.getGlobalTopPlayerScores();
	Chart_AJAX.getGlobalSimilarPlayerScores();
}


var Chart_AJAX = {

		//********* GETs ************
		getGlobalTopPlayerScores: function() {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "moduleFeed?operation=getGlobalTopPlayerScores", true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						var json = jQuery.parseJSON(xmlhttp.responseText);
						
						var topGraphDiv = $("#"+"leaderboardTopGraphDiv");
						createLeaderBoardChart(json,topGraphDiv,"Top Players");					

					} else {//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
		
		//********* GETs ************
		getGlobalSimilarPlayerScores: function() {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "moduleFeed?operation=getGlobalSimilarPlayerScores", true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
						var json = jQuery.parseJSON(xmlhttp.responseText);
						
						var playerGraphDiv = $("#"+"leaderboardPlayerGraphDiv");
						createLeaderBoardChart(json,playerGraphDiv,"Similar Players");

					} else {//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
		
}


function createLeaderBoardChart(json,div,title) {
	
	var chartListSection = $("#"+"chartListSection"), 
		userArray = [],
		scoreArray = [];


	$(json.Scores).each(function() {
		userArray.push(this.username);
		if(this.currentUser !== undefined) {
			console.log("Current user found");
			scoreArray.push({ 'y' : this.score, 'borderColor' : 'red', 'borderWidth' : 2});	
		} else {
			scoreArray.push(this.score);				
		}
		
	});
	
	
	console.log(userArray);
	console.log(scoreArray);

	buildUserScoreBarChart(div,userArray,scoreArray,chartListSection,title);
	
}