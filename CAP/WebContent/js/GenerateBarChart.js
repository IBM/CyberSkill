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
		    .attr("align-content","center")
		    .attr("display", "block")
		  .append("g")
		    .attr("transform", 
		          "translate(" + margin.left + "," + margin.top + ")");

		
		d3.json("getAllScoresByMyFaction", function(error, data)
		{
		  // Format data
		  data.forEach(function(d) 
		  {
		    d.sum = +d.sum;
		  });

		  // Scale the range of the data in the domains
		  x.domain(data.map(function(d) { return d.username; }));
		  
		  y.domain([0, d3.max(data, function(d) { return d.sum; })]);

		  // Append rectangles for bar chart
		  svg.selectAll(".bar")
		      .data(data)
		    .enter().append("rect")
		      .attr("class", "bar")
		      .attr("x", function(d) { return x(d.username); })
		      .attr("width", x.bandwidth())
		      .attr("y", function(d) { return y(d.sum); })
		      .attr("height", function(d) { return height - y(d.sum); });

		  // Add x axis
		  svg.append("g")
		      .attr("transform", "translate(0," + height + ")")
		      .call(d3.axisBottom(x));

		  // Add y axis
		  svg.append("g")
		      .call(d3.axisLeft(y));

		});
		
		
		
		
				}