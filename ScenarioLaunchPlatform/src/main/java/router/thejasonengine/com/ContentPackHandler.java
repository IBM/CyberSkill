package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Context;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;

public class ContentPackHandler 
{
	private static final Logger LOGGER = LogManager.getLogger(ContentPackHandler.class);

	public Handler<RoutingContext> installContentPack;
	public Handler<RoutingContext> uninstallContentPack;
	
	/******************************************************************************************/
	public ContentPackHandler(Vertx vertx)
    {
		installContentPack = ContentPackHandler.this::handleInstallContentPack;
		uninstallContentPack = ContentPackHandler.this::handleUninstallContentPack;
	}
	
	public void handleInstallContentPack(RoutingContext routingContext)
	{
		LOGGER.debug("inside: handleInstallContentPack ");
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleInstallContentPack required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("User permitted to access handleInstallContentPack (JWT Check PASS)");
				result.put("jwt_response", "User permitted to access handleInstallContentPack (JWT Check PASS)");
				
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				LOGGER.info("Accessible Level is : " + authlevel);
			       
				if(authlevel >= 1)
		        {
					LOGGER.info("User has correct access level");
					result.put("access_response", "User has correct access level (Access Check PASS");
		        
					utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
		        
					/*read the json file*/
					
					/*extract the SQL*/
					
					/*run the SQL*/
		        
					/*respond to the UI jobs complete */
		        
		        }
				else
				{
					
					LOGGER.error("User has incorrect access level");
					result.put("access_response", "User has incorrect access level (Access Check FAIL");
				}
				
				
				
				/*
					String encoded_query = Encodings.EscapeString(query);
					LOGGER.debug("Query recieved: " + query);
					LOGGER.debug("Query encoded: " + encoded_query);
				*/
				
				
			}
			else
			{
				LOGGER.error("User NOT permitted to run handleInstallContentPack (JWT Check FAIL)");
				result.put("jwt_response", "User NOT permitted to run handleInstallContentPack (JWT Check FAIL)");
				
			}
		}
		response.send("{\"result\":\""+result+"\"}");
	}
	
	public void handleUninstallContentPack(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleUninstallContentPack required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("User permitted to run handleUninstallContentPack (JWT Check PASS)");
				result.put("response", "User permitted to run handleUninstallContentPack (JWT Check PASS)");
			}
			else
			{
				LOGGER.error("User NOT permitted to run handleUninstallContentPack (JWT Check FAIL)");
				result.put("response", "User NOT permitted to run handleUninstallContentPack (JWT Check FAIL)");
				
			}
		}
		response.send("{\"result\":\""+result+"\"}");
	}
	
}
