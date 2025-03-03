/*
 *
 * Phantom script to operate an xss validation system
 *
 */

var system = require("system");
var fs = require("fs");
var webpage = require("webpage");
var webserver = require("webserver");

var DEFAULT_PORT = "8000";
var DEFAULT_TEST_PATH = "tests/";

if (system.args.length === 1) {
	// Run in server mode using the default port
	runServer(DEFAULT_PORT);
} else if (system.args.length == 3) {
	if (system.args[1] === '-p') {
		var port = Number(system.args[2]);
		runServer(port);
	} else if (system.args[1] === '-t') {
		testValidator(system.args[2]);
	} else {
		displayHelp();
	}
} else {
	displayHelp();
}

function displayHelp() {
	console.log("");
	console.log(system.args[0] + " usage:\n");
	console.log("-p <port_num>:\t ([SERVER MODE] port to run server on)");
	console.log("-t <dir_path>:\t ([TEST MODE] directory containing test files)");
	console.log("");
	phantom.exit();
}

function getFilename(path) {
	var lastIndexOf = path.lastIndexOf(fs.separator);

	if (lastIndexOf >= 0) {
		return path.slice(lastIndexOf + 1);
	} else {
		return path;
	}
}

function testValidator(testPath) {
	var totalTests = 0;
	var testsPositive = 0;
	var i;

	console.log("\n");
	console.log("Test Mode (press CTRL+C to exit after tests have run)");
	console.log("=====================================================\n");

	if (testPath.charAt(testPath.length - 1) !== fs.separator) {
		testPath = testPath + fs.separator;
	}

	var testContents = fs.list(testPath);

	console.log(fs.absolute(testPath) + " : found " + testContents.length + " test files\n");

	if (testContents.length === 0) {
		console.log("Nothing to run; exiting...\n");
		phantom.exit();
	}

	for (i = 0; i < testContents.length; i++) {
		var testFilePath = testPath + testContents[i];

		if (fs.isFile(testFilePath)) {
			// Do we want to check testContents[i] against supported file
			// extensions here?

			validateXSS({
				name: getFilename(testFilePath),
				file: testFilePath
			});
		}
	}

	//console.log("\nTests complete [xss/total]: [" + testsPositive + "/" + totalTests + "]\n");
	//console.log("");
}

function runServer(port) {
	var server = webserver.create();

	console.log("\n");
	console.log("Running XSS validation server on port " + port + " (press CTRL+C to quit)");
	console.log("=================================================================");

	var service = server.listen(port, function (request, response) {
		console.log("Received " + request.method + " request; X-Wargames-XSS-Input = " + request.headers["X-Wargames-XSS-Input"]);

		if (request.method !== "POST") {
			response.statusCode = "405";
			response.write("request method " + request.method + " not allowed");
			response.close();
			return;
		}

		//var userInput = request.headers["X-Wargames-XSS-Input"];
		//var outputPattern = request.headers["X-Wargames-XSS-Output"];
		//var pageContent = request.post;

		//pageContent = pageContent.replace(outputPattern, userInput);

		/*
		for (var header in request.headers) {
			console.log(header + " = " + request.headers[header]);
		}

		console.log("\n\n");
		console.log(pageContent);
		*/

		validateXSS({
			name: request.headers["X-Wargames-XSS-Name"],
			input: request.headers["X-Wargames-XSS-Input"],
			output: request.headers["X-Wargames-XSS-Output"],
			source: request.post,
			response: response
		});

		//response.statusCode = 200;
		//response.setHeader("Content-Type", "text/plain");
		//response.write("hello");
		//response.close();
	});
}

function validateXSS(props) {
	var page = webpage.create();
	var xssDetected = false;

	page.onAlert = function (msg) {
		xssDetected = true;
	};
	page.onConsoleMessage = function (msg) {
		xssDetected = true;
	};
	page.onConfirm = function (msg) {
		xssDetected = true;
	};
	page.onPrompt = function (msg) {
		xssDetected = true;
	};

	if (props.file) {
		page.content = fs.read(props.file);

		page.onLoadFinished = function(status) {
			
			// Evaluate page, rendering javascript
			page.evaluate(function (page) {				
		                var tags = ["a", "abbr", "acronym", "address", "applet", "area", "article", "aside", "audio", "audioscope", "b", "base", "basefont", "bdi", "bdo", "bgsound", "big", "blackface", "blink", "blockquote", "body", "bq", "br", "button", "canvas", "caption", "center", "cite", "code", "col", "colgroup", "command", "comment", "datalist", "dd", "del", "details", "dfn", "dir", "div", "dl", "dt", "em", "embed", "fieldset", "figcaption", "figure", "fn", "font", "footer", "form", "frame", "frameset", "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html", "i", "iframe", "ilayer", "img", "input", "ins", "isindex", "kbd", "keygen", "label", "layer", "legend", "li", "limittext", "link", "listing", "map", "mark", "marquee", "menu", "meta", "meter", "multicol", "nav", "nobr", "noembed", "noframes", "noscript", "nosmartquotes", "object", "ol", "optgroup", "option", "output", "p", "param", "plaintext", "pre", "progress", "q", "rp", "rt", "ruby", "s", "samp", "script", "section", "select", "server", "shadow", "sidebar", "small", "source", "spacer", "span", "strike", "strong", "style", "sub", "sup", "table", "tbody", "td", "textarea", "tfoot", "th", "thead", "time", "title", "tr", "tt", "u", "ul", "var", "video", "wbr", "xml", "xmp"];
		                var eventHandler = ["mousemove","mouseout","mouseover"]

		                // Search document for interactive HTML elements, and hover over each
		                // In attempt to trigger event handlers.
		                tags.forEach(function(tag) {
		                        currentTags = document.querySelector(tag);
		                        if (currentTags !== null){
		                                eventHandler.forEach(function(currentEvent){
				                        var ev = document.createEvent("MouseEvents");
		                                        ev.initEvent(currentEvent, true, true);
		                                        currentTags.dispatchEvent(ev);
		                                });
		                        }
		                });
				// Return information from page, if necessary
				return document;
			}, page);
			
			if (status) {
				if (xssDetected) {
					console.log(props.name + "\t: XSS positive!");
				} else {
					console.log(props.name + "\t: XSS negative");
				}
			} else {
				console.log(props.name + "\t: Could not load file");
			}

			page.close();
		};
	} else {
		//console.log("error: invalid properties passed to validator function");
		//return;

		var source = props.source.replace(props.output, props.input);
		var result = {
			input: props.input,
			output: source
		};

		page.content = source;

		page.onLoadFinished = function (status) {
			if (status) {
				if (xssDetected) {
					console.log(props.name + "\t: XSS positive with input: " + props.input);
					result.xss = true;
				} else {
					console.log(props.name + "\t: XSS negative with input: " + props.input);
					result.xss = false;
				}

				props.response.statusCode = 200;
				props.response.setHeader("Content-Type", "application/json");
				props.response.write(JSON.stringify(result));
				props.response.close();
			} else {
				var loadError = "Could not load page source from " + props.name;
				console.log(loadError);
				result["error"] = loadError;
				
				props.response.statusCode = 400;
				props.response.setHeader("Content-Type", "application/json");
				props.response.write(JSON.stringify(result));
				props.response.close();
			}

			page.close();
		};
	}
}
