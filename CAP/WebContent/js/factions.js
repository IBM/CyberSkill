function loadFactionData() {
	
	Faction_AJAX.getAllFactions();
}

var Faction_AJAX = {

//********* GETs ************//
		getAllFactions: function() {

			function createRequest() {
				var xmlhttp = new XMLHttpRequest();		
				xmlhttp.onreadystatechange = callback;
				xmlhttp.open("GET", "getAllFactions", true);
				xmlhttp.send(null);

				function callback() {

					if (xmlhttp.readyState == 4 && xmlhttp.status == 200) 
					{			
					 console.log("Resposne is 200")
						console.log(jQuery.parseJSON(xmlhttp.responseText));
					}
					else 
					{//need to fix this
						//alert(xmlhttp.readyState+" "+xmlhttp.status)
					}
				}				
			}
			createRequest();
		},
}