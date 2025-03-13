package router.thejasonengine.com;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.hazelcast.shaded.org.json.JSONObject;

import io.micrometer.core.ipc.http.HttpSender.Request;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Context;
import io.vertx.core.Vertx;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpClient;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.jwt.JWT;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.client.WebClient;
import io.vertx.ext.web.common.template.TemplateEngine;
import io.vertx.ext.web.handler.TemplateHandler;
import io.vertx.ext.web.templ.freemarker.FreeMarkerTemplateEngine;
import memory.thejasonengine.com.Ram;

public class PluginHandler {
	
	private static final Logger LOGGER = LogManager.getLogger(PluginHandler.class);
	private FreeMarkerTemplateEngine engine;
	private Map<String, JsonObject> pluginDataMap;
	
	
	
	public static void handleGetAvailablePlugins(RoutingContext routingContext)
	{
		HttpServerResponse response = routingContext.response();
		Ram ram = new Ram();
		
		JsonArray ja = new JsonArray();
		
		HashMap<String, JsonObject> plugins = ram.getPlugins();
		if(plugins == null)
        {
			LOGGER.debug("Plugins are null");
			plugins = new HashMap<String, JsonObject>();
	    }
		else
		{
			
			for (Map.Entry<String, JsonObject> set :plugins.entrySet()) 
			{
				LOGGER.debug(set.getKey() + " = "+ set.getValue().encodePrettily());
				JsonObject jo = set.getValue();
				ja.add(jo);
			}
			
			LOGGER.debug("Available plugins: " + ja.encodePrettily());
		    	
		}
		response.putHeader("content-type", "application/json");
		response.send(ja.encodePrettily());	
	}
	
	
	
	public void createNewPluginRoute(Vertx vertx, JsonObject plugin)
	{
		engine = FreeMarkerTemplateEngine.create(vertx);
		TemplateHandler templateHandler = TemplateHandler.create((TemplateEngine) engine);
		
		WebClient client = WebClient.create(vertx);
		HttpClient httpClient = vertx.createHttpClient();
		
		Ram ram = new Ram();
		
		Router router = ram.getRouter();
		
		Integer Port = 81;
		String host = "127.0.0.1";
		String pluginName = "insights";
		
		
		HashMap<String, JsonObject> plugins = ram.getPlugins();
		if(plugins == null)
        {
			LOGGER.debug("Plugins are null");
			plugins = new HashMap<String, JsonObject>();
        }
		
		plugins.put(plugin.getString("pluginName") , plugin.getJsonObject("pluginDetails"));
		
		ram.setPlugins(plugins);
		
		LOGGER.debug("Adding :" + plugin.getString("pluginName") + " to the plugin context service");
		
		
		
		LOGGER.debug("Request to create new plugin route with details: " + plugin.encodePrettily());
		LOGGER.debug("Creating heartbeat endpoint for plugin");
		router.get("/api/plugin/insights").handler(ctx -> {
			httpClient.request(ctx.request().method(), 81, "127.0.0.1", ctx.request().uri())
		          .compose(req -> req.send())
		          .onSuccess(response -> {
		        	  LOGGER.debug("Successfully sent request");
		              response.body().onSuccess(body -> 
		              {
		            	  //LOGGER.debug("request: " + body);
		            	  ctx.response().setStatusCode(response.statusCode()).end(body);
		              });
		          })
		          .onFailure(err ->{
		         LOGGER.error("Unable to great pluging route: " + err);	  
		          ctx.fail(500);});
		});
		LOGGER.debug("Creating endpoints for plugin");
		router.post("/api/plugin/insights/*").handler(ctx -> {
		    ctx.request().bodyHandler(body -> {
				client.request(HttpMethod.POST, 81, "127.0.0.1", ctx.request().uri())
	                    .putHeader("content-type", "application/json")
	                    .sendBuffer(body, response -> {
	                        if (response.succeeded()) 
	                        {
	                            ctx.response()
	                                    .putHeader("content-type", "application/json")
	                                    .end(response.result().body());
	                        } 
	                        else 
	                        {
	                            ctx.response().setStatusCode(500).end("Proxy Error: " + response.cause().getMessage());
	                        }
	                    });
	        });
			
		});
			
		
		
		
		router.getWithRegex("^/plugin(/.+)?/.+\\.ftl$")
		 .handler(ctx -> 
				 {
					 
					 
					 
					 	LOGGER.info("verifying access to the plugin file .ftl");
			    		Cookie cookie = (Cookie) ctx.getCookie("JWT");
			    		if (cookie != null) 
			    		{
			    			LOGGER.info("Found a cookie with the correct name");
			    			if(verifyCookie(cookie))
			    			{
			    			 
			    			 LOGGER.info(">>>>>>>>>>>>>>LOADING UP THE PLUGIN FTL WITH REQUIRED LOGIC VARIABLES>>>>>>>>>>>>>>>> : "+ctx.normalizedPath());
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
			    				
			    				if(validateJWTToken(JWT_Validation_Test))
			    				{
			    						JsonObject tokenObject = new JsonObject();
					    				JsonObject hold = (JsonObject) JSON_JWT.getValue("payload");
					    				
					    				LOGGER.info("Username: " + hold.getString("username"));
					    				
					    				tokenObject.put("username", hold.getString("username"));
					    				tokenObject.put("authlevel", hold.getString("authlevel"));
					    				tokenObject.put("jwt", tokenObjectString);
					    			 
					    				Map<String, String> memoryMap = ram.getRamSharedMap();
					    				HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
					    				
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
					    			 
					    			 
					    			 httpClient.request(ctx.request().method(), 81, "127.0.0.1", ctx.request().uri())
					   				          .compose(req -> req.send())
					   				          .onSuccess(response -> {
					   				        	  LOGGER.debug("Successfully sent request");
					   				              response.body().onSuccess(body -> 
					   				              {
					   				            	  LOGGER.debug("request: " + body);
					   				            	  ctx.end(body);
					   				              })
					   				              .onFailure(err ->{
					   				            	  LOGGER.error("Unable to great pluging route: " + err);	  
					   				            	  ctx.fail(500);
					   				              });
					   				          });
			    				
			    				}
			    				else
			    				{
			    					LOGGER.error("**Potential security violation* The JWT from the cookie did not pass basic testing: " + ctx.normalizedPath() + ", From IP:" + ctx.request().remoteAddress());
					    			LOGGER.info("Redirecting to: " + ctx.normalizedPath().substring(0,ctx.normalizedPath().indexOf("/")).concat("index.html"));
					    			ctx.redirect("../index.html");
			    				}
			    				
			    			}
			    		}
			    		else if (cookie == null) 
			    		{
			    			LOGGER.error("Did not find a cookie name JWT when calling the (.+\\\\.ftl) webpage: " + ctx.normalizedPath());
			    			LOGGER.info("Redirecting to: " + ctx.normalizedPath().substring(0,ctx.normalizedPath().indexOf("/")).concat("html"));
			    			
			    			ctx.redirect("../index.html");
			    			//ctx.response().sendFile("webroot/index.htm"); //drop starting slash
			    		}
				 });
		
				
	}
	
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
    public static boolean validateJWTToken(JsonObject JSONpayload)
	{
		boolean result = false;
		
		
		LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
		
		String [] chunks = JSONpayload.getString("jwt").split("\\.");
		if(chunks.length > 2)
		{
			JsonObject header = new JsonObject(decode(chunks[0]));
			JsonObject payload = new JsonObject(decode(chunks[1]));
			
			LOGGER.info("Basic JWT structure test has passed with a payload of: " + payload );
			LOGGER.info("String to be base64Url Encoded: " + payload.encode());
			LOGGER.info("base64UrlEncoder: " +  base64UrlEncoder(payload.encode()));
			LOGGER.debug("Basic JWT structure test has passed with a header of: " + header);
			
			result = true;
			//Now validate that the user account is still active
			
		}
		else
		{
			result = false;
		}
		
		if(result == true)
		{
			//next validate the signature
			
			String headerPlusPayload = chunks[0] + "." + chunks[1];
			LOGGER.debug("headerPlusPayload: " + headerPlusPayload);
			
			String signature = chunks[2];
			LOGGER.debug("signature: " + signature);
		
			try
			{
				String generateSignature = hmacSha256(chunks[0].toString() + "." + chunks[1].toString(), "keyboard cat");
				LOGGER.debug("Generated signature: " + generateSignature);
				
				if(signature.compareTo(generateSignature)== 0)
				{
					LOGGER.debug("*********** JWT Signature match ***************");
				}
				else
				{
					LOGGER.error("**Potential security violation* JWT SIGNATURE ERROR**");
					result = false;
				}
			}
			catch(Exception e)
			{
				LOGGER.error("Uable to perform signature match of JWT Token: " + e.toString());
				result = false;
			}
		}
		return result;
	}
	/*********************************************************************************/
	public static String base64UrlEncoder(String originalInput)
	{
		String encodedString = Base64.getEncoder().encodeToString(originalInput.getBytes());
		return encodedString;
	}
	/*********************************************************************************/
	public String base64UrlDecoder(String encodedString)
	{
		byte[] decodedBytes = Base64.getDecoder().decode(encodedString);
		String decodedString = new String(decodedBytes);
		return decodedString;
	}
	/*********************************************************************************/
	public static String encode(byte[] bytes) 
	{
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
	}
	/*********************************************************************************/
	public static String decode(String encodedString) {
	    return new String(Base64.getUrlDecoder().decode(encodedString));
	}
	/*********************************************************************************/
	private static String hmacSha256(String data, String secret) {
	    try {

	        byte[] hash = secret.getBytes(StandardCharsets.UTF_8);
	        Mac sha256Hmac = Mac.getInstance("HmacSHA256");
	        SecretKeySpec secretKey = new SecretKeySpec(hash, "HmacSHA256");
	        sha256Hmac.init(secretKey);

	        byte[] signedBytes = sha256Hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));

	        return encode(signedBytes);
	    } 
	    catch (Exception e) 
	    {
	        LOGGER.error("Unable to encode: " + e.toString());
	        return null;
	    }
	}

}


