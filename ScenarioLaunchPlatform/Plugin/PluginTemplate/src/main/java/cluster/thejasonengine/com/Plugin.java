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
import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.hazelcast.shaded.org.json.JSONObject;
import authentication.thejasonengine.com.AuthUtils;
import database.thejasonengine.com.DatabaseController;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.eventbus.EventBus;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.JsonObject;
import io.vertx.core.json.jackson.DatabindCodec;
import io.vertx.ext.auth.JWTOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.jwt.JWT;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.sqlclient.Pool;
import memory.thejasonengine.com.Ram;
import router.thejasonengine.com.SetupPostHandlers;
import utils.thejasonengine.com.ConfigLoader;
import utils.thejasonengine.com.PluginLoader;
import io.vertx.ext.web.common.template.TemplateEngine;
import io.vertx.ext.web.handler.TemplateHandler;
import io.vertx.ext.web.templ.freemarker.FreeMarkerTemplateEngine;

public class Plugin extends AbstractVerticle {
	
	private static final Logger LOGGER = LogManager.getLogger(Plugin.class);
	private JWTAuth jwt;
	private AuthUtils AU;
	private SetupPostHandlers setupPostHandlers;
	private DatabaseController DatabaseController;
	private static Pool pool;
	private JsonObject pluginConfig;
	
	@Override
    public void start()
	{
		LOGGER.info("This is a PLUGIN ClusteredVerticle 'INFO' TEST MESSAGE");
		LOGGER.debug("This is a PLUGIN ClusteredVerticle 'DEBUG' TEST MESSAGE");
		LOGGER.warn("This is a PLUGIN ClusteredVerticle 'WARN' TEST MESSAGE");
		LOGGER.error("This is a PLUGIN ClusteredVerticle 'ERROR' TEST MESSAGE");
		
		String config = System.getenv().getOrDefault("CONFIG", "config.json");
		String plugin = System.getenv().getOrDefault("PLUGIN", "plugin.json");
		
		
		
		/*Create the RAM object that will store and reference data for the worker*/
		ConfigLoader.loadProperties(config);
		
		EventBus eventBus = vertx.eventBus();
		
		Ram ram = new Ram();
	  	ram.initializeSharedMap(vertx);
	  	
	  	PluginLoader.loadPlugin(plugin);
	  	 // Get the default ObjectMapper used by Vert.x
	    ObjectMapper mapper = DatabindCodec.mapper();
		// Register the JavaTimeModule to handle Java 8 Date and Time API types
	    mapper.registerModule(new JavaTimeModule());
	    // Optional: Configure the mapper for custom date formats or other settings
	    mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
		
				
		
		LOGGER.debug("Started the plugin Event Bus");
		/*Created a vertx context*/
		Context context = vertx.getOrCreateContext();
		
		AU = new AuthUtils();
		jwt = AU.createJWTToken(context);
		
		
		
		pool = context.get("pool");
		
		setupPostHandlers = new SetupPostHandlers(vertx);
		LOGGER.info("Set Handlers Setup");
		
		DatabaseController = new DatabaseController(vertx);
		LOGGER.info("Set up Agent based Controller");
		
		Router router = Router.router(vertx);
		
		
		 // Configure CORS
        router.route().handler(CorsHandler.create("*") // Allow all origins
            .allowedMethod(HttpMethod.GET)            // Allow GET method
            .allowedMethod(HttpMethod.POST)           // Allow POST method
            .allowedMethod(HttpMethod.OPTIONS)        // Allow OPTIONS method (preflight requests)
            .allowedHeader("Content-Type")            // Allow Content-Type header
            .allowedHeader("Authorization"));         // Allow Authorization header
		
		
		
		LOGGER.debug("Setup the post handler");
			
		
		 
        /*********************************************************************************/
        FreeMarkerTemplateEngine engine = FreeMarkerTemplateEngine.create(vertx);
		TemplateHandler templateHandler = TemplateHandler.create((TemplateEngine) engine);
		/*Set Template*/
		
		//router.get("/dynamic/*").handler(templateHandler);
		/*********************************************************************************/
		router.getWithRegex("/plugin/.*\\.ftl")
		 .handler(ctx -> 
				 {
					LOGGER.info(">>>>>>>>>>>>>>LOADING UP THE PLUGIN FTL WITH REQUIRED LOGIC VARIABLES>>>>>>>>>>>>>>>> : "+ctx.normalizedPath());
			    	String file2send = ctx.normalizedPath();
			    	JsonObject pluginObject = new JsonObject();
			    	JWTAuth jwt;
		        	// Set up the authentication tokens 
		        	String name = "JWT";
		        	AuthUtils AU = new AuthUtils();
		        	
		        	pluginObject.put("username", "username");
		        	pluginObject.put("authlevel", "1");
		        	
		        	
		        	jwt = AU.createJWTToken(context);
		        	String token = jwt.generateToken(pluginObject, new JWTOptions().setExpiresInSeconds(60000));
		        	
		        	JsonObject tokenObject = new JsonObject();
    				tokenObject.put("jwt", token);
			    	
    				ctx.put("tokenObject", tokenObject);
			    	
			    	engine.render(ctx.data(), file2send.substring(1), 
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
			    				
			    		
				 });
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
    		    			ctx.response().sendFile("webroot/index.html"); //drop starting slash
    		    		}
    		      });
    	/***************************************************************************************/
    	
    	pluginConfig = ram.getPluginConfig();
    	JsonObject pluginDetails = pluginConfig.getJsonObject("pluginDetails");
    	
    	String pluginName = pluginDetails.getString("name");
    	
    	
    	
    	LOGGER.debug("Plugin reloader endpoint creating at: /api/plugin/" + pluginName);
    	/***************************************************************************************/
    	router.get("/api/plugin/" + pluginName).handler(
    		    ctx -> 
    		    	{
    		    		String name = "JWT";
    		    		ctx.response().putHeader("Content-Type", "application/json");
    		    		
    		    		JsonObject tokenObject = new JsonObject();
			        	
					    tokenObject.put("id", 1);
					    tokenObject.put("firstname", "username");
					    tokenObject.put("surname", "surname");
					    tokenObject.put("email", "username@ibm.com");
					    tokenObject.put("username", "username");
					    tokenObject.put("active", true);
					    tokenObject.put("authlevel", 5);
					    
					    
					    
    		    		String token = jwt.generateToken(tokenObject, new JWTOptions().setExpiresInSeconds(60000));
    		    		LOGGER.info("JWT TOKEN: " + token);
    		    		 
    		    		LOGGER.debug("Creating cookie in plugin context");
    		    		AU.createCookie(ctx, 60000, name, token, "/");
    		    		LOGGER.debug("Cookie created in plugin context");
    		    		
    		    		try
    		    		{
    		    			PluginLoader.loadPlugin(plugin);
    		    			JsonObject jo = new JsonObject();
    		    			jo.put("result", "ok");
    		    			ctx.response().end(jo.encodePrettily());
    		    		}
    		    		catch(Exception e)
    		    		{
    		    			JsonObject jo = new JsonObject();
    		    			jo.put("result", e.toString().replaceAll("\"", ""));
    		    			ctx.response().end(jo.encodePrettily());
    		    		}
    		      });
    	
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
    		    			ctx.response().sendFile("webroot/index.html"); //drop starting slash
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
		
		/*BOF - (todo)There is a race condition here - and this should not start until a message from the hazelcast telling it to begin arrives*/
		
		LOGGER.debug("Started the ClusteredVerticle Router");
		
		JsonObject configs = ram.getSystemConfig();
		LOGGER.debug("System configuration: " + configs.encodePrettily());
		
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
	}
	/*****************************************************************************/
    public void setRoutes(Router router)
    {
    	 /*********************************************************************************/
	  	 /*This sets up a static HTML route			   */
	  	 /*********************************************************************************/
    	 router.route("/*").handler(StaticHandler.create().setCachingEnabled(false).setWebRoot("webroot"));   
    	 /*********************************************************************************/
	  	 router.post("/api/plugin/loadrunner/runLoadRunner").handler(BodyHandler.create()).handler(setupPostHandlers.runLoadRunner);
	  	 /*********************************************************************************/
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