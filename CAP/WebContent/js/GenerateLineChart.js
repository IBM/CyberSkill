function genenerateLineChart()
{
// set the dimensions and margins of the graph
var margin = {top: 10, right: 30, bottom: 30, left: 60},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
var svg = d3.select("#my_dataviz")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

//Read the data
d3.json("getMorePlayerData?username=test1@test.com", function(error, data)
{
  // When reading the csv, I must format variables:
  data.forEach(function(d) {
        //d.submitted = dateParser(new Date(d.submitted));
        //console.log("--> " +  d3.timeParse("%Y-%m-%d %H:%M:%S")(d.submitted) +  "value: " + d.score)
  })
}
)}