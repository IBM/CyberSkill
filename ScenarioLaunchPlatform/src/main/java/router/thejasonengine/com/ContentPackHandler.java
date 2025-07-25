package router.thejasonengine.com;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import database.thejasonengine.com.DatabaseController;
import io.vertx.core.Context;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;
import utils.thejasonengine.com.FolderCopier;
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
		JsonObject result = new JsonObject();
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		String pack_name = "tmp";
		
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
		        
					/*read the json file*/
					pack_name = JSONpayload.getString("pack_name");
					LOGGER.debug("Attempting install process for pack_name: " + pack_name);
					
					Path currRelativePath = Paths.get("");
			        String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
			        
			        
			        String filePath = currAbsolutePathString + "/contentpacks/" + pack_name + "/sql/query_inserts.json";
			        LOGGER.debug("System execution path is: " + filePath);
			        
			       
			        readJsonFile(routingContext.vertx(), filePath)
			        .onComplete(ar -> 
			        {
			        	LOGGER.debug("All lines have been read");
			        	JsonObject jo = ar.result();
			            Pool pool = context.get("pool");
			            if (pool == null)
			        	{
			        		LOGGER.debug("pool is null - restarting");
			        		DatabaseController DB = new DatabaseController(routingContext.vertx());
			        		LOGGER.debug("Taking the refreshed context pool object");
			        		pool = context.get("pool");
			        	}
			            pool.getConnection(asyncreq -> 
						{	
								if (asyncreq.succeeded()) 
						        {
						         	SqlConnection connection = asyncreq.result();
						           	JsonArray ja_queries = jo.getJsonArray("queries");
			        			
						           	for(int i = 0; i < ja_queries.size(); i++)
						           	{
						           		/*
						           		 This needs to be a composit future as its an asyn call in a for loop. 
						           		 until that's done, this wont return an accurate completion state.
						           		 */
						           		Map<String,Object> map = new HashMap<String, Object>();
										
						           		JsonObject queryObject = ja_queries.getJsonObject(i);
						           		
						           		utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
										
						           		String query_string = queryObject.getString("query_string");
										String encoded_query = Encodings.EscapeString(query_string);
										
										/*
										LOGGER.debug("Query recieved: " + query_string);
										LOGGER.debug("Query encoded: " + encoded_query);
										
										LOGGER.debug("id: " + queryObject.getInteger("id"));
										LOGGER.debug("query_db_type" + queryObject.getString("query_db_type"));
										LOGGER.debug("query_type", queryObject.getString("query_type"));
										LOGGER.debug("query_usecase" + queryObject.getString("query_usecase"));
										LOGGER.debug("encoded_query" +  encoded_query);
										LOGGER.debug("db_connection_id" +  queryObject.getInteger("db_connection_id"));
										LOGGER.debug("query_loop"+ queryObject.getInteger("query_loop"));
										LOGGER.debug("video_link"+ queryObject.getString("video_link"));
										*/
										
										map.put("id", queryObject.getInteger("id"));
										map.put("query_db_type", queryObject.getString("query_db_type"));
										map.put("query_type", queryObject.getString("query_type"));
										map.put("query_usecase", queryObject.getString("query_usecase"));
										map.put("encoded_query", encoded_query);
										map.put("db_connection_id", queryObject.getInteger("db_connection_id"));
										map.put("query_loop", queryObject.getInteger("query_loop"));
										map.put("query_description", queryObject.getString("query_description"));
										map.put("video_link", queryObject.getString("video_link"));
						           		
										
										connection.preparedQuery("Insert into public.tb_query(id, query_db_type, query_string, query_usecase, query_type, fk_tb_databaseConnections_id,query_loop, query_description, video_link) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9);")
				                        .execute(Tuple.of(map.get("id"), map.get("query_db_type"), map.get("encoded_query"), map.get("query_usecase"), map.get("query_type"), map.get("db_connection_id"), map.get("query_loop"), map.get("query_description"),  map.get("video_link")),
				                        res -> {
				                            if (res.succeeded()) 
					                            {
					                                // Process the query result
					                                LOGGER.info("Successfully added json object to query array ["+ map.get("id") +"]: " + res.toString());
			                                    } 
					                            else 
					                            {
					                                // Handle query failure
					                            	LOGGER.error("error: " + res.cause() );
					                            	result.put("database_write", "Error writting query to database: " + res.cause().getLocalizedMessage().replaceAll("\"", "") );
					                            }
					                            //connection.close();
					                        });
						           	}
						           	result.put("database_write", "All queries install processed");
						           	
			    		        }
								else
								{
									LOGGER.error("User has incorrect access level");
									result.put("access_response", "User has incorrect access level (Access Check FAIL");
								}
						});
			
			        });
			        
			        
			        
			        
			        
			        /**********************************************************************************************************/
			        filePath = currAbsolutePathString + "/contentpacks/" + pack_name + "/sql/users.json";
			        LOGGER.debug("System execution path is: " + filePath);
			        
			       
			        readJsonFile(routingContext.vertx(), filePath)
			        .onComplete(ar -> 
			        {
			        	LOGGER.debug("All user lines have been read");
			        	JsonObject jo = ar.result();
			            Pool pool = context.get("pool");
			            if (pool == null)
			        	{
			        		LOGGER.debug("pull is null - restarting");
			        		DatabaseController DB = new DatabaseController(routingContext.vertx());
			        		LOGGER.debug("Taking the refreshed context pool object");
			        		pool = context.get("pool");
			        	}
			            pool.getConnection(asyncreq -> 
						{	
								if (asyncreq.succeeded()) 
						        {
						         	SqlConnection connection = asyncreq.result();
						           	JsonArray ja_users = jo.getJsonArray("users");
			        			
						           	for(int i = 0; i < ja_users.size(); i++)
						           	{
						           		
						           		
						           		JsonObject JsonOb = ja_users.getJsonObject(i);
						           		/*
						           		 This needs to be a composit future as its an asyn call in a for loop. 
						           		 until that's done, this wont return an accurate completion state.
						           		 */
						           		Integer id = JsonOb.getInteger("id");
						           		String status = JsonOb.getString("status");
										String db_type = JsonOb.getString("db_type");
										String db_version = JsonOb.getString("db_version");
										String db_username = JsonOb.getString("db_username");
										String db_password = JsonOb.getString("db_password");
										String db_port = JsonOb.getString("db_port");
										String db_database= JsonOb.getString("db_database");
										String db_url = JsonOb.getString("db_url");
										String db_jdbcClassName = JsonOb.getString("db_jdbcClassName");
										String db_userIcon = JsonOb.getString("db_userIcon");
										String db_databaseIcon = JsonOb.getString("db_databaseIcon");
										String db_alias = JsonOb.getString("db_alias");
										String db_access = JsonOb.getString("db_access");
										
										
										String db_connection_id = db_type+"_"+db_url+"_"+db_database+"_"+db_username;
										/*
										LOGGER.debug("id recieved: " + id);
										LOGGER.debug("db_type recieved: " + db_type);
										LOGGER.debug("db_connection_id recieved: " + db_connection_id);
										LOGGER.debug("db_version recieved: " + db_version);
										LOGGER.debug("db_username recieved: " + db_username);
										LOGGER.debug("db_password recieved: " + db_password);
										LOGGER.debug("db_port recieved: " + db_port);
										LOGGER.debug("db_database recieved: " + db_database);
										LOGGER.debug("db_url recieved: " + db_url);
										LOGGER.debug("db_jdbcClassName recieved: " + db_jdbcClassName);
										LOGGER.debug("db_userIcon recieved: " + db_userIcon);
										LOGGER.debug("db_databaseIcon recieved: " + db_databaseIcon);
										LOGGER.debug("db_alias recieved: " + db_alias);
										LOGGER.debug("db_access recieved: " + db_access);
										*/
										connection.preparedQuery("Insert into public.tb_databaseConnections(id, status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon,db_alias,db_access) values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)")
				                        .execute(Tuple.of(id, status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon,db_alias,db_access),
				                        res -> {
				                            if (res.succeeded()) 
				                            {
				                                
				                            	
				                            	LOGGER.info("Successfully added json object to connection db ["+ id +"]");
				                            	
		                                    } 
				                            else 
				                            {
				                            	LOGGER.info("Unable to add json object to db connection : [ " +id + "] " + res.toString());
		                                    }
				                        });
										result.put("database_write", "All queries install processed");
							        }
						        }
								else
								{
									LOGGER.error("User has incorrect access level");
									result.put("access_response", "User has incorrect access level (Access Check FAIL");
								}
						});
			
			            
			        });
			        
			        
			        
			        
			        /**********************************************************************************************************/
			        filePath = currAbsolutePathString + "/contentpacks/" + pack_name + "/sql/story_inserts.json";
			        LOGGER.debug("System execution path is: " + filePath);
			        
			       
			        readJsonFile(routingContext.vertx(), filePath)
			        .onComplete(ar -> 
			        {
			        	LOGGER.debug("All story lines have been read");
			        	JsonObject jo = ar.result();
			            Pool pool = context.get("pool");
			            if (pool == null)
			        	{
			        		LOGGER.debug("pull is null - restarting");
			        		DatabaseController DB = new DatabaseController(routingContext.vertx());
			        		LOGGER.debug("Taking the refreshed context pool object");
			        		pool = context.get("pool");
			        	}
			            pool.getConnection(asyncreq -> 
						{	
								if (asyncreq.succeeded()) 
						        {
						         	SqlConnection connection = asyncreq.result();
						           	JsonArray ja_stories = jo.getJsonArray("stories");
			        			
						           	for(int i = 0; i < ja_stories.size(); i++)
						           	{
						           		
						           		
						           		JsonObject JsonOb = ja_stories.getJsonObject(i);
						           		Integer id = JsonOb.getInteger("id");
						           		JsonObject story = JsonOb.getJsonObject("story");
						           		String sql = "insert into public.tb_stories(id, story) VALUES ($1, $2)";
				                            
				                            connection.preparedQuery(sql)
				                            .execute(Tuple.of(id, story))
				                            .onSuccess(res3 -> {
				                            	LOGGER.debug("JSON story Inserted Successfully!");
				                            })
				                            .onFailure(err -> {
				                            	LOGGER.error("Failed to insert JSON story: " + err.getMessage());
				                            });
				                         }
						        }
								else
								{
									LOGGER.error("User has incorrect access level");
									result.put("access_response", "User has incorrect access level (Access Check FAIL");
								}
						});
			            
			        });
			        
		        }
				
			}
			
		}  
		
		/*Now lets move the chron tasks to the right folder*/
		boolean enableContentPackCronActivity = true;
		if(enableContentPackCronActivity)
		{
			LOGGER.debug("****************************** Enabling content pack cron activity **************************************");
			try
			{
				String jarDir = new File(getClass()
				        .getProtectionDomain()
				        .getCodeSource()
				        .getLocation()
				        .toURI())
				        .getParent();
	
				    // Folder path relative to the JAR
				    Path srcfolderPath = Paths.get(jarDir, "/contentpacks/" + pack_name + "/scripts");
				    String sourceFolder = srcfolderPath.toString();
				    LOGGER.debug("Creating content in: " + sourceFolder);
				    
				    Path dstfolderPath = Paths.get(jarDir, "/scripts/" + pack_name);
				   	String destinationFolder = dstfolderPath.toString();
				   	LOGGER.debug("Creating content in: " + destinationFolder);
				   	
				    FolderCopier.copyFolder(routingContext.vertx(), sourceFolder, destinationFolder, res -> 
				    {
				      if (res.succeeded()) 
				      {
				    	  LOGGER.debug("Folder copied successfully!");
				      } 
				      else 
				      {
				    	  LOGGER.error("Failed to copy folder: " + res.cause());
				      }
				    });
			}
			catch(Exception e)
			{
				LOGGER.error("Unable to calculate system path: " + e.getLocalizedMessage());
			}
		}
		else
		{
			LOGGER.debug("************************** Not enabling content pack cron activity *******************************************");
		}
		/***************************/
        Pool pool = context.get("pool");
        if (pool == null)
    	{
    		LOGGER.debug("poll is null - restarting");
    		DatabaseController DB = new DatabaseController(routingContext.vertx());
    		LOGGER.debug("Taking the refreshed context pool object");
    		pool = context.get("pool");
    	}
        pool.getConnection(asyncreq -> 
		{	
				if (asyncreq.succeeded()) 
		        {
					SqlConnection connection = asyncreq.result();
					String sql = "UPDATE public.tb_content_packs SET pack_deployed = 'true' WHERE pack_name = $1";
                    connection.preparedQuery(sql)
                    .execute(Tuple.of(JSONpayload.getString("pack_name")))
                        .onSuccess(res3 -> {
                        	LOGGER.debug("Pack_name: " + JSONpayload.getString("pack_name")+ " tb_content_packs deployment updated to true");
                        })
                        .onFailure(err -> {
                        	LOGGER.error("Pack_name: " + JSONpayload.getString("pack_name")+ " tb_content_packs deployment status failed to update" + err.getLocalizedMessage());
                        });
		        }
		});
		response.send("{\"result\":\"Operation submitted\"}");
	}
	public void handleUninstallContentPack(RoutingContext routingContext)
	{
		LOGGER.debug("inside: handleUninstallContentPack ");
		Context context = routingContext.vertx().getOrCreateContext();
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
		        
					/*read the json file*/
					String pack_name = JSONpayload.getString("pack_name");
					LOGGER.debug("Attempting uninstall process for pack_name: " + pack_name);
					
					Path currRelativePath = Paths.get("");
			        String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
			        
			        
			        String filePath = currAbsolutePathString + "/contentpacks/" + pack_name + "/sql/uninstall.json";
			        LOGGER.debug("System execution path is: " + filePath);
			        
			       
			        readJsonFile(routingContext.vertx(), filePath)
			        .onComplete(ar -> 
			        {
			        	JsonObject jo = ar.result();
			        	JsonArray users = jo.getJsonArray("users");
			        	JsonArray queries = jo.getJsonArray("queries");
			        	JsonArray stories = jo.getJsonArray("stories");
			        	
			        	Pool pool = context.get("pool");
			            if (pool == null)
			        	{
			        		LOGGER.debug("poll is null - restarting");
			        		DatabaseController DB = new DatabaseController(routingContext.vertx());
			        		LOGGER.debug("Taking the refreshed context pool object");
			        		pool = context.get("pool");
			        	}
			            pool.getConnection(asyncreq -> 
						{	
								if (asyncreq.succeeded()) 
						        {
									SqlConnection connection = asyncreq.result();
									
									for(int i = 0; i < users.size(); i++ )
									{
										JsonObject user = users.getJsonObject(i);
										
										String sql = "delete from public.tb_databaseconnections where id = $1";
			                            connection.preparedQuery(sql)
			                            .execute(Tuple.of(user.getInteger("id")))
			                            .onSuccess(res3 -> {
			                            	LOGGER.debug("user id: " + user.getInteger("id") + " tb_databaseconnections removed from database");
			                            })
			                            .onFailure(err -> {
			                            	LOGGER.error("user id: " + user.getInteger("id") + " tb_databaseconnections not removed from database " + err.getLocalizedMessage());
			                            });
			                         }
									
									for(int i = 0; i < queries.size(); i++ )
									{
										JsonObject query = queries.getJsonObject(i);
										
										String sql = "delete from public.tb_query where id = $1";
			                            connection.preparedQuery(sql)
			                            .execute(Tuple.of(query.getInteger("id")))
			                            .onSuccess(res3 -> {
			                            	LOGGER.debug("query id: " + query.getInteger("id") + " tb_query removed from database");
			                            })
			                            .onFailure(err -> {
			                            	LOGGER.error("query id: " + query.getInteger("id") + " tb_query not removed from database " + err.getLocalizedMessage());
			                            });
									}
									for(int i = 0; i < stories.size(); i++ )
									{
										JsonObject story = stories.getJsonObject(i);
										
										String sql = "delete from public.tb_stories where id = $1";
			                            connection.preparedQuery(sql)
			                            .execute(Tuple.of(story.getInteger("id")))
			                            .onSuccess(res3 -> {
			                            	LOGGER.debug("story id: " + story.getInteger("id") + " tb_stories removed from database");
			                            })
			                            .onFailure(err -> {
			                            	LOGGER.error("story id: " + story.getInteger("id") + " tb_stories not removed from database " + err.getLocalizedMessage());
			                            });	
									}
									
						        }
						});
			        });
			        
			        try
					{
						String jarDir = new File(getClass()
						        .getProtectionDomain()
						        .getCodeSource()
						        .getLocation()
						        .toURI())
						        .getParent();
			
			        Path dstfolderPath = Paths.get(jarDir, "/scripts/" + pack_name);
				   	String destinationFolder = dstfolderPath.toString();
				   	LOGGER.debug("Creating content in: " + destinationFolder);
				   	
				  
				        utils.thejasonengine.com.FolderDelete.deleteDirectory(routingContext.vertx(), destinationFolder, res -> 
				        {
				        	if (res.succeeded()) 
						    {
						    	  LOGGER.debug("Folder deleted successfully: " + destinationFolder );
						    } 
						    else 
						    {
						    	  LOGGER.error("Failed to delete folder: " + res.cause());
						    }
				        });
					}
			        catch(Exception e)
			        {
			        	LOGGER.error("Unable to delete directory: " + e.toString());
			        }
			        
			        /***************************/
			        Pool pool = context.get("pool");
		            if (pool == null)
		        	{
		        		LOGGER.debug("poll is null - restarting");
		        		DatabaseController DB = new DatabaseController(routingContext.vertx());
		        		LOGGER.debug("Taking the refreshed context pool object");
		        		pool = context.get("pool");
		        	}
		            pool.getConnection(asyncreq -> 
					{	
							if (asyncreq.succeeded()) 
					        {
								SqlConnection connection = asyncreq.result();
								String sql = "UPDATE public.tb_content_packs SET pack_deployed = 'false' WHERE pack_name = $1";
		                        connection.preparedQuery(sql)
		                        .execute(Tuple.of(pack_name))
		                            .onSuccess(res3 -> {
		                            	LOGGER.debug("Pack_name: " + pack_name+ " tb_content_packs deployment updated to false");
		                            })
		                            .onFailure(err -> {
		                            	LOGGER.error("Pack_name: " + pack_name+ " tb_content_packs deployment status failed to update" + err.getLocalizedMessage());
		                            });
					        }
					});
			        
			        
		        }
			}
		}
		response.send("{\"result\":\"Operation submitted\"}");
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
	 public static Future<JsonObject> readJsonFile(Vertx vertx, String filePath) 
	 {
	     LOGGER.debug("Reading JSON File: ", filePath); 
		 Promise<JsonObject> promise = Promise.promise();
	      vertx.fileSystem().readFile(filePath, ar -> 
	      {
	    	if (ar.succeeded()) 
	   	   	{
	       	    Buffer buffer = ar.result();
	       	    JsonObject json = buffer.toJsonObject();
	       	    //LOGGER.debug("JSON: " + json.encodePrettily());
	       	    promise.complete(json);
	   	   	} 
	   	   	else 
	   	   	{
	   	   		LOGGER.error("Failed to read file: " +filePath+" - "+ ar.cause().getMessage());
	   	   		promise.fail("Failed to read file: " +filePath+" - "+ ar.cause().getMessage());
	   	   	}
	      });
		  return promise.future();
	 }
}
