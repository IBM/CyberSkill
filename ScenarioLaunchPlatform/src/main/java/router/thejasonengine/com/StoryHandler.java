/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package router.thejasonengine.com;

import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import database.thejasonengine.com.DatabaseController;
import io.vertx.core.Context;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;
import memory.thejasonengine.com.Ram;
import story.thejasonengine.com.RunStoryVerticle;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.DeploymentOptions;
import io.vertx.core.Vertx;

public class StoryHandler 
{
	private static final Logger LOGGER = LogManager.getLogger(StoryHandler.class);
	
	
	public static void handleDeleteStoryById(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleDeleteStoryById required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				int id = JSONpayload.getInteger("id");
				
				LOGGER.debug("Story id to delete: " + id);
				
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("id", id);
				
				LOGGER.info("Accessible Level is : " + authlevel);
		        
		        if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response.putHeader("content-type", "application/json");
		        	
		        	Ram ram = new Ram();
	                /********************** Proceed to database activity ******************************/
                    Pool PostgresPool = ram.getPostGresSystemPool();
            		
            		if (PostgresPool == null)
            		{
            			LOGGER.debug("pool is null - restarting");
            			DatabaseController DB = new DatabaseController(routingContext.vertx());
            		}
            		LOGGER.debug("Postgres connection established");
                    
            		PostgresPool.getConnection(ar3 -> 
            		{
            			if (ar3.succeeded()) 
                        {
            				SqlConnection connection = ar3.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("delete from public.tb_stories where id = $1")
			                        .execute(Tuple.of(map.get("id")),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                // Process the query result
			                                RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	JsonObject jo = new JsonObject(row.toJson().encode());
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully deleted story");
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
			                                    }
			                                    
			                                });
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	response.send(res.cause().getMessage());
			                            }
			                            connection.close();
			                        });
            				
                         }
            			if(ar3.failed())
            			{
            				LOGGER.error("Unable to delete stories from database: " + ar3.cause());
            				response.send("{\"result\":\""+ar3.cause()+"\"}");
            			}
                    });
                    /********************** ***************** ******************************/
	            }
			}
		}
	
	}
	public static void handleRunStoryById(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleGetAllStories required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				int id = JSONpayload.getInteger("id");
				
				LOGGER.debug("Story id: " + id);
				
				Map<String,Object> map = new HashMap<String, Object>();
				map.put("id", id);
				
				LOGGER.info("Accessible Level is : " + authlevel);
		        
		        if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response.putHeader("content-type", "application/json");
		        	
		        	Ram ram = new Ram();
	                /********************** Proceed to database activity ******************************/
                    Pool PostgresPool = ram.getPostGresSystemPool();
            		
            		if (PostgresPool == null)
            		{
            			LOGGER.debug("pool is null - restarting");
            			DatabaseController DB = new DatabaseController(routingContext.vertx());
            		}
            		LOGGER.debug("Postgres connection established");
                    
            		PostgresPool.getConnection(ar3 -> 
            		{
            			if (ar3.succeeded()) 
                        {
            				SqlConnection connection = ar3.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Select * from public.tb_stories where id = $1")
			                        .execute(Tuple.of(map.get("id")),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                // Process the query result
			                                RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	JsonObject jo = new JsonObject(row.toJson().encode());
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array");
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
			                                    }
			                                    
			                                });
			                                
			                                runStory(routingContext, ja);
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	response.send(res.cause().getMessage());
			                            }
			                            connection.close();
			                        });
            				
                         }
            			if(ar3.failed())
            			{
            				LOGGER.error("Unable to get stories from database: " + ar3.cause());
            				response.send("{\"result\":\""+ar3.cause()+"\"}");
            			}
                    });
                    /********************** ***************** ******************************/
	            }
			}
		}
	}
	/***********************************************************************/
	public static void runStory(RoutingContext routingContext, JsonArray ja)
	{
		LOGGER.debug("Running Story");
		HttpServerResponse response = routingContext.response();
		
		Vertx vertx = Vertx.vertx();
		
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		String jwt = JSONpayload.getString("jwt"); 
		String serverIP = routingContext.request().localAddress().host();
		int serverPort = routingContext.request().localAddress().port();
        
        JsonObject config = ja.getJsonObject(0);
		config.put("serverIP", serverIP);
        config.put("serverPort", serverPort);
        config.put("jwt", jwt);
        
        //Get the first story object
		
		vertx.deployVerticle(new RunStoryVerticle(),new DeploymentOptions().setWorker(true).setConfig(config), res -> {
            if (res.succeeded()) 
            {
                LOGGER.debug("Temporary Story task verticle deployed!");
            } 
            else 
            {
                LOGGER.error("Failed to deploy Story task verticle: " + res.cause());
            }
        });
		
		
		response.send(ja.encodePrettily());
	}
	/***********************************************************************/
	public static void handleGetAllStories(RoutingContext routingContext)
	{
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleGetAllStories required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				LOGGER.info("Accessible Level is : " + authlevel);
		        
		        if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response.putHeader("content-type", "application/json");
		        	
		        	Ram ram = new Ram();
	                /********************** Proceed to database activity ******************************/
                    Pool PostgresPool = ram.getPostGresSystemPool();
            		
            		if (PostgresPool == null)
            		{
            			LOGGER.debug("pool is null - restarting");
            			DatabaseController DB = new DatabaseController(routingContext.vertx());
            		}
            		LOGGER.debug("Postgres connection established");
                    
            		PostgresPool.getConnection(ar3 -> 
            		{
            			if (ar3.succeeded()) 
                        {
            				SqlConnection connection = ar3.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Select * from public.tb_stories")
			                        .execute(
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                // Process the query result
			                                RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	JsonObject jo = new JsonObject(row.toJson().encode());
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array");
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
			                                    }
			                                    
			                                });
			                                
			                    
			                                response.send(ja.encodePrettily());
			                                
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	response.send(res.cause().getMessage());
			                            }
			                            connection.close();
			                        });
            				
                         }
            			if(ar3.failed())
            			{
            				LOGGER.error("Unable to get stories from database: " + ar3.cause());
            				response.send("{\"result\":\""+ar3.cause()+"\"}");
            			}
                    });
                    /********************** ***************** ******************************/
	            }
			}
		}
	}
	
	
	public static void handleAddStory(RoutingContext routingContext)
	{
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		JsonObject result = new JsonObject();
		
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleAddStory required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(SetupPostHandlers.validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				LOGGER.info("Accessible Level is : " + authlevel);
		        
		        if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response.putHeader("content-type", "application/json");
		        	
		        	JsonObject story = JSONpayload.getJsonObject("story");
		        	
	                /*HERE WE ADD THE STORY OBJECT*/
	                
	                Ram ram = new Ram();
	                /********************** Proceed to database activity ******************************/
                    Pool PostgresPool = ram.getPostGresSystemPool();
            		
            		if (PostgresPool == null)
            		{
            			LOGGER.debug("pool is null - restarting");
            			DatabaseController DB = new DatabaseController(routingContext.vertx());
            		}
            		LOGGER.debug("Postgres connection established");
                    
            		PostgresPool.getConnection(ar3 -> 
            		{
            			if (ar3.succeeded()) 
                        {
                            SqlConnection PGconnection = ar3.result();
                            String sql = "insert into public.tb_stories(story) VALUES ($1)";
                            
                            PGconnection.preparedQuery(sql)
                            .execute(Tuple.of(story))
                            .onSuccess(res3 -> {
                            	LOGGER.debug("JSON Inserted Successfully!");
                            	response.send("{\"result\":\"ok\"}");
                            	PGconnection.close();
                            })
                            .onFailure(err -> {
                            	LOGGER.error("Failed to insert JSON: " + err.getMessage());
                            	PGconnection.close();
                            	response.send("{\"result\":\""+err.getMessage()+"\"}");
                            });
                         }
            			if(ar3.failed())
            			{
            				LOGGER.error("Unable to add story to database: " + ar3.cause());
            				response.send("{\"result\":\""+ar3.cause()+"\"}");
            			}
                    });
                    /********************** ***************** ******************************/
	            }
			}
		}
	}
	
	
	
	
	
}
