/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package cluster.thejasonengine.com;

import java.util.HashMap;
import java.util.Map;
import java.io.File;
import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.hazelcast.shaded.org.json.JSONObject;

import authentication.thejasonengine.com.AuthUtils;
import database.thejasonengine.com.DatabaseController;
import demodata.thejasonengine.com.DatabasePoolPOJO;
import file.thejasonengine.com.Read;
import io.micrometer.core.instrument.Counter;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.eventbus.EventBus;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpHeaders;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.ServerWebSocket;
import io.vertx.core.json.JsonObject;
import io.vertx.core.json.jackson.DatabindCodec;
import io.vertx.ext.auth.JWTOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.jwt.JWT;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.sqlclient.Pool;
import memory.thejasonengine.com.Ram;
import messaging.thejasonengine.com.Websocket;
import router.thejasonengine.com.SetupPostHandlers;
import router.thejasonengine.com.UpgradeHandler;
import session.thejasonengine.com.SetupSession;
import utils.thejasonengine.com.ConfigLoader;
import database.thejasonengine.com.AgentDatabaseController;


import io.vertx.ext.web.common.template.TemplateEngine;
import io.vertx.ext.web.handler.FormLoginHandler;
import io.vertx.ext.web.handler.TemplateHandler;
import io.vertx.ext.web.openapi.RouterBuilder;
import io.vertx.ext.web.templ.freemarker.FreeMarkerTemplateEngine;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;


public class ClusteredVerticle extends AbstractVerticle {
	
	private static final Logger LOGGER = LogManager.getLogger(ClusteredVerticle.class);
	private PrometheusMeterRegistry prometheusRegistry;
	private JWTAuth jwt;
	private AuthUtils AU;
	private SetupSession setupSession;
	private SetupPostHandlers setupPostHandlers;
	private AgentDatabaseController agentDatabaseController;
	
	private UpgradeHandler upgradeHandler;
	private static Pool pool;
	private FreeMarkerTemplateEngine engine;
	
	@Override
    public void start()
	{
		
		
		
		
		LOGGER.info("This is an ClusteredVerticle 'INFO' TEST MESSAGE");
		LOGGER.debug("This is a ClusteredVerticle 'DEBUG' TEST MESSAGE");
		LOGGER.warn("This is a ClusteredVerticle 'WARN' TEST MESSAGE");
		LOGGER.error("This is an ClusteredVerticle 'ERROR' TEST MESSAGE");
		
		String config = System.getenv().getOrDefault("CONFIG", "config.json");
		
		/*Create the RAM object that will store and reference data for the worker*/
		ConfigLoader.loadProperties(config);
		
		Ram ram = new Ram();
	  	ram.initializeSharedMap(vertx);
	  	
	  	
		 // Get the default ObjectMapper used by Vert.x
	    ObjectMapper mapper = DatabindCodec.mapper();
		
	    // Register the JavaTimeModule to handle Java 8 Date and Time API types
	    mapper.registerModule(new JavaTimeModule());

	    // Optional: Configure the mapper for custom date formats or other settings
	    mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
		
				
		EventBus eventBus = vertx.eventBus();
		LOGGER.debug("Started the ClusteredVerticle Event Bus");
		/*Created a vertx context*/
		Context context = vertx.getOrCreateContext();
	
		AU = new AuthUtils();
		jwt = AU.createJWTToken(context);
		
		pool = context.get("pool");
		
		setupPostHandlers = new SetupPostHandlers(vertx);
		LOGGER.info("Set Handlers Setup");
		
		agentDatabaseController = new AgentDatabaseController(vertx);
		LOGGER.info("Set up Agent based Controller");
		
		
		upgradeHandler = new UpgradeHandler(vertx);
		LOGGER.info("Set Handlers Setup");
		
		Router router = Router.router(vertx);
		
		
		 // Configure CORS
        router.route().handler(CorsHandler.create("*") // Allow all origins
            .allowedMethod(HttpMethod.GET)            // Allow GET method
            .allowedMethod(HttpMethod.POST)           // Allow POST method
            .allowedMethod(HttpMethod.OPTIONS)        // Allow OPTIONS method (preflight requests)
            .allowedHeader("Content-Type")            // Allow Content-Type header
            .allowedHeader("Authorization"));         // Allow Authorization header
		
		
		
		LOGGER.debug("Setup the post handler");
			
		
		/*Create and add a session to the system*/
		setupSession = new SetupSession(context.owner());
		router.route().handler(setupSession.sessionHandler);
		
		/*
		Read.readFile(vertx, "mysettings.json");
		LOGGER.debug("Read the ClusteredVerticle mysettings.json");
		*/
		
		
		 
        /*********************************************************************************/
        engine = FreeMarkerTemplateEngine.create(vertx);
		TemplateHandler templateHandler = TemplateHandler.create((TemplateEngine) engine);
		/*Set Template*/
		
		//router.get("/dynamic/*").handler(templateHandler);
		/*********************************************************************************/
		router.getWithRegex("^/loggedIn(/.+)?/.+\\.ftl$")
		 .handler(ctx -> 
				 {
					 
					 LOGGER.info("verifying access to the logged in file .ftl");
			    		Cookie cookie = (Cookie) ctx.getCookie("JWT");
			    		if (cookie != null) 
			    		{
			    			LOGGER.info("Found a cookie with the correct name");
			    			if(verifyCookie(cookie))
			    			{
			    			 
			    			 LOGGER.info(">>>>>>>>>>>>>>LOADING UP THE FTL WITH REQUIRED LOGIC VARIABLES>>>>>>>>>>>>>>>> : "+ctx.normalizedPath());
			    			 String file2send = ctx.normalizedPath();
			    			 
			    			 	String tokenObjectString = cookie.getValue();
			    			 	LOGGER.info("Cookie Value: " + tokenObjectString);
			    			 	JWT jwtToken = new JWT();
			    			 	LOGGER.info("Token value from cookie: " + tokenObjectString);
			    				LOGGER.info("Token parsed: " + jwtToken.parse(tokenObjectString).toString());
			    				
			    				
			    				/*We create a basic signature test case to see what we can see*/
			    				JsonObject JWT_Validation_Test = new JsonObject(); 
			    				JWT_Validation_Test.put("jwt", tokenObjectString);
			    				
			    				
			    				
			    				JsonObject JSON_JWT = jwtToken.parse(tokenObjectString);
			    				
			    				
			    				
			    				if(setupPostHandlers.validateJWTToken(JWT_Validation_Test))
			    				{
			    						JsonObject tokenObject = new JsonObject();
					    				JsonObject hold = (JsonObject) JSON_JWT.getValue("payload");
					    				
					    				LOGGER.info("Username: " + hold.getString("username"));
					    				
					    				tokenObject.put("username", hold.getString("username"));
					    				tokenObject.put("authlevel", hold.getString("authlevel"));
					    				tokenObject.put("jwt", tokenObjectString);
					    			 
					    				Map<String, String> memoryMap = ram.getRamSharedMap();
					    				HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
					    				
					    				JSONObject jsonObject = new JSONObject(memoryMap);
					    				LOGGER.debug("Retrieved the ram memory object: " + memoryMap.get("jwt"));
					    				
					    				JsonObject jsonMemoryObject = new JsonObject(jsonObject.toString());
					    				LOGGER.debug("Current Ram State: "+jsonMemoryObject.encodePrettily());
					    				
					    			 /* I wont use sessions lets just stick with the cookie
					    			 String tokenString = setupSession.getTokenFromSession(ctx, "token");
					    			 String tokenObjectString = setupSession.getTokenFromSession(ctx, "tokenObject");
					    			 
					    			 LOGGER.info("Session JWT: " + tokenString);
					    			 LOGGER.info("Session tokenObject: " + tokenObjectString);
					    			 */
					    			 //JsonObject tokenObject = new JsonObject(tokenObjectString);
					    			 ctx.put("ValidatedConnectionData", dataSourceMap);
					    			 ctx.put("jsonMemoryObject", jsonMemoryObject);
					    			 ctx.put("tokenObject", tokenObject);
					    			 
					    			 
					   				 engine.render(ctx.data(), "templates/"+file2send.substring(1), 
					   			     res -> 
					   				 {
					   		             if (res.succeeded()) 
					   		             {
					   		            	 LOGGER.info("Successfully rendered template: " + file2send.substring(1));
					   		            	 ctx.response().end(res.result());
					   		             } 
					   		             else 
					   		             {
					   		            	 ctx.fail(res.cause());
					   		             }
					   				 });
			    				
			    				}
			    				else
			    				{
			    					LOGGER.error("**Potential security violation* The JWT from the cookie did not pass basic testing: " + ctx.normalizedPath() + ", From IP:" + ctx.request().remoteAddress());
					    			LOGGER.info("Redirecting to: " + ctx.normalizedPath().substring(0,ctx.normalizedPath().indexOf("/")).concat("index.htm"));
					    			ctx.redirect("../index.html");
			    				}
			    				
			    			}
			    		}
			    		else if (cookie == null) 
			    		{
			    			LOGGER.error("Did not find a cookie name JWT when calling the (.+\\\\.ftl) webpage: " + ctx.normalizedPath());
			    			LOGGER.info("Redirecting to: " + ctx.normalizedPath().substring(0,ctx.normalizedPath().indexOf("/")).concat("index.htm"));
			    			
			    			ctx.redirect("../index.html");
			    			//ctx.response().sendFile("webroot/index.htm"); //drop starting slash
			    		}
				 });
		/***************************************************************************************/
		router.get("/api/passwordGenerator/:password").handler(
    		    ctx -> 
    		    	{
    		    		
    		    		String password = ctx.request().getParam("password");
    		    		
    		    		ctx.response().putHeader("Content-Type", "application/json");
    		    		
    		    		String result = SetupPostHandlers.hashAndSaltPass(password.toString());
    		    		
    		    		JsonObject response = new JsonObject();
    	   	         	response.put("password", result);
    	   	         	LOGGER.info("Successfully generated password token " + result);
    		    		ctx.response().end(response.toString());
    		    		
    		    	}
    		    );
		
		/***************************************************************************************/
		
        
		/***************************************************************************************/
    	/*
    	 * This simply creates a cookie JWT token
    	 */
		/***************************************************************************************/
    	router.get("/api/newToken").handler(
    		    ctx -> 
    		    	{
    		    		
    		    		String name = "JWT";
    		    		ctx.response().putHeader("Content-Type", "application/json");
    		    		JsonObject tokenObject = new JsonObject();
    		    		tokenObject.put("endpoint", "sensor1");
    		    		tokenObject.put("someKey", "someValue");
    		    		String token = jwt.generateToken(tokenObject, new JWTOptions().setExpiresInSeconds(60000));
    		    		LOGGER.info("JWT TOKEN: " + token);
    		    		
    		    		LOGGER.debug("Creating cookie");
    		    		AU.createCookie(ctx, 60000, name, token, "/");
    		    		LOGGER.debug("Cookie created");
    		    		
    	   	         	ctx.response().setChunked(true);
    	   	         	ctx.response().putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*");
    	   	         	ctx.response().putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_METHODS, "GET");
    	   	         	//ctx.response().write("Cookie Stamped -> " + name + " : " +token);
    	   	         	
    	   	         	JsonObject response = new JsonObject();
    	   	         	response.put("token", token);
    	   	         	LOGGER.info("Successfully generated token and added cookie " + token);
    		    		ctx.response().end(response.toString());
    		    		
    		    	}
    		    );
    	/***************************************************************************************/
    	/*
    	 * This is really flawed - it simply checks for the actual presence of a cookie.
    	 * The verify cookie just looks at the user field in the payload
    	 */
    	/***************************************************************************************/
    	router.get("/api/protected").handler(
    		    ctx -> 
    		    	{
    		    		ctx.response().putHeader("Content-Type", "application/json");
    		    		Cookie cookie = (Cookie) ctx.getCookie("JWT");
    		    		if (cookie != null) 
    		    		{
    		    			LOGGER.info("Found a cookie with the correct name");
    		    			if(verifyCookie(cookie))
    		    			{
    		    				ctx.response().end("OK");
    		    			}
    		    		}
    		    		else if (cookie == null) 
    		    		{
    		    			LOGGER.error("Did not find a cookie name JWT when calling the (api/protected) webpage: " + ctx.normalizedPath());
    		    			ctx.response().sendFile("webroot/index.htm"); //drop starting slash
    		    		}
    		      });
    	/***************************************************************************************/
    	/*
    	 * This "secures" the route to particular assets by looking for the presence of a cookie
    	 */
    	/***************************************************************************************/
    	router.route("/loggedIn/*").handler(
    		    ctx -> 
    		    	{
    		    		LOGGER.info("verifying access to the logged in file");
    		    		Cookie cookie = (Cookie) ctx.getCookie("JWT");
    		    		if (cookie != null) 
    		    		{
    		    			LOGGER.info("Found a cookie with the correct name");
    		    			if(verifyCookie(cookie))
    		    			{
    		    				LOGGER.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> : "+ctx.normalizedPath());
    		    				String file2send = ctx.normalizedPath();
    		    				LOGGER.info("Session: " + setupSession.getTokenFromSession(ctx, "username"));
    		    				ctx.response().sendFile("webroot/"+file2send.substring(1)); //drop starting slash
    		    			}
    		    		}
    		    		else if (cookie == null) 
    		    		{
    		    			LOGGER.error("Did not find a cookie name JWT when calling the (loggedIn/*) webpage: " + ctx.normalizedPath());
    		    			//ctx.response().end("NO JWT TOKEN");
    		    			ctx.response().sendFile("webroot/index.html"); //drop starting slash
    		    		}
    		    	}).failureHandler(frc-> 
    		    	{
    		  		  	//frc.response().setStatusCode( 400 ).end("Sorry! Not today");
    		    		frc.redirect("../index.html");
    		    		
    		    	});;
        
        
        
		setRoutes(router);
		
		//router.route().handler(this::handleNotFound); 
		
		/*Now add the router to memory - for extension with plugins*/
		
		ram.setRouter(router);

		
		
		
		
		
		
		/*BOF - (todo)There is a race condition here - and this should not start until a message from the hazelcast telling it to begin arrives*/
		
		LOGGER.debug("Started the ClusteredVerticle Router");
		
		
		JsonObject configs = ram.getSystemConfig();
		LOGGER.debug("System configuration: " + configs.encodePrettily());
		
		
		/* Create a DB instance called jdbcClient and add it to the context */
		DatabaseController DB = new DatabaseController(vertx);
		
		
		
		int port = configs.getJsonObject("server").getInteger("port");
		LOGGER.debug("Starting server on port: " + port);
		
		
		String host = configs.getJsonObject("server").getString("host");
		LOGGER.debug("Starting server on host: " + host);
		
		
		vertx.createHttpServer()
        .requestHandler(router)
        .listen(port, res -> 
        {
            if (res.succeeded()) 
            {
                LOGGER.info("Server started on port :" + port);
            } 
            else 
            {
                LOGGER.error("Failed to start server: " + res.cause());
            }
        });
		/*EOF - (todo)There is a race condition here - and this should not start until a message from the hazelcast telling it to begin arrives*/
		
	}
	/*****************************************************************************/
	
	/*****************************************************************************/
    public void setRoutes(Router router)
    {
    	
    	
    	 /*********************************************************************************/
	  	 /*This sets up a static HTML route			   */
	  	 /*********************************************************************************/
    		
    		router.route("/*").handler(StaticHandler.create().setCachingEnabled(false).setWebRoot("webroot"));   
    		
    	
    	
    	
	     /*********************************************************************************/
	  	 /*This will log a user in {"result":"ok", "reason": "ok"}     				   */
	  	 /*********************************************************************************/
	  	 router.post("/api/validateCredentials").handler(BodyHandler.create()).handler(setupPostHandlers.validateCredentials);
	  	 router.post("/api/validateUserStatus").handler(BodyHandler.create()).handler(setupPostHandlers.validateUserStatus);
	  	 router.post("/api/createCookie").handler(BodyHandler.create()).handler(setupPostHandlers.createCookie);
	  	 router.post("/api/createSession").handler(BodyHandler.create()).handler(setupPostHandlers.createSession);
	  	/***************************************************************************************/
    	
	  	 router.post("/api/addDatabaseQuery").handler(BodyHandler.create()).handler(setupPostHandlers.addDatabaseQuery);
	  	 router.post("/api/getDatabaseQueryByDbType").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQueryByDbType);
	  	 router.post("/api/getDatabaseQuery").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQuery);
	  	 router.post("/api/getDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQueryByQueryId);
	  	 router.post("/api/deleteDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.deleteDatabaseQueryByQueryId);
	  	 router.post("/api/updateDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.updateDatabaseQueryByQueryId);
	  	 router.post("/api/getDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseConnections);
	  	 router.post("/api/getRefreshedDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getRefreshedDatabaseConnections);
	  	
	  	 router.post("/api/getQueryTypes").handler(BodyHandler.create()).handler(setupPostHandlers.getQueryTypes);
	  	 router.post("/api/addQueryTypes").handler(BodyHandler.create()).handler(setupPostHandlers.addQueryTypes);
	  	 router.post("/api/deleteQueryTypesByID").handler(BodyHandler.create()).handler(setupPostHandlers.deleteQueryTypesByID);
	  	 router.post("/api/getDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseConnectionsById);
	  	 router.post("/api/deleteDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteDatabaseConnectionsById);
	  	 router.post("/api/updateDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.updateDatabaseConnectionById);
	  	 router.post("/api/setDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.setDatabaseConnections);
	  	 router.post("/api/getValidatedDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getValidatedDatabaseConnections);
	  	 
	  	 /************************ Schedule Jobs ******************************************/
	  	 router.post("/api/getScheduleJobs").handler(BodyHandler.create()).handler(setupPostHandlers.getScheduleJobs);
	  	 router.post("/api/addScheduleJob").handler(BodyHandler.create()).handler(setupPostHandlers.addScheduleJob);
	  	 router.post("/api/deleteScheduleJobById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteScheduleJobById);
	  	 
	  	 router.post("/api/addStory").handler(BodyHandler.create()).handler(setupPostHandlers.addStory);
	  	 router.post("/api/getAllStories").handler(BodyHandler.create()).handler(setupPostHandlers.getAllStories);
	  	 router.post("/api/runStoryById").handler(BodyHandler.create()).handler(setupPostHandlers.runStoryById);
	  	 router.post("/api/deleteStoryById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteStoryById);
	  	 
	  	 
	  	 router.post("/api/getAvailablePlugins").handler(BodyHandler.create()).handler(setupPostHandlers.getAvailablePlugins);
	  	 
	  	
	  	/*********************************************************************************/
	  	 
	  	router.post("/api/checkForUpgrade").handler(BodyHandler.create()).handler(upgradeHandler.checkForUpgrade);
	  	
	  	
	  	 /*********************************************************************************/
	  	 //router.post("/api/monitor/guardium").handler(BodyHandler.create()).handler(setupPostHandlers.monitorGuardium);
	  	 //router.post("/api/monitor/getMonitorGuardiumSourcesForCron").handler(BodyHandler.create()).handler(setupPostHandlers.getMonitorGuardiumSourcesForCron);
	  	 //router.post("/api/monitor/getMonitorGuardiumSources").handler(BodyHandler.create()).handler(setupPostHandlers.getMonitorGuardiumSources);
	  	 //router.post("/api/monitor/getMonitorGuardiumSourceMessageStatById").handler(BodyHandler.create()).handler(setupPostHandlers.getMonitorGuardiumSourceMessageStatById);
	  	 //router.post("/api/monitor/getMonitorGuardiumDataByMessageIdHash").handler(BodyHandler.create()).handler(setupPostHandlers.getMonitorGuardiumDataByMessageIdHash);
	  	 //router.post("/api/monitor/getMonitorGuardiumDataByMessageIdHashAndInternalId").handler(BodyHandler.create()).handler(setupPostHandlers.getMonitorGuardiumDataByMessageIdHashAndInternalId);
	  	 
	  	 
	  	 router.get("/getSwagger").handler(BodyHandler.create()).handler(setupPostHandlers.getSwagger);
	  	 
	  	 router.get("/api/getDatabaseVersion").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseVersion);
	  	 
	  	 router.post("/api/getMySystemVariables").handler(BodyHandler.create()).handler(setupPostHandlers.getMySystemVariables);
	  	 router.post("/api/setMySystemVariables").handler(BodyHandler.create()).handler(setupPostHandlers.setMySystemVariables);
	  	 
	  	 
	  	 router.route("/swagger/*").handler(StaticHandler.create("webroot/swagger-ui"));

	  	 
	  	
	  	 /*******************************************************************************/
	  	 /*These are APIs for OS specific scheduled tasks*/
	  	 /*******************************************************************************/
	  	
	  	 router.post("/api/addOSTask").handler(BodyHandler.create()).handler(setupPostHandlers.addOSTask);
	  	 router.post("/api/getOSTasks").handler(BodyHandler.create()).handler(setupPostHandlers.getOSTasks);
	  	 router.post("/api/getOSTaskByTaskId").handler(BodyHandler.create()).handler(setupPostHandlers.getOSTaskByTaskId);
	  	 //router.post("/api/updateOSTasksById").handler(BodyHandler.create()).handler(setupPostHandlers.updateOSTaskByTaskId);
	  	 router.post("/api/deleteOSTasksByTaskId").handler(BodyHandler.create()).handler(setupPostHandlers.deleteOSTaskByTaskId);
	  	 
	  	/*********************************************************************************/
	  	/*These are the controller APIs for the various databases we want to drive     				     */
	  	/*********************************************************************************/
	  	
	  	router.post("/api/runDatabaseQueryByDatasourceMap").handler(BodyHandler.create()).handler(setupPostHandlers.runDatabaseQueryByDatasourceMap);
	  	router.post("/api/runDatabaseQueryByDatasourceMapAndQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.runDatabaseQueryByDatasourceMapAndQueryId);
	  	 
	  	 
	  	
	  	/*This requires a post with payload {"databaseId":"postgres"}     				   */
	  	router.post("/api/sendDatabaseSelect").handler(BodyHandler.create()).handler(agentDatabaseController.agentDatabase);
	  	
	  	 
	  	 
  	  	/***************************************************************************************/
    	router.get("/api/simpleTest").handler(setupPostHandlers.simpleTest);
    	router.get("/api/simpleDBTest").handler(setupPostHandlers.simpleDBTest);
    	
    	
    	/***************************************************************************************/
    	// Define the WebSocket route
        router.get("/websocket/story/:username").handler(ctx -> {
            // Upgrade the HTTP request to a WebSocket
            ctx.request().toWebSocket(socket -> 
            	{
            		if (socket.succeeded()) 
            		{
	                    // Handle WebSocket connection
            			String username = ctx.pathParam("username");
            			LOGGER.debug("New WebSocket connection: " + socket.result().remoteAddress() + " username: " + username);
	                    
	
	                    // Get the WebSocket instance
	                    ServerWebSocket webSocket = socket.result();
	                    Websocket ws = new Websocket();
	                    
	                    ws.addNewSocket(webSocket,username);
	
	                    // When a message is received from the client
	                    webSocket.handler(buffer -> 
	                    {
	                        String message = buffer.toString();
	                        LOGGER.debug("Received message: " + message);
	                        // Echo the message back to the client
	                        webSocket.writeTextMessage("Echo: " + message);
	                    });
	
	                    // Handle WebSocket close
	                    webSocket.closeHandler(v -> {
	                    	LOGGER.debug("WebSocket closed");
	                    	ws.removeSocket(webSocket);
	                    });
	
	                    // Handle WebSocket error
	                    webSocket.exceptionHandler(err -> {
	                    	LOGGER.debug("WebSocket error: " + err.getMessage());
	                    });
	                } 
            		else 
            		{
            			LOGGER.error("Failed to create WebSocket: " + socket.cause());
            		}
            });
        });
        
       /*********************************************************************************/
    	/* This will be the routes for the website activity
    	/**********************************************************************************/
    	/* In this route we stack the individual fuctions of login to carry out the login */
    	 router.post("/web/login").handler(BodyHandler.create()).handler(setupPostHandlers.webLogin);
    	/***************************************************************************************/	    	
    	router.get("/get").handler(ctx -> {
    		            // Respond with a simple JSON object
    		            ctx.response()
    		                .putHeader("content-type", "application/json")
    		                .end("{\"message\":\"Hello get request!\"}");
    		        });
    	/***************************************************************************************/	    	 
    	router.post("/post").handler(ctx -> {
    		    		// Respond with a simple JSON object
    		            ctx.response()
    		                .putHeader("content-type", "application/json")
    		                .end("{\"message\":\"Hello post request!\"}");
    		        });
    	
    	
    }
    
    /*****************************************************************************/
    // Default 404 Error Handler
    private void handleNotFound(RoutingContext context) 
    {
       LOGGER.error("errorMessage - Oops! The page you are looking for does not exist.");
        
        engine.render(context.data(), "templates/loggedIn/error.ftl", res -> {
            if (res.succeeded()) {
                context.response().putHeader("Content-Type", "text/html").end(res.result());
            } else {
                context.fail(res.cause());
            }
        });
    }
	/*****************************************************************************/
 // Handle the login logic
    private void handleLogin(RoutingContext context) {
        // Get the username and password from the request body
    	
    	Buffer body = context.getBody();
    	String bodyString = body.toString();

    	JsonObject jsonBody = new JsonObject(bodyString);
    	
        String username = jsonBody.getString("username");
        String password = jsonBody.getString("password");

        LOGGER.debug("username: " + username);
        LOGGER.debug("password: " + password);
        
        // Simple validation (in production, never hardcode credentials, and always hash passwords)
        if ("user".equals(username) && "password123".equals(password)) {
            // Respond with success message
            context.response().putHeader("Content-Type", "application/json")
                    .end("{\"message\": \"Login successful!\"}");
        } else {
            // Respond with error message for invalid credentials
            context.response().setStatusCode(401).putHeader("Content-Type", "application/json")
                    .end("{\"message\": \"Invalid credentials\"}");
        }
    }
    
    /*****************************************************************************/
    private boolean verifyCookie(Cookie cookie)
    {
  	  	/*
  	  	 * The cookie is used to verify:
  	  	 *  	1. the access rights to the API
  	  	 *  	2. the freshness of the login
  	  	 * Both properties are to be played with.
  	  	 */
  	  
  	  	String token = cookie.getValue();
  	  	LOGGER.info("Token value: " + token);
  		JWT jwtToken = new JWT();
  		LOGGER.info("Token parsed: " + jwtToken.parse(token).toString());
  		JsonObject JSON_JWT = jwtToken.parse(token);
  		
  		Integer cookieExpiry = (Integer)JSON_JWT.getJsonObject("payload").getValue("exp");
  		
  		long cookExp = Long.valueOf(cookieExpiry.longValue());
  		cookExp = cookExp * 1000; //convert from an int to a long
  		
  		LOGGER.info("Cookie Expires: " + cookExp);
  		long currentTimestamp = System.currentTimeMillis();
  		LOGGER.info("Current Time:" + currentTimestamp);
  		
  		
  		if(currentTimestamp < cookExp)
  		{
  			LOGGER.info("Cookie is still alive");
  		}
  		else
  		{
  			LOGGER.info("Cookie is too old and will not be accepted");
  		}
  		

  		LOGGER.info("Verify Cookie Username: "  + JSON_JWT.getJsonObject("payload").getValue("username").toString());
  		
  		
  		return true;
    }
}