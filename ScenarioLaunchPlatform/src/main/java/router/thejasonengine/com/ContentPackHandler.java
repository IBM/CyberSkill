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
import io.vertx.core.CompositeFuture;
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
import io.vertx.core.buffer.Buffer;

/**
 * FIXED VERSION: This version properly coordinates all async operations using CompositeFuture
 * before sending the HTTP response. This ensures all database inserts complete successfully
 * before the client receives a success response.
 */
public class ContentPackHandler
{
	private static final Logger LOGGER = LogManager.getLogger(ContentPackHandler.class);

	public Handler<RoutingContext> installContentPack;
	public Handler<RoutingContext> uninstallContentPack;
	
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
		
		if (JSONpayload.getString("jwt") == null || JSONpayload.getString("pack_name") == null) 
	    {
	    	LOGGER.info("handleInstallContentPack required fields not detected (jwt or pack_name)");
	    	routingContext.fail(400);
	    	return;
	    } 
		
		if(!SetupPostHandlers.validateJWTToken(JSONpayload))
		{
			LOGGER.error("JWT validation failed");
			routingContext.fail(401);
			return;
		}
		
		LOGGER.info("User permitted to access handleInstallContentPack (JWT Check PASS)");
		String [] chunks = JSONpayload.getString("jwt").split("\\.");
		JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
		int authlevel  = Integer.parseInt(payload.getString("authlevel"));
		
		if(authlevel < 1)
		{
			LOGGER.error("User has insufficient access level: " + authlevel);
			routingContext.fail(403);
			return;
		}
		
		String pack_name = JSONpayload.getString("pack_name");
		LOGGER.debug("Attempting install process for pack_name: " + pack_name);
		
		Path currRelativePath = Paths.get("");
        String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
        
        // Start the installation process with proper async coordination
        installContentPackAsync(routingContext, context, pack_name, currAbsolutePathString)
        	.onSuccess(installResult -> {
        		LOGGER.info("Content pack installation completed successfully: " + pack_name);
        		response.putHeader("content-type", "application/json")
        			.end(new JsonObject()
        				.put("result", "success")
        				.put("message", "Content pack installed successfully")
        				.put("pack_name", pack_name)
        				.encode());
        	})
        	.onFailure(err -> {
        		LOGGER.error("Content pack installation failed: " + err.getMessage(), err);
        		if (!response.ended()) {
        			response.setStatusCode(500)
        				.putHeader("content-type", "application/json")
        				.end(new JsonObject()
        					.put("result", "error")
        					.put("message", "Installation failed: " + err.getMessage())
        					.encode());
        		}
        	});
	}
	
	/**
	 * Coordinates all async operations for content pack installation
	 */
	private Future<Void> installContentPackAsync(RoutingContext routingContext, Context context, 
			String pack_name, String basePath)
	{
		Promise<Void> promise = Promise.promise();
		
		// Create futures for all three file operations
		String queriesPath = basePath + "/contentpacks/" + pack_name + "/sql/query_inserts.json";
		String usersPath = basePath + "/contentpacks/" + pack_name + "/sql/users.json";
		String storiesPath = basePath + "/contentpacks/" + pack_name + "/sql/story_inserts.json";
		
		Future<Void> queriesFuture = processQueries(routingContext, context, queriesPath);
		Future<Void> usersFuture = processUsers(routingContext, context, usersPath);
		Future<Void> storiesFuture = processStories(routingContext, context, storiesPath);
		
		// Wait for all three operations to complete
		CompositeFuture.all(queriesFuture, usersFuture, storiesFuture)
			.onSuccess(compositResult -> {
				LOGGER.debug("All database operations completed successfully");
				
				// Now copy scripts folder (non-critical operation)
				copyScriptsFolder(routingContext, pack_name);
				
				// Update pack deployment status
				updatePackDeploymentStatus(context, pack_name)
					.onSuccess(v -> promise.complete())
					.onFailure(promise::fail);
			})
			.onFailure(err -> {
				LOGGER.error("One or more database operations failed: " + err.getMessage());
				promise.fail(err);
			});
		
		return promise.future();
	}
	
	/**
	 * Process query inserts
	 */
	private Future<Void> processQueries(RoutingContext routingContext, Context context, String filePath)
	{
		Promise<Void> promise = Promise.promise();
		
		LOGGER.debug("Processing queries from: " + filePath);
		
		readJsonFile(routingContext.vertx(), filePath)
			.compose(jo -> {
				JsonArray ja_queries = jo.getJsonArray("queries");
				if (ja_queries == null || ja_queries.isEmpty()) {
					LOGGER.warn("No queries found in file");
					return Future.succeededFuture();
				}
				
				Pool pool = context.get("pool");
				if (pool == null) {
					LOGGER.debug("Pool is null - initializing");
					new DatabaseController(routingContext.vertx());
					pool = context.get("pool");
				}
				
				return insertQueries(pool, ja_queries);
			})
			.onSuccess(v -> {
				LOGGER.debug("All queries processed successfully");
				promise.complete();
			})
			.onFailure(err -> {
				LOGGER.error("Failed to process queries: " + err.getMessage());
				promise.fail(err);
			});
		
		return promise.future();
	}
	
	/**
	 * Insert all queries using CompositeFuture
	 */
	private Future<Void> insertQueries(Pool pool, JsonArray ja_queries)
	{
		Promise<Void> promise = Promise.promise();
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			List<Future> queryFutures = new ArrayList<>();
			
			for(int i = 0; i < ja_queries.size(); i++)
			{
				JsonObject queryObject = ja_queries.getJsonObject(i);
				utils.thejasonengine.com.Encodings encodings = new utils.thejasonengine.com.Encodings();
				
				String query_string = queryObject.getString("query_string");
				String encoded_query = encodings.EscapeString(query_string);
				
				Integer id = queryObject.getInteger("id");
				String query_db_type = queryObject.getString("query_db_type");
				String query_type = queryObject.getString("query_type");
				String query_usecase = queryObject.getString("query_usecase");
				Integer db_connection_id = queryObject.getInteger("db_connection_id");
				Integer query_loop = queryObject.getInteger("query_loop");
				String query_description = queryObject.getString("query_description");
				String video_link = queryObject.getString("video_link");
				
				Promise<Void> queryPromise = Promise.promise();
				
				connection.preparedQuery("INSERT INTO public.tb_query(id, query_db_type, query_string, query_usecase, query_type, fk_tb_databaseConnections_id, query_loop, query_description, video_link) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)")
					.execute(Tuple.of(id, query_db_type, encoded_query, query_usecase, query_type, db_connection_id, query_loop, query_description, video_link))
					.onSuccess(res -> {
						LOGGER.info("Successfully added query [" + id + "]");
						queryPromise.complete();
					})
					.onFailure(err -> {
						LOGGER.error("Failed to insert query [" + id + "]: " + err.getMessage());
						queryPromise.fail(err);
					});
				
				queryFutures.add(queryPromise.future());
			}
			
			CompositeFuture.all(queryFutures)
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						promise.complete();
					} else {
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Process user/connection inserts
	 */
	private Future<Void> processUsers(RoutingContext routingContext, Context context, String filePath)
	{
		Promise<Void> promise = Promise.promise();
		
		LOGGER.debug("Processing users from: " + filePath);
		
		readJsonFile(routingContext.vertx(), filePath)
			.compose(jo -> {
				JsonArray ja_users = jo.getJsonArray("users");
				if (ja_users == null || ja_users.isEmpty()) {
					LOGGER.warn("No users found in file");
					return Future.succeededFuture();
				}
				
				Pool pool = context.get("pool");
				if (pool == null) {
					LOGGER.debug("Pool is null - initializing");
					new DatabaseController(routingContext.vertx());
					pool = context.get("pool");
				}
				
				return insertUsers(pool, ja_users);
			})
			.onSuccess(v -> {
				LOGGER.debug("All users processed successfully");
				promise.complete();
			})
			.onFailure(err -> {
				LOGGER.error("Failed to process users: " + err.getMessage());
				promise.fail(err);
			});
		
		return promise.future();
	}
	
	/**
	 * Insert all users using CompositeFuture
	 */
	private Future<Void> insertUsers(Pool pool, JsonArray ja_users)
	{
		Promise<Void> promise = Promise.promise();
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			List<Future> userFutures = new ArrayList<>();
			
			for(int i = 0; i < ja_users.size(); i++)
			{
				JsonObject userObj = ja_users.getJsonObject(i);
				
				Integer id = userObj.getInteger("id");
				String status = userObj.getString("status");
				String db_type = userObj.getString("db_type");
				String db_version = userObj.getString("db_version");
				String db_username = userObj.getString("db_username");
				String db_password = userObj.getString("db_password");
				String db_port = userObj.getString("db_port");
				String db_database = userObj.getString("db_database");
				String db_url = userObj.getString("db_url");
				String db_jdbcClassName = userObj.getString("db_jdbcClassName");
				String db_userIcon = userObj.getString("db_userIcon");
				String db_databaseIcon = userObj.getString("db_databaseIcon");
				String db_alias = userObj.getString("db_alias");
				String db_access = userObj.getString("db_access");
				String db_connection_id = db_type + "_" + db_url + "_" + db_database + "_" + db_username;
				
				Promise<Void> userPromise = Promise.promise();
				
				connection.preparedQuery("INSERT INTO public.tb_databaseConnections(id, status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon, db_alias, db_access) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15)")
					.execute(Tuple.of(id, status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon, db_alias, db_access))
					.onSuccess(res -> {
						LOGGER.info("Successfully added user connection [" + id + "]");
						userPromise.complete();
					})
					.onFailure(err -> {
						// Duplicate key is acceptable (connection already exists)
						if (err.getMessage().contains("duplicate key")) {
							LOGGER.info("User connection [" + id + "] already exists (acceptable)");
							userPromise.complete();
						} else {
							LOGGER.error("Failed to insert user connection [" + id + "]: " + err.getMessage());
							userPromise.fail(err);
						}
					});
				
				userFutures.add(userPromise.future());
			}
			
			CompositeFuture.all(userFutures)
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						promise.complete();
					} else {
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Process story inserts
	 */
	private Future<Void> processStories(RoutingContext routingContext, Context context, String filePath)
	{
		Promise<Void> promise = Promise.promise();
		
		LOGGER.debug("Processing stories from: " + filePath);
		
		readJsonFile(routingContext.vertx(), filePath)
			.compose(jo -> {
				JsonArray ja_stories = jo.getJsonArray("stories");
				if (ja_stories == null || ja_stories.isEmpty()) {
					LOGGER.warn("No stories found in file");
					return Future.succeededFuture();
				}
				
				Pool pool = context.get("pool");
				if (pool == null) {
					LOGGER.debug("Pool is null - initializing");
					new DatabaseController(routingContext.vertx());
					pool = context.get("pool");
				}
				
				return insertStories(pool, ja_stories);
			})
			.onSuccess(v -> {
				LOGGER.debug("All stories processed successfully");
				promise.complete();
			})
			.onFailure(err -> {
				LOGGER.error("Failed to process stories: " + err.getMessage());
				promise.fail(err);
			});
		
		return promise.future();
	}
	
	/**
	 * Insert all stories using CompositeFuture
	 */
	private Future<Void> insertStories(Pool pool, JsonArray ja_stories)
	{
		Promise<Void> promise = Promise.promise();
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			List<Future> storyFutures = new ArrayList<>();
			
			for(int i = 0; i < ja_stories.size(); i++)
			{
				JsonObject storyObj = ja_stories.getJsonObject(i);
				Integer id = storyObj.getInteger("id");
				JsonObject story = storyObj.getJsonObject("story");
				
				Promise<Void> storyPromise = Promise.promise();
				
				connection.preparedQuery("INSERT INTO public.tb_stories(id, story) VALUES ($1, $2)")
					.execute(Tuple.of(id, story))
					.onSuccess(res -> {
						LOGGER.info("Successfully added story [" + id + "]");
						storyPromise.complete();
					})
					.onFailure(err -> {
						LOGGER.error("Failed to insert story [" + id + "]: " + err.getMessage());
						storyPromise.fail(err);
					});
				
				storyFutures.add(storyPromise.future());
			}
			
			CompositeFuture.all(storyFutures)
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						promise.complete();
					} else {
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Copy scripts folder (non-critical operation)
	 */
	private void copyScriptsFolder(RoutingContext routingContext, String pack_name)
	{
		try
		{
			String jarDir = new File(getClass()
			        .getProtectionDomain()
			        .getCodeSource()
			        .getLocation()
			        .toURI())
			        .getParent();

			Path srcfolderPath = Paths.get(jarDir, "/contentpacks/" + pack_name + "/scripts");
			String sourceFolder = srcfolderPath.toString();
			
			Path dstfolderPath = Paths.get(jarDir, "/scripts/" + pack_name);
		   	String destinationFolder = dstfolderPath.toString();
		   	
		   	LOGGER.debug("Copying scripts from: " + sourceFolder + " to: " + destinationFolder);
		   	
		    FolderCopier.copyFolder(routingContext.vertx(), sourceFolder, destinationFolder, res -> 
		    {
		      if (res.succeeded()) {
		    	  LOGGER.debug("Scripts folder copied successfully");
		      } else {
		    	  LOGGER.warn("Failed to copy scripts folder (non-critical): " + res.cause().getMessage());
		      }
		    });
		}
		catch(Exception e)
		{
			LOGGER.warn("Unable to copy scripts folder (non-critical): " + e.getMessage());
		}
	}
	
	/**
	 * Update pack deployment status
	 */
	private Future<Void> updatePackDeploymentStatus(Context context, String pack_name)
	{
		Promise<Void> promise = Promise.promise();
		
		Pool pool = context.get("pool");
		if (pool == null) {
			LOGGER.debug("Pool is null - initializing");
			new DatabaseController(null);
			pool = context.get("pool");
		}
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			String sql = "UPDATE public.tb_content_packs SET pack_deployed = 'true' WHERE pack_name = $1";
			
			connection.preparedQuery(sql)
				.execute(Tuple.of(pack_name))
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						LOGGER.debug("Pack deployment status updated for: " + pack_name);
						promise.complete();
					} else {
						LOGGER.error("Failed to update pack deployment status: " + result.cause().getMessage());
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Uninstall handler with proper async coordination
	 */
	public void handleUninstallContentPack(RoutingContext routingContext)
	{
		LOGGER.debug("inside: handleUninstallContentPack ");
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null || JSONpayload.getString("pack_name") == null)
	    {
	    	LOGGER.info("handleUninstallContentPack required fields not detected (jwt or pack_name)");
	    	routingContext.fail(400);
	    	return;
	    }
		
		if(!SetupPostHandlers.validateJWTToken(JSONpayload))
		{
			LOGGER.error("JWT validation failed");
			routingContext.fail(401);
			return;
		}
		
		LOGGER.info("User permitted to access handleUninstallContentPack (JWT Check PASS)");
		String [] chunks = JSONpayload.getString("jwt").split("\\.");
		JsonObject payload = new JsonObject(SetupPostHandlers.decode(chunks[1]));
		int authlevel  = Integer.parseInt(payload.getString("authlevel"));
		
		if(authlevel < 1)
		{
			LOGGER.error("User has insufficient access level: " + authlevel);
			routingContext.fail(403);
			return;
		}
		
		String pack_name = JSONpayload.getString("pack_name");
		LOGGER.debug("Attempting uninstall process for pack_name: " + pack_name);
		
		Path currRelativePath = Paths.get("");
	       String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
	       String uninstallFilePath = currAbsolutePathString + "/contentpacks/" + pack_name + "/sql/uninstall.json";
	       
	       // Start the uninstallation process with proper async coordination
	       uninstallContentPackAsync(routingContext, context, pack_name, uninstallFilePath)
	       	.onSuccess(uninstallResult -> {
	       		LOGGER.info("Content pack uninstallation completed successfully: " + pack_name);
	       		response.putHeader("content-type", "application/json")
	       			.end(new JsonObject()
	       				.put("result", "success")
	       				.put("message", "Content pack uninstalled successfully")
	       				.put("pack_name", pack_name)
	       				.encode());
	       	})
	       	.onFailure(err -> {
	       		LOGGER.error("Content pack uninstallation failed: " + err.getMessage(), err);
	       		if (!response.ended()) {
	       			response.setStatusCode(500)
	       				.putHeader("content-type", "application/json")
	       				.end(new JsonObject()
	       					.put("result", "error")
	       					.put("message", "Uninstallation failed: " + err.getMessage())
	       					.encode());
	       		}
	       	});
	}
	
	/**
	 * Coordinates all async operations for content pack uninstallation
	 */
	private Future<Void> uninstallContentPackAsync(RoutingContext routingContext, Context context,
			String pack_name, String uninstallFilePath)
	{
		Promise<Void> promise = Promise.promise();
		
		// Read uninstall.json to get IDs to remove
		readJsonFile(routingContext.vertx(), uninstallFilePath)
			.compose(uninstallData -> {
				// Delete scripts folder
				deleteScriptsFolder(routingContext, pack_name);
				
				// Remove from database
				return removePackFromDatabase(context, pack_name, uninstallData);
			})
			.compose(v -> {
				// Update pack deployment status
				return updatePackDeploymentStatus(context, pack_name, false);
			})
			.onSuccess(v -> {
				LOGGER.debug("All uninstall operations completed successfully");
				promise.complete();
			})
			.onFailure(err -> {
				LOGGER.error("Uninstall operations failed: " + err.getMessage());
				promise.fail(err);
			});
		
		return promise.future();
	}
	
	/**
	 * Remove pack data from database
	 */
	private Future<Void> removePackFromDatabase(Context context, String pack_name, JsonObject uninstallData)
	{
		Promise<Void> promise = Promise.promise();
		
		Pool pool = context.get("pool");
		if (pool == null) {
			LOGGER.debug("Pool is null - initializing");
			new DatabaseController(null);
			pool = context.get("pool");
		}
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			List<Future> deleteFutures = new ArrayList<>();
			
			// Delete users/connections
			JsonArray ja_users = uninstallData.getJsonArray("users");
			if (ja_users != null) {
				for(int i = 0; i < ja_users.size(); i++) {
					final Integer id;
					Object item = ja_users.getValue(i);
					
					// Handle both formats: plain integer or object with "id" property
					if (item instanceof Integer) {
						id = (Integer) item;
					} else if (item instanceof JsonObject) {
						id = ((JsonObject) item).getInteger("id");
					} else {
						LOGGER.warn("Unexpected user entry format at index " + i + ": " + item);
						continue;
					}
					
					Promise<Void> deletePromise = Promise.promise();
					connection.preparedQuery("DELETE FROM public.tb_databaseConnections WHERE id = $1")
						.execute(Tuple.of(id))
						.onSuccess(res -> {
							LOGGER.debug("user id: " + id + " tb_databaseconnections removed from database");
							deletePromise.complete();
						})
						.onFailure(err -> {
							LOGGER.warn("Failed to delete user connection [" + id + "]: " + err.getMessage());
							deletePromise.complete(); // Continue even if delete fails
						});
					deleteFutures.add(deletePromise.future());
				}
			}
			
			// Delete queries
			JsonArray ja_queries = uninstallData.getJsonArray("queries");
			if (ja_queries != null) {
				for(int i = 0; i < ja_queries.size(); i++) {
					final Integer id;
					Object item = ja_queries.getValue(i);
					
					// Handle both formats: plain integer or object with "id" property
					if (item instanceof Integer) {
						id = (Integer) item;
					} else if (item instanceof JsonObject) {
						id = ((JsonObject) item).getInteger("id");
					} else {
						LOGGER.warn("Unexpected query entry format at index " + i + ": " + item);
						continue;
					}
					
					Promise<Void> deletePromise = Promise.promise();
					connection.preparedQuery("DELETE FROM public.tb_query WHERE id = $1")
						.execute(Tuple.of(id))
						.onSuccess(res -> {
							LOGGER.debug("query id: " + id + " tb_query removed from database");
							deletePromise.complete();
						})
						.onFailure(err -> {
							LOGGER.warn("Failed to delete query [" + id + "]: " + err.getMessage());
							deletePromise.complete(); // Continue even if delete fails
						});
					deleteFutures.add(deletePromise.future());
				}
			}
			
			// Delete stories
			JsonArray ja_stories = uninstallData.getJsonArray("stories");
			if (ja_stories != null) {
				for(int i = 0; i < ja_stories.size(); i++) {
					final Integer id;
					Object item = ja_stories.getValue(i);
					
					// Handle both formats: plain integer or object with "id" property
					if (item instanceof Integer) {
						id = (Integer) item;
					} else if (item instanceof JsonObject) {
						id = ((JsonObject) item).getInteger("id");
					} else {
						LOGGER.warn("Unexpected story entry format at index " + i + ": " + item);
						continue;
					}
					
					Promise<Void> deletePromise = Promise.promise();
					connection.preparedQuery("DELETE FROM public.tb_stories WHERE id = $1")
						.execute(Tuple.of(id))
						.onSuccess(res -> {
							LOGGER.debug("story id: " + id + " tb_stories removed from database");
							deletePromise.complete();
						})
						.onFailure(err -> {
							LOGGER.warn("Failed to delete story [" + id + "]: " + err.getMessage());
							deletePromise.complete(); // Continue even if delete fails
						});
					deleteFutures.add(deletePromise.future());
				}
			}
			
			CompositeFuture.all(deleteFutures)
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						promise.complete();
					} else {
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Delete scripts folder (non-critical operation)
	 */
	private void deleteScriptsFolder(RoutingContext routingContext, String pack_name)
	{
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
		   	
		   	LOGGER.debug("Deleting scripts folder: " + destinationFolder);
		   	
		    utils.thejasonengine.com.FolderDelete.deleteDirectory(routingContext.vertx(), destinationFolder, res ->
		    {
		      if (res.succeeded()) {
		    	  LOGGER.debug("Folder deleted successfully: " + destinationFolder);
		      } else {
		    	  LOGGER.warn("Failed to delete scripts folder (non-critical): " + res.cause().getMessage());
		      }
		    });
		}
		catch(Exception e)
		{
			LOGGER.warn("Unable to delete scripts folder (non-critical): " + e.getMessage());
		}
	}
	
	/**
	 * Update pack deployment status (overloaded for uninstall)
	 */
	private Future<Void> updatePackDeploymentStatus(Context context, String pack_name, boolean deployed)
	{
		Promise<Void> promise = Promise.promise();
		
		Pool pool = context.get("pool");
		if (pool == null) {
			LOGGER.debug("Pool is null - initializing");
			new DatabaseController(null);
			pool = context.get("pool");
		}
		
		pool.getConnection(ar -> {
			if (ar.failed()) {
				promise.fail("Failed to get database connection: " + ar.cause().getMessage());
				return;
			}
			
			SqlConnection connection = ar.result();
			String sql = "UPDATE public.tb_content_packs SET pack_deployed = $1 WHERE pack_name = $2";
			
			connection.preparedQuery(sql)
				.execute(Tuple.of(String.valueOf(deployed), pack_name))
				.onComplete(result -> {
					connection.close();
					if (result.succeeded()) {
						LOGGER.debug("Pack_name: " + pack_name + " tb_content_packs deployment updated to " + deployed);
						promise.complete();
					} else {
						LOGGER.error("Failed to update pack deployment status: " + result.cause().getMessage());
						promise.fail(result.cause());
					}
				});
		});
		
		return promise.future();
	}
	
	/**
	 * Read JSON file helper
	 */
	public static Future<JsonObject> readJsonFile(Vertx vertx, String filePath) 
	{
	     LOGGER.debug("Reading JSON File: " + filePath); 
		 Promise<JsonObject> promise = Promise.promise();
	      vertx.fileSystem().readFile(filePath, ar -> 
	      {
	    	if (ar.succeeded()) 
	   	   	{
	       	    Buffer buffer = ar.result();
	       	    JsonObject json = buffer.toJsonObject();
	       	    promise.complete(json);
	   	   	} 
	   	   	else 
	   	   	{
	   	   		LOGGER.error("Failed to read file: " + filePath + " - " + ar.cause().getMessage());
	   	   		promise.fail("Failed to read file: " + filePath + " - " + ar.cause().getMessage());
	   	   	}
	      });
		  return promise.future();
	}
}
