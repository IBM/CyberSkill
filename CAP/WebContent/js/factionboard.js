//
//Listeners
//
function loadFactionBoardData(factionName) {
	
	var factionboardGraphDiv = $("#"+"factionboardGraphDiv");
	
	//creatLeaderBoardChart({},topGraphDiv,"Top Players");
	//creatLeaderBoardChart({},playerGraphDiv,"Your Position");

	Chart_AJAX.getAllScoresAggregatedByFaction();
	Chart_AJAX.getTextFactionScores(factionName)
}



var Chart_AJAX = {

		//********* GETs ************
		getAllScoresAggregatedByFaction: function() {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "getAllScoresAggregatedByFaction", true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) 
					{
						var json = jQuery.parseJSON(xmlhttp.responseText);
						
						var factionboardGraphDiv = $("#"+"factionboardGraphDiv");
						
						createLeaderBoardChart(json,factionboardGraphDiv,"Top Factions");					

					}
					else 
					{//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
		//********* GETs ************
		getTextFactionScores: function(labels) {
			console.log(`the label is ${labels}`)
			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "getAllScoresInAFactionByUsername?username="+labels, true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) 
					{
						var json = jQuery.parseJSON(xmlhttp.responseText);
						
						var teamStats = $("#"+"playerTeamStats");

						createTeamStats(json, teamStats);
					}
					else 
					{//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
		getAllScoresByFaction: function(labels) {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "getAllScoresByFaction?faction="+labels, true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) 
					{
						var json = jQuery.parseJSON(xmlhttp.responseText);
					
						console.log("DATA: " + json);
						
					}
					else 
					{//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
		//********* GETs ************
		getAllScoresByUsername: function(labels) {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "getAllScoresByUsername?username="+labels, true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) 
					{
						var json = jQuery.parseJSON(xmlhttp.responseText);
						
						var factionboardGraphDiv = $("#"+"factionboardGraphDiv");
						
						console.log("DATA ->: ");
						console.log(json);
						
						createPlayerLineChart(json,factionboardGraphDiv,"Player Breakdown");					

					}
					else 
					{//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		}		
		
}

function randomIntFromInterval(min, max) 
{ 
	  return Math.floor(Math.random() * (max - min + 1) + min)
}


function returnColumnBackgroundColor()
{
	const rndInt1 = randomIntFromInterval(1, 255);
	const rndInt2 = randomIntFromInterval(1, 255);
	const rndInt3 = randomIntFromInterval(1, 255);
	
	var tmp = "rgba("+rndInt1+", "+rndInt2+", "+rndInt3+", 0.2)";
	
	return tmp;

}

function returnColumnBorderColor()
{
	const rndInt1 = randomIntFromInterval(1, 255);
	const rndInt2 = randomIntFromInterval(1, 255);
	const rndInt3 = randomIntFromInterval(1, 255);
	
	var tmp = "rgba("+rndInt1+", "+rndInt2+", "+rndInt3+")";
	
	return tmp;

}

function graphClickEvent(event, array){
    if(array[0])
    {
    	console.log(array[0]);
        
       var index = array[0].index;
       console.log("datasetIndex:"+index)
       var labels = this.data.labels[index];
       var values = this.data.datasets[0].data[index];
       console.log("labels: " + labels);
       console.log("values: " + values);
       
       Chart_AJAX.getAllScoresByFaction(labels);
    }
}

function graphPlayerTimeLine(event, array){
    if(array[0])
    {
    	console.log(array[0]);
        
       var index = array[0].index;
       console.log("datasetIndex:"+index)
       var labels = this.data.labels[index];
       var values = this.data.datasets[0].data[index];
       console.log("labels: " + labels);
       console.log("values: " + values);
       
       Chart_AJAX.getAllScoresByUsername(labels);
    }
}

function createTeamStats(json,div,title) 
{
	const capitalize = (text) => text.charAt(0).toUpperCase() + text.substring(1);
	const container = document.getElementById("playerTeamStats");

	const totalFactionScore = json.reduce((partial_sum, a) => partial_sum + parseInt(a.sum), 0);

	const teamScore = document.getElementById("teamScore");
	const teamName = document.getElementById("teamName");
	const teamMembers = document.getElementById("teamMembers");
	var player = [];
	const players = document.createElement("div");

	const name = document.createElement("h2");
	name.appendChild(document.createTextNode(json[0].faction));

	const score = document.createElement("h2");
	score.appendChild(document.createTextNode(totalFactionScore.toString()));

	json.forEach(mem => player.push(`<span class="player-stat">\
		<span>${capitalize(mem.username.split('@')[0])}</span>\
		<span>${mem.sum}</span>\
	</span>`));
	player.forEach(el => players.insertAdjacentHTML('beforeend', el));

	teamName.appendChild(name);
	teamScore.appendChild(score);
	teamMembers.appendChild(players);
	
}


function createLeaderBoardChart(json,div,title) 
{
	
	var ctx = document.getElementById("factionboardGraphDiv");
	
	var columnBackgroundColors = [];
	var columnBorderColors = [];
	
	var labels = json.map(function(e) {
		   columnBackgroundColors.push(returnColumnBackgroundColor());
		   columnBorderColors.push(returnColumnBorderColor());
		   return e.faction;
		});
	var scores = json.map(function(e) {
		   return e.total;
		});;
	
	
	const options = {onClick: graphClickEvent};
	const data = {
	  labels: labels,
	  datasets: [{
	    label: 'Faction Performance',
	    data: scores,
	    backgroundColor:columnBackgroundColors,
	    borderColor: columnBorderColors,
	    borderWidth: 1
	  }]
	};
	
	var myBarChart = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: options
	});	
}

function createFactionPlayerChart(json,div,title) 
{
	console.log(json);
	var ctx = document.getElementById("factionboardGraphDiv");
	
	var columnBackgroundColors = [];
	var columnBorderColors = [];
	
	var labels = json.map(function(e) {
		   columnBackgroundColors.push(returnColumnBackgroundColor());
		   columnBorderColors.push(returnColumnBorderColor());
		   return e.username;
		});
	var scores = json.map(function(e) {
		   return e.sum;
		});;
	
	
	const options = {onClick: graphPlayerTimeLine};
	const data = {
	  labels: labels,
	  datasets: [{
	    label: 'Faction Performance',
	    data: scores,
	    backgroundColor:columnBackgroundColors,
	    borderColor: columnBorderColors,
	    borderWidth: 1
	  }]
	};
	
	Chart.instances[Chart.instances[0].id].destroy()
	
	var myBarChart = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: options
	});
	
	
	
}

function createPlayerLineChart(json,div,title) 
{
	
	var ctx = document.getElementById("factionboardGraphDiv");
	
	var columnBackgroundColors = [];
	var columnBorderColors = [];
	var hold = 0;
	var labels = json.map(function(e) {
		   columnBackgroundColors.push(returnColumnBackgroundColor());
		   columnBorderColors.push(returnColumnBorderColor());
		   return e.submitted;
		});
	var scores = json.map(function(e) {
		   	hold = +hold + +e.score;
		   	console.log("hold: " + hold);
			return hold;
		});;
	
	
	const options = {};
	const data = {
	  labels: labels,
	  datasets: [{
	    label: 'Player Performance',
	    data: scores,
	    backgroundColor:columnBackgroundColors,
	    borderColor: columnBorderColors,
	    borderWidth: 1
	  }]
	};
	
	console.log(Chart.instances);
	
	Chart.instances[Chart.instances[1].id].destroy()
	
	var myLineChart = new Chart(ctx, {
	    type: 'line',
	    data: data,
	    options: options
	});
	
	
	
}