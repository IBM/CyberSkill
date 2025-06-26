package router.thejasonengine.com;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Context;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;

import io.vertx.core.Vertx;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.file.AsyncFile;
import io.vertx.core.file.OpenOptions;
import io.vertx.core.parsetools.RecordParser;

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
		
		if (JSONpayload.getString("jwt") == null || JSONpayload.getString("pack_name") == null) 
	    {
	    	LOGGER.info("handleInstallContentPack required fields not detected (jwt or pack_name)");
	    	routingContext.fail(400); //THIS IS AN UNGRACEFUL ERROR - should be fixed.
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
					LOGGER.debug("User has correct access level");
					result.put("access_response", "User has correct access level (Access Check PASS");
		        
					utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
		        
					/*read the json file*/
					String pack_name = JSONpayload.getString("pack_name");
					LOGGER.debug("Attempting install process for pack_name: " + pack_name);
					
					Path currRelativePath = Paths.get("");
			        String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
			        LOGGER.debug("System execution path is: " + currAbsolutePathString);
			        
			        String filePath = currAbsolutePathString + "\\contentpacks\\" + pack_name + "\\sql\\mysql_query_inserts.sql";
			        
			        readLines(routingContext.vertx(), filePath)
			        .onComplete(ar -> 
			        {
			            if (ar.succeeded()) 
			            {
			                List<String> lines = ar.result();
			                
			                /*extract the SQL*/
			                for (String sql : lines) 
			                {
			                    
			                	/*run the SQL*/
			                	LOGGER.debug(sql);
			                }
							
			                
			                
			            } 
			            else 
			            {
			                LOGGER.error("Failed to read file: " + ar.cause());
			            }
			        });
			       
			        
		        
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
	/******************************************************************************/
	 public static Future<List<String>> readLines(Vertx vertx, String filePath) 
	 {
	        Promise<List<String>> promise = Promise.promise();
	        List<String> lines = new ArrayList<>();

	        vertx.fileSystem().open(filePath, new OpenOptions(), result -> {
	            if (result.succeeded()) {
	                AsyncFile file = result.result();
	                RecordParser parser = RecordParser.newDelimited("\n", file);

	                parser.handler(buffer -> {
	                    String line = buffer.toString().trim();
	                    lines.add(line);
	                });

	                parser.endHandler(v -> {
	                    file.close();
	                    promise.complete(lines);
	                });

	                parser.exceptionHandler(err -> {
	                    file.close();
	                    promise.fail(err);
	                });

	            } else {
	                promise.fail(result.cause());
	            }
	        });

	        return promise.future();
	    }
	
}
