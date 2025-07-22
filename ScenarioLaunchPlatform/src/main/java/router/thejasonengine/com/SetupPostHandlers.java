/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import java.io.UnsupportedEncodingException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.Random;

import io.vertx.core.MultiMap;
import io.vertx.core.Promise;

import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import io.vertx.ext.web.FileUpload;
import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import utils.thejasonengine.com.ContentPackUtils;
import utils.thejasonengine.com.OSDetectorAndTaskControl;
import com.hazelcast.shaded.org.json.JSONObject;

import authentication.thejasonengine.com.AuthUtils;
import database.thejasonengine.com.DatabaseController;
import demodata.thejasonengine.com.BruteForceDBConnections;
import demodata.thejasonengine.com.DatabasePoolManager;
import demodata.thejasonengine.com.DatabasePoolPOJO;
import io.vertx.core.AsyncResult;
import io.vertx.core.Context;
import io.vertx.core.Future;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.Cookie;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.JWTOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.templ.freemarker.FreeMarkerTemplateEngine;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.SqlClient;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;
import memory.thejasonengine.com.Ram;
import io.vertx.core.http.HttpHeaders;

import session.thejasonengine.com.SetupSession;

public class SetupPostHandlers 
{
	private static final Logger LOGGER = LogManager.getLogger(SetupPostHandlers.class);
	
	public Handler<RoutingContext> simpleTest; 
	public Handler<RoutingContext> simpleDBTest;
	public Handler<RoutingContext> validateCredentials;
	public Handler<RoutingContext> createCookie;
	public Handler<RoutingContext> createSession;
	public Handler<RoutingContext> validateUserStatus;
	public Handler<RoutingContext> webLogin;
	public Handler<RoutingContext> addDatabaseQuery;
	public Handler<RoutingContext> getDatabaseQueryByDbType;
	public Handler<RoutingContext> getMySystemVariables;
	public Handler<RoutingContext> setMySystemVariables;
	public Handler<RoutingContext> getDatabaseQueryByQueryId;
	public Handler<RoutingContext> getDatabaseQuery; 
	public Handler<RoutingContext> getDatabaseConnections;
	public Handler<RoutingContext> getDatabaseConnectionsById;
	public Handler<RoutingContext> deleteDatabaseConnectionsById;
	public Handler<RoutingContext> updateDatabaseConnectionById;
	public Handler<RoutingContext> setDatabaseConnections;
	public Handler<RoutingContext> runDatabaseQueryByDatasourceMap;
	public Handler<RoutingContext> runDatabaseQueryByDatasourceMapAndQueryId;
	public Handler<RoutingContext> deleteDatabaseQueryByQueryId;
	public Handler<RoutingContext> updateDatabaseQueryByQueryId;
	public Handler<RoutingContext> toggleDatabaseConnectionStatusByID;
	public Handler<RoutingContext> getValidatedDatabaseConnections;
	public Handler<RoutingContext> getAllDatabaseConnections;
	public Handler<RoutingContext> getRefreshedDatabaseConnections;
	public Handler<RoutingContext> getQueryTypes;
	public Handler<RoutingContext> deleteQueryTypesByID;
	public Handler<RoutingContext> addQueryTypes;
	public Handler<RoutingContext> addScheduleJob;
	public Handler<RoutingContext> getScheduleJobs;
	public Handler<RoutingContext> deleteScheduleJobById;
	public Handler<RoutingContext> monitorGuardium;
	public Handler<RoutingContext> getMonitorGuardiumSourcesForCron;
	public Handler<RoutingContext> getMonitorGuardiumSources;
	public Handler<RoutingContext> getMonitorGuardiumSourceMessageStatById;
	public Handler<RoutingContext> getMonitorGuardiumDataByMessageIdHash;
	public Handler<RoutingContext> getMonitorGuardiumDataByMessageIdHashAndInternalId;
	public Handler<RoutingContext> addOSTask;
	public Handler<RoutingContext> getOSTasks;
	public Handler<RoutingContext> getOSTaskByTaskId;
	
	public Handler<RoutingContext> deleteOSTaskByTaskId;
	public Handler<RoutingContext> addPack;
	public Handler<RoutingContext> getPacks;
	public Handler<RoutingContext> getPackByPackId;
	public Handler<RoutingContext> deletePackByPackId;
	public Handler<RoutingContext> getDatabaseVersion;
	public Handler<RoutingContext> addStory;
	public Handler<RoutingContext> getAllStories;
	public Handler<RoutingContext> runStoryById;
	public Handler<RoutingContext> deleteStoryById;
	public Handler<RoutingContext> getAvailablePlugins;
	
	public Handler<RoutingContext> getSwagger;
	

	
	
	public SetupPostHandlers(Vertx vertx)
    {
		simpleTest = SetupPostHandlers.this::handleSimpleTest;
		simpleDBTest = SetupPostHandlers.this::handleSimpleDBTest;
		validateCredentials = SetupPostHandlers.this::handleValidateCredentials;
		createCookie = SetupPostHandlers.this::handleCreateCookie;
		createSession = SetupPostHandlers.this::handleCreateSession;
		validateUserStatus =  SetupPostHandlers.this::handleValidateUserStatus;
		webLogin = SetupPostHandlers.this::handleWebLogin;
		addDatabaseQuery = SetupPostHandlers.this::handleAddDatabaseQuery;
		getDatabaseQueryByDbType = SetupPostHandlers.this::handleGetDatabaseQueryByDbType;
		getDatabaseQueryByQueryId = SetupPostHandlers.this::handleGetDatabaseQueryByQueryId;
		deleteDatabaseQueryByQueryId = SetupPostHandlers.this::handleDeleteDatabaseQueryByQueryId;
		updateDatabaseQueryByQueryId = SetupPostHandlers.this::handleUpdateDatabaseQueryByQueryId;
		
		toggleDatabaseConnectionStatusByID = SetupPostHandlers.this::handleToggleDatabaseConnectionStatusByID;
		
		getDatabaseQuery = SetupPostHandlers.this::handleGetDatabaseQuery;
		getQueryTypes = SetupPostHandlers.this::handleGetQueryTypes;
		deleteQueryTypesByID = SetupPostHandlers.this::handleDeleteQueryTypesByID;
		addQueryTypes = SetupPostHandlers.this::handleAddQueryTypes;
		getDatabaseConnections = SetupPostHandlers.this::handleGetDatabaseConnections;
		getAllDatabaseConnections = SetupPostHandlers.this::handleGetAllDatabaseConnections;
		getRefreshedDatabaseConnections =SetupPostHandlers.this::handleGetRefreshedDatabaseConnections;
		getDatabaseConnectionsById = SetupPostHandlers.this::handleGetDatabaseConnectionsByID;
		deleteDatabaseConnectionsById = SetupPostHandlers.this::handleDeleteDatabaseConnectionsByID;
		updateDatabaseConnectionById = SetupPostHandlers.this::handleUpdateDatabaseConnectionById;
		setDatabaseConnections = SetupPostHandlers.this::handleSetDatabaseConnections;
		runDatabaseQueryByDatasourceMap = SetupPostHandlers.this::handleRunDatabaseQueryByDatasourceMap;
		runDatabaseQueryByDatasourceMapAndQueryId = SetupPostHandlers.this::handleRunDatabaseQueryByDatasourceMapAndQueryId;
		
		getDatabaseVersion  = SetupPostHandlers.this::handleGetDatabaseVersion;
		
		getValidatedDatabaseConnections = SetupPostHandlers.this::handleGetValidatedDatabaseConnections;
		addScheduleJob = SetupPostHandlers.this::handleAddScheduleJob;
		getScheduleJobs = SetupPostHandlers.this::handleGetScheduleJobs;
		deleteScheduleJobById = SetupPostHandlers.this::handleDeleteScheduleJobById;
		
		monitorGuardium = SetupPostHandlers.this::handleMonitorGuardium;
		getMonitorGuardiumSourcesForCron = SetupPostHandlers.this::handleGetMonitorGuardiumSourcesForCron;
		getMonitorGuardiumSources = SetupPostHandlers.this::handleGetMonitorGuardiumSources;
		getMonitorGuardiumSourceMessageStatById = SetupPostHandlers.this::handleGetMonitorGuardiumSourceMessageStatById;
		getMonitorGuardiumDataByMessageIdHash = SetupPostHandlers.this::handleGetMonitorGuardiumDataByMessageIdHash;
		getMonitorGuardiumDataByMessageIdHashAndInternalId = SetupPostHandlers.this::handleGetMonitorGuardiumDataByMessageIdHashAndInternalId;
		
		addOSTask = SetupPostHandlers.this::handleAddOSTask;
		getOSTasks = SetupPostHandlers.this::handleGetOSTasks;
		getOSTaskByTaskId = SetupPostHandlers.this::handleGetOSTasksByTaskId;
		deleteOSTaskByTaskId = SetupPostHandlers.this::handleDeleteOSTasksByTaskId;
		
		
		addPack = SetupPostHandlers.this::handleAddPack;
		getPacks = SetupPostHandlers.this::handleGetPacks;
		getPackByPackId = SetupPostHandlers.this::handleGetPacksByPackId;
		
		
		addStory = SetupPostHandlers.this::handleAddStory;
		getAllStories = SetupPostHandlers.this::handleGetAllStories;
		runStoryById = SetupPostHandlers.this::handleRunStoryById;
		deleteStoryById = SetupPostHandlers.this::handleDeleteStoryById;
		
		
		getSwagger = SetupPostHandlers.this::handleGetSwagger;
		
		getAvailablePlugins = SetupPostHandlers.this::handleGetAvailablePlugins;
		
		getMySystemVariables = SetupPostHandlers.this::handleGetMySystemVariables;
		setMySystemVariables = SetupPostHandlers.this::handleSetMySystemVariables;
		
	}
	/***********************************************************************/
	public Future<Void> validateSystemPool(Pool pool, String method)
	{
		LOGGER.debug("Validating system pool from method: " + method);
		Promise<Void> promise = Promise.promise();
	    pool.query("SELECT 1").execute(ar -> 
	    {
	      if (ar.succeeded()) 
	      {
	        promise.complete();
	      } 
	      else 
	      {
	        promise.fail("Connection pool validation failed: " + ar.cause().getMessage());
	      }
	    });

	    return promise.future();
	}
	
	/***********************************************************************/
	private void handleGetMySystemVariables(RoutingContext routingContext)
	{
		String method = "SetupPostHandlers.handleGetMySystemVariables";
		
		LOGGER.info("Inside: " + method);  
		
		//Context context = routingContext.vertx().getOrCreateContext();
		//Pool pool = context.get("pool");
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String username  =payload.getString("username");
						LOGGER.debug("Username recieved: " + username);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("SELECT data from public.tb_myvars where username =$1;")
					                .execute(Tuple.of(username),
					                res -> 
					                {
					                	if (res.succeeded()) 
							            {
					                		RowSet<Row> rows = res.result();
							                rows.forEach(row -> 
							                {
							                	LOGGER.info("Row: " + row.toJson());
							                    try
							                    {
							                    	JsonObject jo = new JsonObject(row.toJson().encode());
							                        ja.add(jo);
							                        ram.setSystemVariable(jo);
							                        LOGGER.info("Successfully added SystemVariable to ram: " + jo.encodePrettily());
							                        LOGGER.info("Successfully added json object to array");
							                    }
							                    catch(Exception e)
							                    {
							                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
							                    	connection.close();
							                    	LOGGER.error("Closed" + method +" connection to pool : " + e.toString());
							                    }
							                });
							                response.send(ja.encodePrettily());
							                connection.close();
							                LOGGER.debug("Closed " + method +" connection to pool");
							                } 
							                else 
							                {
							                	LOGGER.error("error: " + res.cause() );
							                    response.send(res.cause().getMessage().replaceAll("\"", "")+"}");
							                    connection.close();
							                    LOGGER.error("Closed " + method +" connection to pool");
							                }
					                	});
					            	} 
					            	else 
					            	{
					            		ar.cause().printStackTrace();
					            		response.send(ar.cause().getMessage().replaceAll("\"", ""));
					            		
					            	}
								});
				        	}
				        	else
				        	{
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
		
	}
	/***********************************************************************/
	private void handleSetMySystemVariables(RoutingContext routingContext)
	{
		String method = "SetupPostHandlers.handleSetMySystemVariables";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						JsonObject mySystemVariables = JSONpayload.getJsonObject("mySystemVariables");
						
						LOGGER.debug("mySystemVariables recieved: " + mySystemVariables.encodePrettily());
						
						Map<String,Object> map = new HashMap<String, Object>();
						
						map.put("username", payload.getValue("username"));
						
						map.put("mySystemVariables", mySystemVariables);
						
						LOGGER.info("Accessible Level is : " + authlevel);
				        LOGGER.info("username: " + map.get("username"));
				        LOGGER.info("mySystemVariables: " + map.get("mySystemVariables"));
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("INSERT INTO public.tb_myvars  (username, data) VALUES ($1, $2) ON CONFLICT (username) DO UPDATE SET data = EXCLUDED.data;")
					                		.execute(Tuple.of(map.get("username"), mySystemVariables),
					                        res -> 
					                		{
					                            if (res.succeeded()) 
					                            {
					                                JsonObject jo = new JsonObject("{\"response\":\"Successfully added system variables\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
			                                    	ram.setSystemVariable(mySystemVariables);
					                                response.send(ja.encodePrettily());
					                                LOGGER.info("Successfully added json object to array: " + res.toString());
					                                connection.close();
					                                LOGGER.error("Closed " + method +" connection to pool");
					                            } 
					                            else 
					                            {
					                                LOGGER.error("error: " + res.cause() );
					                            	JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause().getMessage().replaceAll("\"", "")+"}");
			                                    	ja.add(jo);
			                                    	response.send(ja.encodePrettily());
			                                    	connection.close();
			                                    	LOGGER.error("Closed " + method +" connection to pool");
					                            }
					                        });
					            } 
					            else 
					            {
					                JsonArray ja = new JsonArray();
					                LOGGER.error("error: " + ar.cause() );
		                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ ar.cause().getMessage().replaceAll("\"", "") +"}");
		                        	ja.add(jo);
		                        	response.send(ja.encodePrettily());
		                        	
					            }
							});
				        }
						else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        	
				        }
					}
				}
		     }
		});
	}
	/***********************************************************************/
	private void handleGetSwagger(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetSwagger");
		SwaggerSourceHandler.handleGetSwagger(routingContext);
	}
	/***********************************************************************/
	private void handleGetAvailablePlugins(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetAvailablePlugins");
		PluginHandler.handleGetAvailablePlugins(routingContext);
	}
	/***********************************************************************/
	private void handleGetMonitorGuardiumSourcesForCron(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetMonitorGuardiumSources");
		GuardiumSourceHandler.handleMonitorGuardiumSourcesForCron(routingContext);
	}
	/***********************************************************************/
	private void handleGetMonitorGuardiumSources(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetMonitorGuardiumSources");
		GuardiumSourceHandler.handleMonitorGuardiumSources(routingContext);
	}
	/***********************************************************************/
	private void handleGetMonitorGuardiumSourceMessageStatById(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetMonitorGuardiumSourceMessageStatById");
		GuardiumSourceHandler.handleMonitorGuardiumSourceMessageStatById(routingContext);
	}
	/************************************************************************************/
	private void handleGetMonitorGuardiumDataByMessageIdHash(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetMonitorGuardiumDataByMessageIdHash");
		GuardiumSourceHandler.handleMonitorGuardiumDataByMessageIdHash(routingContext);
	}
	/*************************************************************************************/
	private void handleGetMonitorGuardiumDataByMessageIdHashAndInternalId(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleGetMonitorGuardiumDataByMessageIdHashAndInternalId");
		GuardiumSourceHandler.handleMonitorGuardiumDataByMessageIdHashAndInternalId(routingContext);
	}
	/************************************************************************************/
	private void handleMonitorGuardium(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleMonitorGuardium");
		GuardiumSourceHandler.handleMonitorGuardium(routingContext);
    }
	/***********************************************************************/
	private void handleAddStory(RoutingContext routingContext)
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleAddStory");  
		StoryHandler.handleAddStory(routingContext);
	}
	private void handleGetAllStories(RoutingContext routingContext)
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleGetAllStories");  
		StoryHandler.handleGetAllStories(routingContext);
	}
	private void handleRunStoryById(RoutingContext routingContext)
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleRunStroyById");  
		StoryHandler.handleRunStoryById(routingContext);
	}
	private void handleDeleteStoryById(RoutingContext routingContext)
	{
		LOGGER.info("Inside SetupPostHandlers.handleDeleteStoryById");  
		StoryHandler.handleDeleteStoryById(routingContext);
	}
	
	/***********************************************************************NOPOSTMAN*/
	private void handleAddOSTask(RoutingContext routingContext)
	{
		LOGGER.info("insdie handleAddOSTask");
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		OSDetectorAndTaskControl scheduler = new OSDetectorAndTaskControl();
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();

	    List<FileUpload> uploads = routingContext.fileUploads();
	    if (uploads.isEmpty()) {
	        LOGGER.error("No file uploaded");
	        routingContext.fail(400);
	        return;
	    }
	    
	 // Parse form attributes (JSON payload is sent as form attributes)
	    MultiMap formAttributes = routingContext.request().formAttributes();
	    if (formAttributes.isEmpty()) {
	        LOGGER.error("No form data provided");
	        routingContext.fail(400);
	        return;
	    }
	 // Extract JSON payload from form attributes
	    JsonObject JSONpayload = new JsonObject();
	    formAttributes.forEach(entry -> JSONpayload.put(entry.getKey(), entry.getValue()));
	
		String osName = System.getProperty("os.name").toLowerCase();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info(" handleAddTask required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				String task_name = JSONpayload.getString("task_name");
				String task_schedule = JSONpayload.getString("task_schedule");
				String task_file_path = JSONpayload.getString("task_file_path");
				String task_os_type = JSONpayload.getString("task_os_type");
				
				LOGGER.debug("Task schedule recieved: " + task_schedule);
				LOGGER.debug("task_file_path recieved: " + task_file_path);
				
				utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
				
				String encoded_task_schedule = Encodings.EscapeString(task_schedule);
				LOGGER.debug("Encoded task_schedule" + encoded_task_schedule);
				
				
			    File uploadFolder = new File(task_file_path);
			 if (!uploadFolder.exists()) {

		     uploadFolder.mkdir(); // Create the folder if it doesn't exist
		}
				    

				
				
				 // Process the uploaded file
		        FileUpload fileUpload = uploads.iterator().next();
		        String uploadedFileName = fileUpload.uploadedFileName();
		     
			
		        String targetFilePath = task_file_path + fileUpload.fileName(); // Save file in "uploads/" directory
		     // Read the file content as bytes
			    byte[] fileBytes = null;
		        try {
		        	
		        	fileBytes = Files.readAllBytes(Paths.get(uploadedFileName));
		            Files.createDirectories(Paths.get("uploads")); // Ensure directory exists
		            Files.move(Paths.get(uploadedFileName), Paths.get(targetFilePath), StandardCopyOption.REPLACE_EXISTING);
		            LOGGER.info("File uploaded successfully: " + targetFilePath);
		        } catch (IOException e) {
		            LOGGER.error("Error saving uploaded file: " + e.getMessage());
		            routingContext.fail(500);
		            return;
		        }
		        String encoded_task_file_path = Encodings.EscapeString(targetFilePath);
				LOGGER.debug("Encoded task_file_path" + targetFilePath);
				//The map is passed to the SQL query
				Map<String,Object> map = new HashMap<String, Object>();
				
				
				map.put("task_name", JSONpayload.getValue("task_name"));
				map.put("task_schedule", encoded_task_schedule);
				map.put("task_file_path", encoded_task_file_path);
				map.put("task_os_type", JSONpayload.getValue("task_os_type"));
			    // Store the bytes in the database
			    map.put("task_file_content", fileBytes);
			    
			    LOGGER.debug("fileBytes:  "+ fileBytes);
				//LOGGER.debug("Detected OS: " + OSDetectorAndTaskControl.detectOS());
				//here we do the serverside stuff on the chron/schedule and files. Want to hand off to another class
				String action = "Add";
				OSDetectorAndTaskControl.detectOS(targetFilePath, task_schedule,task_name,action);
				
				
				LOGGER.info("Accessible Level is : " + authlevel);
		        LOGGER.info("username: " + map.get("username"));
		        
		        if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("INSERT INTO public.tb_tasks(task_name,task_schedule,task_file_path,task_os_type,task_file_content) VALUES($1,$2,$3,$4,$5);")
			                        .execute(Tuple.of(map.get("task_name"),map.get("task_schedule"),map.get("task_file_path"),map.get("task_os_type"),map.get("task_file_content")),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                // Process the result
			                                
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully added task\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause().getMessage().replaceAll("\"", "")+"}");
	                                    	ja.add(jo);
	                                    	response.send(ja.encodePrettily());
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			                //
			            	JsonArray ja = new JsonArray();
			                LOGGER.error("error: " + ar.cause() );
                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ ar.cause().getMessage().replaceAll("\"", "") +"}");
                        	ja.add(jo);
                        	response.send(ja.encodePrettily());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
		
	}
	/**********************handleGetOSTasks******************************************NOPOSTMAN*/
	private void handleGetOSTasks(RoutingContext routingContext)
	{
LOGGER.info("Inside SetupPostHandlers.handleGetOSTask");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleGetOSTask required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
			
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
		        	pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Select * from public.tb_tasks")
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
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
			}
		
		}
	}
	
	/**********************handleGetOSTasks*******************************************/
	private void handleGetOSTasksByTaskId(RoutingContext routingContext)
	{
			LOGGER.info("Inside SetupPostHandlers.handleGetOSTasksByTaskId");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleGetOSTask required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
			
				String TaskId = JSONpayload.getString("task_id"); 
				LOGGER.info("TaskId: " + TaskId);
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
		        	pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Select * from public.tb_tasks where id = $1")
			                        .execute(Tuple.of(Integer.parseInt(TaskId)),
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
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
			}
		
		}
	}
	/****************************************************************/
	
	
	/**********************handleDeleteOSTasksByTaskId*******************************************/
	private void handleDeleteOSTasksByTaskId(RoutingContext routingContext)
	{
		LOGGER.info("Inside SetupPostHandlers.handleDeleteOSTasksByTaskId");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleDeleteOSTasksByTaskId required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String task_name = JSONpayload.getString("task_name");
				String task_schedule = JSONpayload.getString("task_schedule");
				String task_os_type = JSONpayload.getString("task_os_type");
				String task_file_path = JSONpayload.getString("task_file_path");
				String id = JSONpayload.getString("id");
				utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
				
				String targetFilePath = Encodings.UnescapeString(task_file_path);
				LOGGER.debug("task_name recieved: " + task_name);
				LOGGER.debug("task_schedule recieved: " + task_schedule);
				LOGGER.debug("task_os_type recieved: " + task_os_type);
				LOGGER.debug("task_file_path recieved: " + task_file_path);
				
				LOGGER.debug("targetFilePath recieved: " + targetFilePath);
				
				LOGGER.debug("id recieved: " + id);
				
				LOGGER.info("Accessible Level is : " + authlevel);
				String action = "Delete";
				OSDetectorAndTaskControl.detectOS(targetFilePath, task_schedule,task_name,action);
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("DELETE from public.tb_tasks where id = $1")
			                        .execute(Tuple.of( Integer.parseInt(id)),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                
			                            	
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully update connection\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully deleted OS Task: " + res.toString());
	                                    	
			                          
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\""+ res.cause().getMessage().toString().replaceAll("\""," ") +"\"}");
	                                    	LOGGER.error("error: " + res.cause() );
	                                    	ja.add(jo);
	                                    	response.send(ja.encodePrettily());
			                                res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			            	
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	
	
	/**************************Content Packs APIs Begin**************************/
	
	/*****************************handleAddPack*****************************************/

	/*****Adds a content pack to the system
	 * Recorded in the database.
	 * Users know what packs they have and what they've deployed******************************************/
	private void handleAddPack(RoutingContext routingContext)
	{
		
		String method = "SetupPostHandlers.handleAddPack";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				List<FileUpload> uploads = routingContext.fileUploads();
				try 
				{
				    if (uploads.isEmpty()) 
				    {
				        LOGGER.warn("File upload attempt failed: No files received.");
				        routingContext.response().setStatusCode(400).end("No file uploaded.");
				        return;
				    }
				    
				} 
				catch (Exception e) 
				{
				    LOGGER.error("File upload failed with unexpected error", e);
				    routingContext.response().setStatusCode(500).end("Server error while handling upload.");
				}
				LOGGER.info("Received headers: " + routingContext.request().headers());
				LOGGER.info("File upload size: " + routingContext.fileUploads().size());
				if (routingContext.request().getHeader("Content-Type") != null) 
				{
				    LOGGER.info("Content-Type header: " + routingContext.request().getHeader("Content-Type"));
				}
				// Parse form attributes (JSON payload is sent as form attributes)
			    MultiMap formAttributes = routingContext.request().formAttributes();
			    if (formAttributes.isEmpty()) 
			    {
			        LOGGER.error("No form data provided");
			        routingContext.fail(400);
			        return;
			    }
			    // Extract JSON payload from form attributes
			    JsonObject JSONpayload = new JsonObject();
			    formAttributes.forEach(entry -> JSONpayload.put(entry.getKey(), entry.getValue()));
			
				String osName = System.getProperty("os.name").toLowerCase();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(" handleAddPAck required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						Path currRelativePath = Paths.get("");
					    String currAbsolutePathString = currRelativePath.toAbsolutePath().toString();
					    LOGGER.debug("Current absolute path is - " + currAbsolutePathString);
						
						File uploadFolder = new File(currAbsolutePathString);
						if (!uploadFolder.exists()) 
						{
							uploadFolder.mkdir(); // Create the folder if it doesn't exist
						}
						File outputFolder = new File(currAbsolutePathString);
						if (!outputFolder.exists()) 
						{
							outputFolder.mkdir(); // Create the folder if it doesn't exist
						}
						 // Process the uploaded file
				        FileUpload fileUpload = uploads.iterator().next();
				        String uploadedFileName = fileUpload.uploadedFileName();
				        String targetFilePath = currAbsolutePathString +"\\contentpacks\\"+ fileUpload.fileName(); // Save file in "uploads/" directory
				     // Read the file content as bytes
					    byte[] fileBytes = null;
				        try 
				        {
				        	fileBytes = Files.readAllBytes(Paths.get(uploadedFileName));
				            Files.createDirectories(Paths.get("uploads")); // Ensure directory exists
				            Files.move(Paths.get(uploadedFileName), Paths.get(targetFilePath), StandardCopyOption.REPLACE_EXISTING);
				            LOGGER.info("File uploaded successfully: " + targetFilePath);
				        } 
				        catch (IOException e) 
				        {
				            LOGGER.error("Error saving uploaded file: " + e.getMessage());
				            routingContext.fail(500);
				            return;
				        }
				        String encoded_pack_file_path = Encodings.EscapeString(targetFilePath);
				        String encoded_pack_output_path = Encodings.EscapeString(currAbsolutePathString);
				        
						LOGGER.debug("Encoded task_file_path" + targetFilePath);
						//The map is passed to the SQL query						
						Map<String,Object> map = new HashMap<String, Object>();
						ContentPackUtils.PackParseResult packResult;
						try 
						{
						    packResult = ContentPackUtils.unzipAndExtractPackJson(targetFilePath, currAbsolutePathString);
						    JsonObject json = new JsonObject(packResult.packJsonContent);
						    // Put full jsonb content
						    map.put("pack_json", json);
						    // Extract individual fields for separate columns
						    map.put("pack_name", json.getString("pack_name"));
						    map.put("version", json.getString("version"));
						    map.put("db_type", json.getString("db_type"));
						    map.put("build_date", json.getString("build_date"));
						    map.put("build_version", json.getString("build_version"));
						    map.put("description", json.getString("description"));
						    map.put("author", json.getString("author"));
						    map.put("icon", json.getString("icon"));
						    map.put("background_traffic", json.getString("background_traffic"));
						} 
						catch (IOException e) 
						{
						    LOGGER.error("Failed to unzip and extract pack.json: " + e.getMessage());
						    routingContext.fail(400);
						}
			
						map.put("pack_file_path", targetFilePath);
						map.put("pack_output_path", currAbsolutePathString);
					    map.put("pack_file_content", fileBytes);
					    
					    LOGGER.debug("fileBytes:  "+ fileBytes);
						LOGGER.info("Accessible Level is : " + authlevel);
				        LOGGER.info("username: " + map.get("username"));
				        
				        if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
							
							pool.getConnection(ar -> 
							{
					            if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("INSERT INTO tb_content_packs (pack_name, version, db_type, build_date, build_version, description,author, icon, background_traffic, pack_info\r\n"
					                		+ ") VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) ON CONFLICT (pack_name, version) DO UPDATE SET db_type = EXCLUDED.db_type, build_date = EXCLUDED.build_date, build_version = EXCLUDED.build_version, description = EXCLUDED.description, author = EXCLUDED.author, icon = EXCLUDED.icon, background_traffic = EXCLUDED.background_traffic, pack_info = EXCLUDED.pack_info, pack_deployed = EXCLUDED.pack_deployed, uploaded_date = CURRENT_TIMESTAMP;")
					                        .execute(Tuple.of(map.get("pack_name"),map.get("version"),map.get("db_type"),map.get("build_date")
					                        		,map.get("build_version"),map.get("description"),map.get("author"),map.get("icon"),
					                        		map.get("background_traffic"),map.get("pack_json")),
					                        res -> 
					                        {
					                            if (res.succeeded()) 
					                            {
					                                JsonObject jo = new JsonObject("{\"response\":\"Successfully added content pack\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
					                                response.send(ja.encodePrettily());
					                                connection.close();
					                                LOGGER.info("closed method: " + method + " to connection pool");
					                            } 
					                            else 
					                            {
					                                // Handle query failure
					                            	LOGGER.error("error: " + res.cause() );
					                            	Throwable cause = res.cause();
					    			                String message = cause.getMessage();
					    			                JsonObject jo = new JsonObject();
					    			                if (cause.getMessage().contains("duplicate key value violates unique constraint")) 
					    			                {
					    			                    response.setStatusCode(409); // Conflict
					    			                    jo.put("error", "A content pack with the same name and version already exists.");
					    			                    LOGGER.error("A content pack with the same name and version already exists.");
					    			                } 
					    			                else 
					    			                {
					    			                    response.setStatusCode(500); // Generic server error
					    			                    LOGGER.error("Database error: " + cause.getMessage().replaceAll("\"", ""));
					    			                    jo.put("error", "Database error: " + cause.getMessage().replaceAll("\"", ""));
					    			                }
					    			                response.send(ja.encodePrettily());
					                                connection.close();
					    			                LOGGER.info("closed method: " + method + " to connection pool");
					                            }
					                            connection.close();
					                        });
					            } 
					            else 
					            {
					                JsonArray ja = new JsonArray();
					                LOGGER.error("error: " + ar.cause() );
		                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ ar.cause().getMessage().replaceAll("\"", "") +"}");
		                        	ja.add(jo);
		                        	response.send(ja.encodePrettily());
					            }
					        });
				        }
				        else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        }
					}
				}
			}
				
		});
	}
	/**********************handleGetPacks******************************************/
	
	/******Show the table of packs user has uploaded*******************************************/
	private void handleGetPacks(RoutingContext routingContext)
	{
		
		String method = "SetupPostHandlers.handleGetPacks";
		
		LOGGER.info("Inside: " + method);  
		
		//Context context = routingContext.vertx().getOrCreateContext();
		//Pool pool = context.get("pool");
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String username  =payload.getString("username");
						LOGGER.debug("Username recieved: " + username);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            if (ar.succeeded()) 
					            {
					            	SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					            	connection.preparedQuery("SELECT id, pack_name, version, db_type, build_date, build_version, uploaded_date, pack_info FROM tb_content_packs")
			                        .execute(
			                        res -> 
			                        {
			                            if (res.succeeded()) 
			                            {
			                                // Process the query result
			                                RowSet<Row> rows = res.result();
			                                rows.forEach(row -> 
			                                {
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
			                                connection.close();
			                                LOGGER.info("closed method: " + method + " to connection pool");
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	response.send(res.cause().getMessage());
			                            	connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
			                            }
			                        });
					            } 
					            else 
					            {
					                // Handle connection failure
					                ar.cause().printStackTrace();
					                response.send(ar.cause().getMessage().replaceAll("\"", ""));
					                
			                    }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
			
	}
	
	/**********************handleGetPacksByPackId******************************************/
	/****Getting the packs for the update function.
	 * Modal pops up with Packs users can deploy******************************************/
	private void handleGetPacksByPackId(RoutingContext routingContext)
	{
		String method = "SetupPostHandlers.handleGetPacksByPackId";
		LOGGER.info("Inside: " + method);  
		
		//Context context = routingContext.vertx().getOrCreateContext();
		//Pool pool = context.get("pool");
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
					
						String PackId = JSONpayload.getString("pack_id"); 
						LOGGER.info("PackId: " + PackId);
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            if (ar.succeeded()) 
					            {
					            	SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					            	connection.preparedQuery("Select * from public.tb_content_packs where id = $1")
				                    .execute(Tuple.of(Integer.parseInt(PackId)),
				                    res -> 
				                    {
				                    	if (res.succeeded()) 
				                        {
					                        // Process the query result
					                        RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
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
					                        connection.close();
					                        LOGGER.info("closed method: " + method + " to connection pool");
				                        } 
				                    	else 
				                    	{
				                    		// Handle query failure
				                    		LOGGER.error("error: " + res.cause() );
				                    		response.send(res.cause().getMessage());
				                    		connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
				                    	}
				                    	
				                    });
					            } 
					            else 
					            {
					                // Handle connection failure
					                ar.cause().printStackTrace();
					                response.send(ar.cause().getMessage().replaceAll("\"", ""));
					            }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
	
	}

	
	/**************************Content Packs APIs End****************************/
	/****************************************************************/
	private void handleDeleteScheduleJobById(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleDeleteScheduleJobById");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
		if (pool == null)
		{
			LOGGER.debug("pool is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleDeleteScheduleJobById required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String scheduleJobId = JSONpayload.getString("id"); 
				LOGGER.info("ScheduleJobId: " + scheduleJobId);
				
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
		        	pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                
			                connection.preparedQuery("DELETE from public.tb_schedule WHERE id = $1")
			                        .execute(Tuple.of(Integer.parseInt(scheduleJobId)),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                JsonObject jo = new JsonObject("{\"response\":\"Successfully deleted scheduled job\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
			                                response.send(ja.encodePrettily());
			                                    
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\"Unable to delete scheduled job\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.error("error: " + res.cause().getMessage() );
			                            	response.send(ja.encodePrettily());
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			            	JsonArray ja = new JsonArray();
			            	JsonObject jo = new JsonObject("{\"response\":\"Error: "+ar.cause().getMessage().replaceAll("\"", "")+ "\"}");
                        	ja.add(jo);
                        	LOGGER.error("error: " + ar.cause().getMessage() );
                        	response.send(ja.encodePrettily());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject("{\"response\":\"Error: Insufficient access to run API\"}");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		    }
		}
	}
	/****************************************************************/
	
	
	
	/****************************************************************/
	private void handleGetScheduleJobs(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleGetScheduleJobs");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
		if (pool == null)
		{
			LOGGER.debug("pool is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleGetScheduleJobs required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
		        	pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Select * from public.tb_schedule")
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
			                                
			                                LOGGER.debug("adding database connection details to context");
			                                context.put("ConnectionData", ja);
			                                LOGGER.debug("added database connection details to context");
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
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		    }
		}
	}
	/****************************************************************/
	
	
	
		private void handleAddScheduleJob(RoutingContext routingContext)
		{
			LOGGER.info("inside handleAddScheduleJob");
			
			Context context = routingContext.vertx().getOrCreateContext();
			Pool pool = context.get("pool");
			
			if (pool == null)
			{
				LOGGER.debug("pool is null - restarting");
				DatabaseController DB = new DatabaseController(routingContext.vertx());
				LOGGER.debug("Taking the refreshed context pool object");
				pool = context.get("pool");
			}
			
			HttpServerResponse response = routingContext.response();
			JsonObject JSONpayload = routingContext.getBodyAsJson();
			
			if (JSONpayload.getString("jwt") == null) 
		    {
		    	LOGGER.info("handleAddScheduleJob required fields not detected (jwt)");
		    	routingContext.fail(400);
		    } 
			else
			{
				if(validateJWTToken(JSONpayload))
				{
					LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
					String [] chunks = JSONpayload.getString("jwt").split("\\.");
					
					JsonObject payload = new JsonObject(decode(chunks[1]));
					LOGGER.info("Payload: " + payload );
					int authlevel  = Integer.parseInt(payload.getString("authlevel"));
					
					String name = JSONpayload.getString("name");
					String chronSequence = JSONpayload.getString("chronSequence");
					String fk_tb_databaseConnections_db_connection_id = JSONpayload.getString("fk_tb_databaseConnections_db_connection_id");
					String fk_tb_query_id = JSONpayload.getString("fk_tb_query_id");
					String active = JSONpayload.getString("active");
					
					LOGGER.debug("name recieved: " + name);
					LOGGER.debug("chronSequence: " + chronSequence);
					
					Map<String,Object> map = new HashMap<String, Object>();
					
					map.put("name", name);
					map.put("chronSequence", chronSequence);
					map.put("fk_tb_databaseConnections_db_connection_id", fk_tb_databaseConnections_db_connection_id);
					map.put("fk_tb_query_id", fk_tb_query_id);
					map.put("active", active);
					
					LOGGER.info("Accessible Level is : " + authlevel);
			        
			        if(authlevel >= 1)
			        {
			        	LOGGER.debug("User allowed to execute the API");
			        	response.putHeader("content-type", "application/json");
						
						pool.getConnection(ar -> 
						{
				            if (ar.succeeded()) 
				            {
				                SqlConnection connection = ar.result();
				                JsonArray ja = new JsonArray();
				                
				                connection.preparedQuery("INSERT INTO public.tb_schedule(name, chronSequence, fk_tb_databaseConnections_db_connection_id, fk_tb_query_id,  active) VALUES($1,$2,$3,$4,$5);")
				                        .execute(Tuple.of(map.get("query_type"),map.get("chronSequence"),map.get("fk_tb_databaseConnections_db_connection_id"),map.get("fk_tb_query_id"),map.get("active")),
				                        res -> {
				                            if (res.succeeded()) 
				                            {
				                                // Process the query result
				                                
				                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully added schedule task\"}");
		                                    	ja.add(jo);
		                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
				                                response.send(ja.encodePrettily());
				                            } 
				                            else 
				                            {
				                                LOGGER.error("error: " + res.cause() );
				                            	JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause()+"}");
		                                    	ja.add(jo);
		                                    	response.send(ja.encodePrettily());
				                            }
				                            connection.close();
				                        });
				            } 
				            else 
				            {
				            	JsonArray ja = new JsonArray();
				                LOGGER.error("error: " + ar.cause() );
	                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ ar.cause().getMessage().replaceAll("\"", "") +"}");
	                        	ja.add(jo);
	                        	response.send(ja.encodePrettily());
				            }
				            
				        });
			        }
			        else
			        {
			        	JsonArray ja = new JsonArray();
			        	JsonObject jo = new JsonObject();
			        	jo.put("Error", "Issufficent authentication level to run API");
			        	ja.add(jo);
			        	response.send(ja.encodePrettily());
			        }
			        
			        
				}
			}
			
			
			/*JsonObject jobObject = new JsonObject();
				  
			routingContext.vertx().setPeriodic(1000, h -> 
			{
				LOGGER.info("Periodic on " + Thread.currentThread().getName());
				LOGGER.debug("Searching for JOB with ID: " + id );
				
				JsonObject Job = new JsonObject();
				JsonArray JobArray = sv.getJobArray();
				       
				LOGGER.debug("---------------------------------- JobArray Size: " +  JobArray.size());
				       
				for(int i = 0; i < JobArray.size(); i++)
				{
					Job = sv.getJobArray().get(i).getAsJsonObject();
					LOGGER.debug("------------------------------- JOB Id: " + Job.get("id"));
				    	   		
				    if(Job.get("id").getAsString().compareToIgnoreCase(id) == 0)
					{
				    	LOGGER.debug("---------------------> Found the Job <-------------------------");
						if(Job.get("status").getAsString().compareToIgnoreCase("run") != 0 || (Job.get("loop").getAsString().compareToIgnoreCase("yes")!= 0 && Job.get("runcount").getAsInt() >= 1))
				  		{
							LOGGER.debug("---------------------> LOOP EXIT for Job: " +Job.get("id") + " <-------------------------");
							Job.addProperty("EPS", 0);
							vertx.cancelTimer(h);
				  		}
					}
				}
				       
				int svListSize = sv.getListSize();
				int storedEPS = sv.getEPS();
				vertx.executeBlocking(future -> 
				{
					LOGGER.info("Future on " + Thread.currentThread().getName() + " working a list size of: " + svListSize);
				    int incrementorHold = sv.getIncrementor();
				    LOGGER.info("Validating running id for :" + id); 
				    	   
				    String line;
				    boolean loopJob = incrementorHold < (svListSize - storedEPS);
				    	   
				    LOGGER.info("Can Loop: " +incrementorHold + " < ("+ svListSize + " - " + storedEPS+ ") = " + loopJob); 
				    LOGGER.info("Line 2 prepare ---> " +  logFileContentsList.get(0));
				    if(incrementorHold < (svListSize - storedEPS))
				    {
				    	int i = 0;
				    	while(i <= storedEPS)
				    	{
				    		LOGGER.info("Incrementor --->: " + (incrementorHold + i));
				    		LOGGER.info("Line to prepare ---> " +  logFileContentsList.get(incrementorHold + i) );
				    		line = SU.prepaterLogMessageForStreaming(logFileContentsList.get(incrementorHold + i));
				    		LOGGER.info("Line prepared ---> " +  line );
					        SU.sendStreamMessage(line);
					        LOGGER.info("["+(incrementorHold + i)+"] " + line);
					        i = i+1;
				    	}
				    	sv.setIncrementor((sv.getIncrementor()+storedEPS));
				    		   
				    	LOGGER.debug("Incrementor Loop End: " + sv.getIncrementor());
				    }
				    else
				    {
				    	LOGGER.debug("Reached the end of the file - so resetting counter to 0 ");
				    	sv.setIncrementor(0);
				    	JsonObject Job_reset = new JsonObject();
				  		JsonArray JobArray_reset = sv.getJobArray();
				  		JsonArray JobArray_temp = new JsonArray();
				    	for(int i = 0; i < JobArray_reset.size(); i++)
				 		{
				    		Job_reset = JobArray_reset.get(i).getAsJsonObject();
				 			LOGGER.debug("------------------------------- JOB Id: " + Job_reset.get("id"));
				 		    if(Job_reset.get("id").getAsString().compareToIgnoreCase(id) == 0)
				 			{
				 		    	int runCount = Job_reset.get("runcount").getAsInt();
				 		    	LOGGER.debug("---------------------> Found the Job run [" + runCount+ "]  <-------------------------");
				 		    	runCount = runCount +1;
				 		    	Job_reset.addProperty("runcount", runCount);
				 		    }
				 		    JobArray_temp.add(Job_reset);	
				 		}
				    	//A clear race condition here - really we need a semiphore on this, or use a messaging bus
				    	sv.setJobArray(JobArray_temp);
				    }
				    future.complete();
				}
				, result -> 
				       {
				    	   LOGGER.info("Result on " + Thread.currentThread().getName());
				       });
				       
			});
			return jobObject;
		}*/
		/*******************************************************************************/
		
	}
	/****************************************************************/
	/*	
	 	Accessed via get route: /api/simpleTest
		- No Payload / Parameter - 
	*/
	/****************************************************************/
	private void handleSimpleTest(RoutingContext routingContext)
	{
	
		JsonObject PayloadJSON = new JsonObject();
		PayloadJSON.put("username", "myusername");
		PayloadJSON.put("password", "mypassword");
		
		LOGGER.info("Inside SetupPostHandlers.handleSimpleTest");
		HttpServerResponse response = routingContext.response();
		try 
		{ 
			
		}
		catch(Exception e)
		{
			LOGGER.error("Unable to complete simple test: " + e.toString());
		}
	}
	/****************************************************************/
	/*	
	 	Accessed via get route: /api/simpleDBTest
	 	- No Payload / Parameter -
	 */
	/****************************************************************/
	private void handleSimpleDBTest(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleSimpleDBTest");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
		if (pool == null)
		{
			LOGGER.debug("pull is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject loginPayloadJSON = routingContext.getBodyAsJson();
		
		response
        .putHeader("content-type", "application/json");
		
		pool.getConnection(ar -> {
            if (ar.succeeded()) {
                SqlConnection connection = ar.result();
                
                JsonArray ja = new JsonArray();
                
                // Execute a SELECT query
                connection.query("SELECT * FROM public.tb_user")
                        .execute(res -> {
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
                                //res.cause().printStackTrace();
                            }
                            // Close the connection
                            //response.end();
                            connection.close();
                        });
            } else {
                // Handle connection failure
                ar.cause().printStackTrace();
                response.send(ar.cause().getMessage());
            }
            
        });
	}
	/****************************************************************/
	private void handleAddQueryTypes(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleAddQueryTypes";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String queryType = JSONpayload.getString("query_type");
						
						LOGGER.debug("Query recieved: " + queryType);
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						
						
						map.put("query_type", JSONpayload.getValue("query_type"));
						
						LOGGER.info("Accessible Level is : " + authlevel);
				        LOGGER.info("username: " + map.get("username"));
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                // Execute a SELECT query
					                connection.preparedQuery("INSERT INTO public.tb_query_types(query_type) VALUES($1);")
					                .execute(Tuple.of(map.get("query_type")),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully added query type\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
			                                response.send(ja.encodePrettily());
			                                connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause()+"}");
	                                    	ja.add(jo);
	                                    	response.send(ja.encodePrettily());
	                                    	connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
			                                //res.cause().printStackTrace();
			                            }
			                            connection.close();
			                        });
					            } 
								else 
					            {
					                // Handle connection failure
					                //
					            	JsonArray ja = new JsonArray();
					                LOGGER.error("error: " + ar.cause() );
		                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ ar.cause().getMessage().replaceAll("\"", "") +"}");
		                        	ja.add(jo);
		                        	response.send(ja.encodePrettily());
					            }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
		
	}
	/****************************************************************/
	private void handleDeleteQueryTypesByID(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleDeleteQueryTypesByID";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						String queryTypeId = JSONpayload.getString("id"); 
						LOGGER.info("queryTypeId: " + queryTypeId);
						
						
						LOGGER.info("Accessible Level is : " + authlevel);
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("DELETE from public.tb_query_types WHERE id = $1")
					                .execute(Tuple.of(Integer.parseInt(queryTypeId)),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		JsonObject jo = new JsonObject("{\"response\":\"Successfully deleted connection\"}");
			                                ja.add(jo);
			                                LOGGER.info("Successfully added json object to array: " + res.toString());
					                        response.send(ja.encodePrettily());
					                        connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
					                    } 
					                    else 
					                    {
					                       	JsonObject jo = new JsonObject("{\"response\":\"Unable to delete connection\"}");
			                               	ja.add(jo);
			                               	LOGGER.error("error: " + res.cause().getMessage() );
					                       	response.send(ja.encodePrettily());
					                       	connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
					                    }
					                    connection.close();
					                 });
					            } 
								else 
								{
					                // Handle connection failure
					            	JsonArray ja = new JsonArray();
					            	JsonObject jo = new JsonObject("{\"response\":\"Error: "+ar.cause().getMessage().replaceAll("\"", "")+ "\"}");
		                        	ja.add(jo);
		                        	LOGGER.error("error: " + ar.cause().getMessage() );
		                        	response.send(ja.encodePrettily());
					            }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
		
	}
	/****************************************************************/
	/****************************************************************/
	/*	
	 	Accessed via get route: /api/addDatabaseQuery
	 	{
	 		"jwt":"",
	 		"query_db_type":"postgres",
	 		"db_connection_string":""
	 		"query_string":"",
	 		"query_type":""
	 	}
	*/
	/****************************************************************/
	private void handleAddDatabaseQuery(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleAddDatabaseQuery";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String query = JSONpayload.getString("query_string");
						
						LOGGER.debug("Query recieved: " + query);
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						
						String encoded_query = Encodings.EscapeString(query);
						LOGGER.debug("Query recieved: " + query);
						LOGGER.debug("Query encoded: " + encoded_query);
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						
						
						map.put("query_db_type", JSONpayload.getValue("query_db_type"));
						map.put("query_type", JSONpayload.getValue("query_type"));
						map.put("query_usecase", JSONpayload.getValue("query_usecase"));
						map.put("encoded_query", encoded_query);
						map.put("db_connection_id", Integer.parseInt(JSONpayload.getValue("db_connection_id").toString()));
						map.put("query_loop", Integer.parseInt(JSONpayload.getValue("query_loop").toString()));
						map.put("query_description", JSONpayload.getValue("query_description").toString());
						map.put("video_link", JSONpayload.getValue("video_link").toString());
						
						
						LOGGER.debug("The Query Loop value is : " + Integer.parseInt(JSONpayload.getValue("query_loop").toString()));
						LOGGER.info("Accessible Level is : " + authlevel);
				        LOGGER.info("username: " + map.get("username"));
				        
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("Insert into public.tb_query(query_db_type, query_string, query_usecase, query_type, fk_tb_databaseConnections_id,query_loop, query_description, video_link) VALUES($1,$2,$3,$4,$5,$6,$7,$8);")
					                .execute(Tuple.of(map.get("query_db_type"), map.get("encoded_query"), map.get("query_usecase"), map.get("query_type"), map.get("db_connection_id"), map.get("query_loop"), map.get("query_description"),  map.get("video_link")),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		JsonObject jo = new JsonObject("{\"response\":\"Successfully added query\"}");
			                                ja.add(jo);
			                                LOGGER.info("Successfully added json object to array: " + res.toString());
			                                connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
					                    } 
					                    else 
					                    {
					                    	// Handle query failure
					                        LOGGER.error("error: " + res.cause() );
					                        JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause().getMessage().replaceAll("\"", "")+"}");
			                                ja.add(jo);
			                                connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");
					                    }
					                	response.send(ja.encodePrettily());
					                    connection.close();
					                });
					            } 
								else 
								{
					                LOGGER.error(ar.cause().getMessage());
					                response.send(ar.cause().getMessage());
					            }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
		
	}
	/****************************************************************/
	private void handleGetValidatedDatabaseConnections(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetValidatedDatabaseConnections";
		
		LOGGER.info("Inside: " + method);  
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();

		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleGetValidatedDatabaseConnections required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");

				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));

				LOGGER.info("Accessible Level is : " + authlevel);

				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
		        	Ram ram = new Ram();


					//HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();

					HashMap<String, JsonArray> validatedConnections = ram.getValidatedConnections();
					// Retrieve the user alias access object

					try
					{
						LOGGER.debug("Ram.DatasourceMap size: " + validatedConnections.size());
					}
					catch(Exception e)
					{
						LOGGER.error("Ram.DatasourceMap has not been initialzed - have you run getConnections: " + e.getMessage());
					}

					JsonArray ja = new JsonArray();

					for (Map.Entry<String, JsonArray> set :validatedConnections.entrySet()) 
					{
						LOGGER.debug(set.getKey() + " = "+ set.getValue().encodePrettily());
						JsonArray innerJa = set.getValue();

						LOGGER.debug("Innerja to string : "+ innerJa.encodePrettily());
			            // Retrieve alias and access info from userAliasAccess if available
						JsonObject hold = innerJa.getJsonObject(0);
						JsonObject jo = new JsonObject();
						jo.put("connection", set.getKey());
						jo.put("alias", hold.getValue("alias"));
						jo.put("access", hold.getValue("access"));
						jo.put("status", hold.getValue("status"));
						ja.add(jo);

				    	LOGGER.info("Successfully added json object to array");

					}
					response = routingContext.response();
					response.send(ja.encodePrettily());
					
		        }
			}
			else
	        {
	        	JsonArray ja = new JsonArray();
	        	JsonObject jo = new JsonObject();
	        	jo.put("Error", "Issufficent authentication level to run API");
	        	ja.add(jo);
	        	response.send(ja.encodePrettily());
	        	
	        }
		}
	}
	/****************************************************************/
	private void handleGetRefreshedDatabaseConnections(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetRefreshedDatabaseConnections";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
							LOGGER.debug("User allowed to execute the API");
				        	response.putHeader("content-type", "application/json");
				        	
				        	
				        	 /*
				        	 * First this to do is to close all the existing pools
				        	 */
		                    HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
		                    if(dataSourceMap != null)
		                    {
			                    LOGGER.debug("Number of existing database pool connections: " + dataSourceMap.size());
			                    Collection<DatabasePoolPOJO> databasePoolPojos = dataSourceMap.values();
			                    for (DatabasePoolPOJO databasePoolPojo : databasePoolPojos) 
			                    {
			                        try
			                        {
			                        	databasePoolPojo.getBDS().close();
			                        	LOGGER.debug("Successfully closed a database connection");
			                        }
			                        catch(Exception e)
			                        {
			                        	LOGGER.error("Unable to close a database connection: " + e);
			                        }
			                    }
			                    LOGGER.debug("*************** Successfully closed all existing database connections ********************");
			                    LOGGER.debug("*************** Removing all known database connections from RAM *********************");
			                    ram.setDBPM(null);
			                    ram.setValidatedConnections(null);
			                    LOGGER.debug("*************** database connections removed successfully *********************");
			                }
		                    pool.getConnection(ar -> 
							{
					            if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("Select * from public.tb_databaseConnections where status='active'")
					                .execute(
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		// Process the query result
					                        RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
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
					                                
					                        LOGGER.debug("adding database connection details to context");
					                        context.put("ConnectionData", ja); 
					                        LOGGER.debug("added database connection details to context");
					                                
					                        connection.close();
			                            	LOGGER.info("closed method: " + method + " to connection pool");        
					                        
			                            	response.send(ja.encodePrettily());
					                        /* Create the database connection pool for all the test databases */
					                        DatabasePoolManager DPM = new DatabasePoolManager(context);
					                      } 
					                      else 
					                      {
					                    	  // Handle query failure
					                          LOGGER.error("error: " + res.cause() );
					                          response.send(res.cause().getMessage());
					                          connection.close();
					                          LOGGER.info("closed method: " + method + " to connection pool");
					                          //res.cause().printStackTrace();
					                      }
					                      // Close the connection
					                      //response.end();
					                      connection.close();
					                });
					            } 
					            else 
					            {
					                // Handle connection failure
					                ar.cause().printStackTrace();
					                response.send(ar.cause().getMessage());
					            }
					            
					        });
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        	}
						}
					} 
		      	}
			});
		
		
	}
	/****************************************************************/
	private void handleGetAllDatabaseConnections(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetAllDatabaseConnections";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
							LOGGER.debug("User allowed to execute the API");
				        	response.putHeader("content-type", "application/json");
				        	
				        	
				        	 /*
				        	 * First this to do is to close all the existing pools
				        	 */
		                    HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
		                    if(dataSourceMap != null)
		                    {
			                    LOGGER.debug("Number of existing database pool connections: " + dataSourceMap.size());
			                    Collection<DatabasePoolPOJO> databasePoolPojos = dataSourceMap.values();
			                    for (DatabasePoolPOJO databasePoolPojo : databasePoolPojos) 
			                    {
			                        try
			                        {
			                        	databasePoolPojo.getBDS().close();
			                        	LOGGER.debug("Successfully closed a database connection");
			                        }
			                        catch(Exception e)
			                        {
			                        	LOGGER.error("Unable to close a database connection: " + e);
			                        }
			                    }
			                    LOGGER.debug("*************** Successfully closed all existing database connections ********************");
			                    LOGGER.debug("*************** Removing all known database connections from RAM *********************");
			                    ram.setDBPM(null);
			                    ram.setValidatedConnections(null);
			                    LOGGER.debug("*************** database connections removed successfully *********************");
			                }
		                    pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("Select * from public.tb_databaseConnections")
					                .execute(
					                res -> 
					                {
					                	if (res.succeeded()) 
					                	{
					                		// Process the query result
					                        RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
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
					                        
					                        	connection.close();
					                        	LOGGER.info("closed method: " + method + " to connection pool");	
					                        
					                          //LOGGER.debug("adding database connection details to context");
					                          //context.put("ConnectionData", ja);
					                          //LOGGER.debug("added database connection details to context");
					                                
					                                
					                          response.send(ja.encodePrettily());
					                          /* Create the database connection pool for all the test databases */
					                          DatabasePoolManager DPM = new DatabasePoolManager(context);
					                        } 
					                        else 
					                        {
					                                // Handle query failure
					                            	LOGGER.error("error: " + res.cause() );
					                            	response.send(res.cause().getMessage());
					                            	connection.close();
					                            	LOGGER.info("closed method: " + method + " to connection pool");
					                                //res.cause().printStackTrace();
					                        }
					                            // Close the connection
					                            //response.end();
					                            connection.close();
					                });
					            } 
								else 
								{
					                // Handle connection failure
									JsonArray ja = new JsonArray();
					        		JsonObject jo = new JsonObject();
					        		jo.put("Error", "" +ar.cause().getMessage().replaceAll("\"", "")+"");
					        		ja.add(jo);
					        		response.send(ja.encodePrettily());
					            }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Error on handleGetAllDatabaseConnections");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        }
					}
				} 
		      }
		});
	}
	/****************************************************************/
	
	
	/****************************************************************/
	private void handleGetDatabaseConnections(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetDatabaseConnections";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
							LOGGER.debug("User allowed to execute the API");
				        	response.putHeader("content-type", "application/json");
				        	
				        	
				        	 /*
				        	 * First this to do is to close all the existing pools
				        	 */
		                    HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
		                    if(dataSourceMap != null)
		                    {
			                    LOGGER.debug("Number of existing database pool connections: " + dataSourceMap.size());
			                    Collection<DatabasePoolPOJO> databasePoolPojos = dataSourceMap.values();
			                    for (DatabasePoolPOJO databasePoolPojo : databasePoolPojos) 
			                    {
			                        try
			                        {
			                        	databasePoolPojo.getBDS().close();
			                        	LOGGER.debug("Successfully closed a database connection");
			                        }
			                        catch(Exception e)
			                        {
			                        	LOGGER.error("Unable to close a database connection: " + e);
			                        }
			                    }
			                    LOGGER.debug("*************** Successfully closed all existing database connections ********************");
			                    LOGGER.debug("*************** Removing all known database connections from RAM *********************");
			                    ram.setDBPM(null);
			                    ram.setValidatedConnections(null);
			                    LOGGER.debug("*************** database connections removed successfully *********************");
			                }
		                    pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                // Execute a SELECT query
					                connection.preparedQuery("Select * from public.tb_databaseConnections where status='active'")
					                .execute(
					                 res -> 
					                 {
					                	 if (res.succeeded()) 
					                     {
					                		RowSet<Row> rows = res.result();
					                      	rows.forEach(row -> 
					                      	{
					                      		// Print out each row
					                            LOGGER.info("Row: " + row.toJson());
					                            try
					                            {
					                            	JsonObject jo = new JsonObject(row.toJson().encode());
					                                ja.add(jo);
					                                LOGGER.info("Successfully added json object to array: " + jo.encodePrettily());
					                            }
					                            catch(Exception e)
					                            {
					                            	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
					                            }
					                                    
					                        });
					                      	connection.close();
					                      	LOGGER.info("closed method: " + method + " to connection pool");
					                        LOGGER.debug("adding database connection details to context");
					                        context.put("ConnectionData", ja);
					                        LOGGER.debug("added database connection details to context");
					                        response.send(ja.encodePrettily());
					                                
					                        /* Create the database connection pool for all the test databases */
					                                
					                        DatabasePoolManager DPM = new DatabasePoolManager(context);
					                       } 
					                       else 
					                       {
					                    	   // Handle query failure
					                           LOGGER.error("error: " + res.cause() );
					                           response.send(res.cause().getMessage());
					                           //res.cause().printStackTrace();
					                           connection.close();
					                           LOGGER.info("closed method: " + method + " to connection pool");
					                       }
					                       connection.close();
					                   });
					            } 
								else 
					            {
					                // Handle connection failure
					                JsonArray ja = new JsonArray();
					        		JsonObject jo = new JsonObject();
					        		jo.put("Error", ar.cause().getMessage().replaceAll("\"", ""));
					        		ja.add(jo);
					        		response.send(ja.encodePrettily());
					            }
					            
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        }
					}
				} 
		      }
		});

	}
	/****************************************************************/
	private void handleToggleDatabaseConnectionStatusByID(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleToggleDatabaseConnectionStatusByID";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						String id = JSONpayload.getString("id"); 
						LOGGER.info("id: " + id);
						
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
							LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	
		                    pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
									if (ar.succeeded()) 
						            {
						                SqlConnection connection = ar.result();
						                JsonArray ja = new JsonArray();
						                connection.preparedQuery("UPDATE public.tb_databaseConnections SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END WHERE id = $1;")
						                .execute(Tuple.of(Integer.parseInt(id)),
						                res -> 
						                {
						                	if (res.succeeded()) 
						                    {
						                		// Process the query result
						                        RowSet<Row> rows = res.result();
						                        LOGGER.info("Successfully toggled connection: " + id);
						                        response.send(ja.encodePrettily());
						                        connection.close();
						                        LOGGER.info("closed method: " + method + " to connection pool");
						                    } 
						                    else 
						                    {
						                    	LOGGER.error("error toggling connection: " +id+ " due to: " + res.cause() );
						                        response.send(res.cause().getMessage());
						                        connection.close();
						                        LOGGER.info("closed method: " + method + " to connection pool");
						                    }
						                    connection.close();
						               });
						            } 
									else 
						            {
						                JsonArray ja = new JsonArray();
						        		JsonObject jo = new JsonObject();
						        		jo.put("Error", ar.cause().getMessage().replaceAll("\"", ""));
						        		ja.add(jo);
						        		response.send(ja.encodePrettily());
						            }
						        }
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        }
					}
				} 
		      }
		});
	}
	/****************************************************************/
	private void handleGetDatabaseConnectionsByID(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleGetDatabaseConnectionsByID";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						String connectionId = JSONpayload.getString("id"); 
						LOGGER.info("ConnectionsID: " + connectionId);
						
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
							LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	
		                    pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("Select * from public.tb_databaseConnections WHERE id = $1")
					                .execute(Tuple.of(Integer.parseInt(connectionId)),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                                // Process the query result
					                		RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
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
					                        connection.close();
					                        LOGGER.info("closed method: " + method + " to connection pool");
					                        response.send(ja.encodePrettily());
					                      } 
					                      else 
					                      {
					                    	  // Handle query failure
					                          LOGGER.error("error: " + res.cause() );
					                          JsonArray ja2 = new JsonArray();
					                          JsonObject jo = new JsonObject();
					                          jo.put("Error", ar.cause().getMessage().replaceAll("\"", ""));
					                          ja2.add(jo);
					                          response.send(ja2.encodePrettily());
					                          //res.cause().printStackTrace();
					                          connection.close();
					                          LOGGER.info("closed method: " + method + " to connection pool");
					                       }
					                       connection.close();
					                	});
					            	} 
									else 
									{
					                // Handle connection failure
										ar.cause().printStackTrace();
										response.send(ar.cause().getMessage());
										JsonArray ja = new JsonArray();
						        		JsonObject jo = new JsonObject();
						        		jo.put("Error", ar.cause().getMessage().replaceAll("\"", ""));
						        		ja.add(jo);
						        		response.send(ja.encodePrettily());
									}
					            
							});
				        }
				        else
				        {
				        		JsonArray ja = new JsonArray();
				        		JsonObject jo = new JsonObject();
				        		jo.put("Error", "Issufficent authentication level to run API");
				        		ja.add(jo);
				        		response.send(ja.encodePrettily());
				        }
					}
				} 
		      }
		});
	}
	/****************************************************************/
	/****************************************************************/
	private void handleDeleteDatabaseConnectionsByID(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleDeleteDatabaseConnectionsByID");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
		if (pool == null)
		{
			LOGGER.debug("pool is null - restarting");
			DatabaseController DB = new DatabaseController(routingContext.vertx());
			LOGGER.debug("Taking the refreshed context pool object");
			pool = context.get("pool");
		}
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleGetDatabaseConnections required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String connectionId = JSONpayload.getString("id"); 
				LOGGER.info("ConnectionsID: " + connectionId);
				
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
		        	pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                
			                connection.preparedQuery("DELETE from public.tb_databaseConnections WHERE id = $1")
			                        .execute(Tuple.of(Integer.parseInt(connectionId)),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                // Process the query result
			                                /*RowSet<Row> rows = res.result();
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
			                                    
			                                });*/
			                            	
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully deleted connection\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
			                                
			                                response.send(ja.encodePrettily());
			                                
			                                /* Create the database connection pool for all the test databases */
			                                    
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\"Unable to delete connection\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.error("error: " + res.cause().getMessage() );
			                            	response.send(ja.encodePrettily());
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/****************************************************************/ 
	/****************************************************************/
	private void handleUpdateDatabaseConnectionById(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleUpdateDatabaseConnectionById");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleSetDatabaseConnections required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String status = JSONpayload.getString("status");
				String db_type = JSONpayload.getString("db_type");
				String db_version = JSONpayload.getString("db_version");
				String db_username = JSONpayload.getString("db_username");
				String db_password = JSONpayload.getString("db_password");
				String db_port = JSONpayload.getString("db_port");
				String db_database= JSONpayload.getString("db_database");
				String db_url = JSONpayload.getString("db_url");
				String db_jdbcClassName = JSONpayload.getString("db_jdbcClassName");
				String db_userIcon = JSONpayload.getString("db_userIcon");
				String db_databaseIcon = JSONpayload.getString("db_databaseIcon");
				String db_alias = JSONpayload.getString("db_alias");
				String db_access = JSONpayload.getString("db_access");
				String id = JSONpayload.getString("id");
				
				
				String db_connection_id = db_type+"_"+db_url+"_"+db_database+"_"+db_username;
				
				
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
				LOGGER.debug("id recieved: " + id);
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("UPDATE public.tb_databaseConnections SET status = $1, db_connection_id = $2, db_type = $3, db_version = $4, db_username = $5, db_password = $6, db_port = $7, db_database = $8, db_url = $9, db_jdbcClassName = $10, db_userIcon = $11, db_databaseIcon = $12 , db_alias = $13, db_access = $14 where id = $15")
			                        .execute(Tuple.of(status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon,db_alias,db_access, Integer.parseInt(id)),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                
			                            	
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully update connection\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully update connection: " + res.toString());
	                                    	
			                            	// Process the query result
			                                /*RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	JsonObject jo = new JsonObject("{\"response\":\"Successfully added connection\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array: " + row.toJson().encode());
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	JsonObject jo = new JsonObject("{\"response\":\""+ e.toString() +"\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.error("Unable to add database connection: " + e.toString());
			                                    }
			                                    
			                                });*/
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\""+ res.cause().getMessage().toString().replaceAll("\""," ") +"\"}");
	                                    	LOGGER.error("error: " + res.cause() );
	                                    	ja.add(jo);
	                                    	response.send(ja.encodePrettily());
			                                res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			            	
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/*************************************************************************************/
	
	/****************************************************************/
	private void handleSetDatabaseConnections(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleSetDatabaseConnections");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleSetDatabaseConnections required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String status = JSONpayload.getString("status");
				String db_type = JSONpayload.getString("db_type");
				String db_version = JSONpayload.getString("db_version");
				String db_username = JSONpayload.getString("db_username");
				String db_password = JSONpayload.getString("db_password");
				String db_port = JSONpayload.getString("db_port");
				String db_database= JSONpayload.getString("db_database");
				String db_url = JSONpayload.getString("db_url");
				String db_jdbcClassName = JSONpayload.getString("db_jdbcClassName");
				String db_userIcon = JSONpayload.getString("db_userIcon");
				String db_databaseIcon = JSONpayload.getString("db_databaseIcon");
				String db_alias = JSONpayload.getString("db_alias");
				String db_access = JSONpayload.getString("db_access");
				
				
				String db_connection_id = db_type+"_"+db_url+"_"+db_database+"_"+db_username;
				
				
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
				
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                
			                connection.preparedQuery("Insert into public.tb_databaseConnections(status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon,db_alias,db_access) values($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14)")
			                        .execute(Tuple.of(status, db_connection_id, db_type, db_version, db_username, db_password, db_port, db_database, db_url, db_jdbcClassName, db_userIcon, db_databaseIcon,db_alias,db_access),
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                                
			                            	
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully added connection\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString());
	                                    	
			                            	// Process the query result
			                                /*RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	JsonObject jo = new JsonObject("{\"response\":\"Successfully added connection\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array: " + row.toJson().encode());
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	JsonObject jo = new JsonObject("{\"response\":\""+ e.toString() +"\"}");
			                                    	ja.add(jo);
			                                    	LOGGER.error("Unable to add database connection: " + e.toString());
			                                    }
			                                    
			                                });*/
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\""+ res.cause().getMessage().toString().replaceAll("\""," ") +"\"}");
	                                    	LOGGER.error("error: " + res.cause() );
	                                    	ja.add(jo);
	                                    	response.send(ja.encodePrettily());
			                                res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			            	
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/*************************************************************************************/
	 // Utility to set parameters on PreparedStatement
    private void setParameters(PreparedStatement preparedStatement, Object... params) throws SQLException 
    {
        for (int i = 0; i < params.length; i++) 
        {
            preparedStatement.setObject(i + 1, params[i]);
        }
    }
    /************************************************************************************/
    private JsonObject executeUpdate(Connection connection, String sql)
    {
    	JsonObject JsonResponse = new JsonObject();
    	
    	try
    	{
    		JsonArray ja = new JsonArray();
    		
    		PreparedStatement preparedStatement = connection.prepareStatement(sql);
    		try
    		{
        		int result = preparedStatement.executeUpdate(); 
        		LOGGER.debug("executeUpdate result: " + result);
        		
        		try
        		{
	        		JsonObject jo = new JsonObject();
		        	jo.put("rows", result);
		        	ja.add(jo);
	            	
		        	
		        	
		        	JsonResponse.put("Result", ja);
	        		JsonResponse.put("SQL", sql);
        		}
        		catch(Exception e)
        		{
        			LOGGER.error("Unable to build JSON response: " + e.toString());
        		}
        	}
            catch(Exception e)
            {
            	LOGGER.error("Unable to execute query: " + e.toString());
            	JsonObject jo = new JsonObject();
	        	jo.put("Error", e.toString());
	        	ja.add(jo);
            	
	        	JsonResponse.put("Result", ja);
        		JsonResponse.put("SQL", sql);
            }
    		
    	}
    	catch(Exception e)
    	{
    		LOGGER.error("Unable to run query: " + e.toString());
    	}
    	return JsonResponse;
    }
    /******************************************************************************************/
    private JsonObject executeSelect(Connection connection, String sql)
    {
    	JsonObject JsonResponse = new JsonObject();
    	
    	try
    	{
    		JsonArray ja = new JsonArray();
    		
    		
    		PreparedStatement preparedStatement = connection.prepareStatement(sql);
    		try (ResultSet resultSet = preparedStatement.executeQuery()) 
            {
    			ja = convertResultSetToJson(resultSet);
    			LOGGER.debug("Select Partial ResultSet as JSON: " + ja.encodePrettily());
    			
    			
    			JsonResponse.put("Result", ja);
    			sql = sql.replaceAll("\"", "");
    			sql = sql.replaceAll("'", "");
    			
    			JsonResponse.put("SQL", sql);
    		}
            catch(Exception e)
            {
            	LOGGER.error("Unable to execute query: " + e.toString());
            	
            	JsonObject jo = new JsonObject();
	        	jo.put("Error", e.toString());
	        	ja.add(jo);
            	
	        	JsonResponse.put("Result", ja);
	        	
	        	sql = sql.replaceAll("\"", "");
    			sql = sql.replaceAll("'", "");
	        	
    			JsonResponse.put("SQL", sql);
            }
    		
    	}
    	catch(Exception e)
    	{
    		LOGGER.error("Unable to run query: " + e.toString());
    	}
		return JsonResponse;
    }
    
    private void handleGetDatabaseVersion(RoutingContext routingContext) 
    {
    	String method = "SetupPostHandlers.handleGetDatabaseVersion";
		LOGGER.info("Inside: " + method);  
		Ram ram = new Ram();
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
		    	
		    	response.putHeader("content-type", "application/json");
		    	
				JsonObject JSONpayload = routingContext.getBodyAsJson();
		      
				pool.getConnection(ar -> 
	            {
	                if (ar.succeeded()) 
	                {
	                    LOGGER.debug("Successfully got connection to master system database");
	                    
	                    String query = "SELECT * FROM public.tb_version";
	                    
	                    SqlConnection connection = ar.result();
		                JsonArray ja = new JsonArray();
		                connection.preparedQuery(query)
	                    .execute(res -> 
	                    {
	                    	if (res.succeeded()) 
	                        {
	                    		RowSet<Row> queryrows = res.result();
	                            for (Row row : queryrows) 
	                            {
	                            	JsonObject jo_row = row.toJson();
	                                LOGGER.debug("Row data: " + jo_row);
	                                response.send(jo_row.encodePrettily());
	                            }
	                            LOGGER.debug("Query run successfully");
	                            connection.close();
		                        LOGGER.info("closed method: " + method + " to connection pool");
	                        } 
	                        else 
	                        {
	                                LOGGER.error("Query failed: " + res.cause());
	                                connection.close();
			                        LOGGER.info("closed method: " + method + " to connection pool");
			                        JsonObject jo = new JsonObject();
	                                jo.put("error", ar.cause().getMessage().replaceAll("\""," "));
			                        response.send(jo.encodePrettily());
	                        }
	                    });

	                } 
	                else 
	                {
	                    LOGGER.error("Unable to get connection to master system database");
	                    JsonObject jo = new JsonObject();
                        jo.put("error", "Unable to get connection to master system database");
                        response.send(jo.encodePrettily());
	                }
	            });
		      
		      }
		});
    }
    /****************************************************************/
    /*SAMPLE PAYLOAD
	{   
	    "jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
	    "datasource":"mysql_127.0.0.1_world_mysqladmin",
	    "queryId":1,
	}
	/****************************************************************/
    private void handleRunDatabaseQueryByDatasourceMapAndQueryId(RoutingContext routingContext) 
    {
        LOGGER.info("Inside SetupPostHandlers.handleRunDatabaseQueryByDatasourceMapAndQueryId");  

        HttpServerResponse response = routingContext.response();
        JsonObject JSONpayload = routingContext.getBodyAsJson();
        JsonArray LoopRun = new JsonArray();

        if (JSONpayload.getString("jwt") == null) 
        {
            LOGGER.info("handleRunDatabaseQueryByDatasourceMap required fields not detected (jwt)");
            routingContext.fail(400);
        } 
        else 
        {
            if(validateJWTToken(JSONpayload)) 
            {
                LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
                String[] chunks = JSONpayload.getString("jwt").split("\\.");

                JsonObject payload = new JsonObject(decode(chunks[1]));
                LOGGER.info("Payload: " + payload );
                int authlevel = Integer.parseInt(payload.getString("authlevel"));
                JsonArray ja = new JsonArray();
                
                String datasource = JSONpayload.getString("datasource");
                Integer queryId = JSONpayload.getInteger("queryId");
                
                LOGGER.debug("Datasource:" + datasource + " queryID:" + queryId);
                
                
                JsonObject override = null;
                
                if(JSONpayload.containsKey("override"))
                {
                	LOGGER.debug("Override has been passed to function: ");
                	override = JSONpayload.getJsonObject("override");
                }
                else
                {
                	LOGGER.debug("No Override detected");
                }
                
                if(override!=null)
                {
                	LOGGER.debug("Have Recieved an OverRide: " + override);
                	try
                	{
                		// "override":{"function":"GenerateError", "type":"BadUsernamePassword", "payload":{"username":"RandonString","password":"RandonString"}}
                		LOGGER.debug("Successfully created override json object: " + override.getString("function"));
                		if(override.getString("function").compareToIgnoreCase("GenerateError")==0)
                		{
                			//JsonObject jo = generateError(override.getString("type"), override.getJsonObject("payload"), datasource, queryId);
                			//ja.add(jo);
                			//response.send(ja.encodePrettily());
                		}
                	}
                	catch(Exception e)
                	{
                		LOGGER.error("Unable to build overrideJson :" + e.toString());
                	}
                }
                else
                {
                	LOGGER.debug("No Override detected");
                	
                	LOGGER.debug("datasource received: " + datasource);

                    utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
                    LOGGER.info("Accessible Level is : " + authlevel);

                    if(authlevel >= 1) 
                    {
                        LOGGER.debug("User allowed to execute the API");
                        response.putHeader("content-type", "application/json");
                        Ram ram = new Ram();
                       
                        try 
                        {
                            Pool pool = ram.getPostGresSystemPool();
                            HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
    			        	
    			        	LOGGER.debug("Successfully initialized the datasource");
                            if (pool == null) 
                            {
                                database.thejasonengine.com.DatabaseController dbController = new database.thejasonengine.com.DatabaseController(routingContext.vertx());
                                LOGGER.debug("Have set the DB Controller");
                            } 
                            else 
                            {
                                LOGGER.debug("Pool already set");
                            }

                            pool = ram.getPostGresSystemPool();
                            pool.getConnection(fu -> 
                            {
                                if (fu.succeeded()) 
                                {
                                    LOGGER.debug("Successfully got connection to master system database");
                                    SqlClient systemConnection = fu.result();

                                    String query = "SELECT * FROM public.tb_query WHERE id = $1";
                                    
                                   LOGGER.debug("SELECT * FROM public.tb_query WHERE id = " + queryId);

                                    systemConnection.preparedQuery(query)
                                        .execute(Tuple.of(queryId), res -> 
                                        {
                                            if (res.succeeded()) 
                                            {
                                            	RowSet<Row> queryrows = res.result();
                                                for (Row row : queryrows) 
                                                {
                                                    JsonObject jo_row = row.toJson();
                                                    LOGGER.debug("Row data: " + jo_row);

                                                    String sqlParameterEncoded = jo_row.getString("query_string");
                                                    LOGGER.debug("Encoded Query: " + sqlParameterEncoded);
                                                    String sqlParameter = Encodings.UnescapeString(sqlParameterEncoded);
                                                    LOGGER.debug("Unencoded Query: " + sqlParameter);
                                                    Integer queryLoop = jo_row.getInteger("query_loop");
                                                    // Check if queryLoop is 0 and assign a random number between 1 and 100
                                                    if (queryLoop == 0) {
                                                        Random random = new Random();
                                                        queryLoop = random.nextInt(20) + 1;
                                                        LOGGER.debug("RANDOM QUERY LOOP IS : " + queryLoop);
                                                    }
                                                    LOGGER.debug("QUERY LOOP IS : " + queryLoop);
                                                    
                                                    StringTokenizer tokenizer = new StringTokenizer(sqlParameter, "\r\n");
                                                    DatabasePoolPOJO databasePoolPojo = new DatabasePoolPOJO();
                                                    
                                                    databasePoolPojo =  dataSourceMap.get(datasource);
                                                    BasicDataSource BDS = databasePoolPojo.getBDS();
                                                    
                                                    JSONObject joLoop;
                                                    JsonArray JsonResponse = new JsonArray();
                                                    for (int loopIndex = 0; loopIndex < queryLoop; loopIndex++) 
                                                    {
                                                    	 while (tokenizer.hasMoreTokens()) 
                                			             {
                                			                 String sql = tokenizer.nextToken();
                                			                 LOGGER.debug("Query[DatasourceMap]: " + loopIndex + " identified: " + sql );
                                			                
                                			                 //filterSystemVariables(sql, loopIndex, ram);
                                			                
                                			                 
                                			                 while(sql.contains("{SYSTEMVARIABLE}"))
                              				                {
                              				                	
                              				                	LOGGER.debug("Found a system variable string");
                              				                	
                              				                	JsonObject jo = ram.getSystemVariable();
                              				                	LOGGER.debug("My system variable: " + jo.encodePrettily());
                              				                	
                              				                	String swap = jo.getJsonObject("data").getString("mydatavariable");
                              				                	LOGGER.debug("Swap: " + swap); 
                              				                	
                              				                	sql = sql.replaceFirst("\\{SYSTEMVARIABLE\\}", swap);
                              				                	LOGGER.debug("query updated to: " + sql);
                              				                }
                                			                while(sql.contains("{STRING}"))
                             				                {
                             				                	
                             				                	LOGGER.debug("Found a variable string");
                             				                	String swap = generateRandomString();
                             				                	sql = sql.replaceFirst("\\{STRING\\}", swap);
                             				                	LOGGER.debug("query updated to: " + sql);
                             				                }
                                			                while(sql.contains("{INT}"))
                            				                {
                            				                	
                            				                	LOGGER.debug("Found a variable integer");
                            				                	String swap = String.valueOf(generateRandomInteger());
                            				                	sql = sql.replaceFirst("\\{INT\\}", swap);
                            				                	LOGGER.debug("query updated to: " + sql);
                            				                }
                                			                while(sql.contains("{i}"))
                            				                {
                            				                	
                            				                	LOGGER.debug("Found a iteration string");
                            				                	String swap = String.valueOf(loopIndex);
                            				                	sql = sql.replaceFirst("\\{i\\}", swap);
                            				                	LOGGER.debug("query updated to: " + sql);
                            				                }
                                			                while(sql.contains("{FIRSTNAME}"))
													        {
													        	
													        	LOGGER.debug("Found a variable firstname");
													        	
													        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomFirstName());
													        	sql = sql.replaceFirst("\\{FIRSTNAME\\}", swap);
													        	LOGGER.debug("query updated to: " + sql);
													        }
													        while(sql.contains("{SURNAME}"))
													        {
													        	
													        	LOGGER.debug("Found a variable surname");
													        	
													        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomSurname());
													        	sql = sql.replaceFirst("\\{SURNAME\\}", swap);
													        	LOGGER.debug("query updated to: " + sql);
													        }
													        while(sql.contains("{ADDRESSLINE1}"))
													        {
													        	
													        	LOGGER.debug("Found a variable addressline1");
													        	
													        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine1());
													        	sql = sql.replaceFirst("\\{ADDRESSLINE1\\}", swap);
													        	LOGGER.debug("query updated to: " + sql);
													        }
													        while(sql.contains("{ADDRESSLINE2}"))
													        {
													        	
													        	LOGGER.debug("Found a variable addressline2");
													        	
													        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine2());
													        	sql = sql.replaceFirst("\\{ADDRESSLINE2\\}", swap);
													        	LOGGER.debug("query updated to: " + sql);
													        }
                                			                if (sql.trim().toUpperCase().startsWith("SELECT")) 
                                			                {
                                			                	LOGGER.debug("We have detected an Select");
                                			                	try 
                                			                	{
                                			                		
                                			                		
                                			                		String regex = "\\{bruteforce(?::([^}]+))?\\}";

                                			                        Pattern pattern = Pattern.compile(regex);
                                			                        Matcher matcher = pattern.matcher(sql);

                                			                           	                            			                	
                                			                		if(matcher.find())
                                			                		{
                                			                			String username = matcher.group(1);
                                			                            LOGGER.debug("username found for brute force: " + username);
                                			                            
                                			                			LOGGER.debug("Generating a brute force based off of datasource: " + datasource);
                                			                			BruteForceDBConnections BF = new BruteForceDBConnections();
                                			                			JsonArray ja_hold = new JsonArray();
                                			                			ja_hold.add(BF.BruteForceConnectionErrors(datasource));
                                			                			JsonObject jo = new JsonObject();
                                			                			jo.put("Result",ja_hold );
                                			                			jo.put("loopIndex", loopIndex);
                                			                			jo.put("SQL", "Create bad connection");
                                			                			JsonResponse.add(jo);
                                			                		}
                                			                		else
                                			                		{
                                			                			LOGGER.debug("Attempting to retrieve database connection for select");
                                			                			try
                                			                			{
                                			                				if(BDS == null)
                                			                				{
                                			                					LOGGER.debug("BDS is null - recreating");
                                			                					databasePoolPojo = dataSourceMap.get(datasource);
                                			                					BDS = databasePoolPojo.getBDS();
                                			                				}
                                			                				
                                			                				Connection connection = BDS.getConnection();
                                			                				LOGGER.debug("Have retrieved database connection for select");
                                			                				String result = executeSelect(connection, sql).encodePrettily();
    	    	                            			                	LOGGER.debug("SELECT RESULT: " + result);
    	                                			                		JsonObject jo = new JsonObject(result);
    	    	                            			                	jo.put("loopIndex", loopIndex);
    	    	                            			                	
    	    	                            			                	LOGGER.debug("result jo now: " + jo.encodePrettily());
    	    	                            			                	
    	    	                            			                	JsonResponse.add(jo);
    	    	                            			                	
    	    	                            			                	LOGGER.debug("result ja now: " + JsonResponse.encodePrettily());
    	    	                            					            connection.close();
                                			                			}
                                			                			catch(Exception e)
                                			                			{
                                			                				LOGGER.error("Unable to get connection: " + e.toString());
                                			                			}
                                			                		}
                                			                	}
                                			                	catch(Exception error)
                                			                	{
                                			                		LOGGER.error("");
                                			                		JsonObject jo = new JsonObject("{\"response\":\"error running SELECT: " + error +"\"}");
                                			                		JsonResponse.add(jo);
                                			                	}
                                					        }
                                			                else if(sql.trim().toUpperCase().startsWith("--"))
                                			                {
                                			                	LOGGER.debug("Comment detected - Ignoring");
                                			                }
                                							else 
                                							{
                                								LOGGER.debug("We have detected an update");
                                								try 
                                			                	{
                                									String regex = "\\{bruteforce(?::([^}]+))?\\}";

                                			                        Pattern pattern = Pattern.compile(regex);
                                			                        Matcher matcher = pattern.matcher(sql);

                                			                           	                            			                	
                                			                		if(matcher.find())
                                			                		{
                                			                			String username = matcher.group(1);
                                			                            LOGGER.debug("username found for brute force: " + username);
                                										LOGGER.debug("Generating a brute force based off of datasource: " + datasource);
                                										BruteForceDBConnections BF = new BruteForceDBConnections();
                                										JsonArray ja_hold = new JsonArray();
                                										ja_hold.add(BF.BruteForceConnectionErrors(datasource));
                                			                			JsonObject jo = new JsonObject();
                                			                			jo.put("Result",ja_hold );
                                			                			jo.put("loopIndex", loopIndex);
                                			                			jo.put("SQL", "Create bad connection");
                                			                			JsonResponse.add(jo);
                                										
                                										
                                			                		}
                                			                		else
                                			                		{
                                			                			
                                			                			LOGGER.debug("Attempting to retrieve database connection for update");
                                			                			try
                                			                			{
                                			                				if(BDS == null)
                                			                				{
                                			                					LOGGER.debug("BDS is null - recreating");
                                			                					databasePoolPojo = dataSourceMap.get(datasource);
                                			                					BDS = databasePoolPojo.getBDS();
                                			                				}
                                			                				
                                			                				Connection connection = BDS.getConnection();
                                			                				
                                			                				LOGGER.debug("Have retrieved database connection for update");
                                			                				String result = executeUpdate(connection, sql).encodePrettily();
    	    	                            			                	LOGGER.debug("NON SELECT RESULT: " + result);
    	                                			                		JsonObject jo = new JsonObject(result);
    	    	                            			                	jo.put("loopIndex", loopIndex);
    	    	                            			                	
    	    	                            			                	LOGGER.debug("result jo now: " + jo.encodePrettily());
    	    	                            			                	
    	    	                            			                	JsonResponse.add(jo);
    	    	                            			                	LOGGER.debug("result ja now: " + JsonResponse.encodePrettily());
    	    	                            					            connection.close();
                                			                			}
                                			                			catch(Exception e)
                                			                			{
                                			                				LOGGER.error("Unable to get connection: " + e.toString());
                                			                			}
                                			                		}
                                			                	}
                                								catch(Exception error)
                                			                	{
                                			                		LOGGER.error("");
                                			                		JsonObject jo = new JsonObject("{\"response\":\"error running OTHER: " + error +"\"}");
                                			                		JsonResponse.add(jo);
                                			                	}
                                							}
                                			             }
                                			            //response.send(JsonResponse.encodePrettily());
                                                        tokenizer = new StringTokenizer(sqlParameter, ";\r\n");
                                                        LOGGER.debug("Query run successfully loop:  " + loopIndex);
                                                        LoopRun.add(JsonResponse);
                                                        JsonResponse = new JsonArray();
                                                    }
                                                    
                                                    response.send(LoopRun.encodePrettily());
                                                }
                                                LOGGER.debug("Query run successfully");
                                            } 
                                            else 
                                            {
                                                LOGGER.error("Query failed: " + res.cause());
                                            }
                                        });

                                    systemConnection.close();
                                } 
                                else 
                                {
                                    LOGGER.error("Unable to get connection to master system database");
                                }
                            });
                        } 
                        catch (Exception e) 
                        {
                            LOGGER.error("Unable to load data sources: " + e.toString());
                            JsonObject jo = new JsonObject();
                            jo.put("Error", "Failed to initialize data sources");
                            response.send(jo.encodePrettily());
                        }
                    } 
                    else 
                    {

                    	JsonObject jo = new JsonObject();
                        jo.put("Error", "Insufficient authentication level to run API");
                        ja.add(jo);
                        response.send(ja.encodePrettily());
                    }
                }
                

                
            }
        }
    }
    /****************************************************************/
    public static JsonObject generateError(String type, JsonObject payload, String datasource, int queryId)
    {
    	LOGGER.debug("Running generateError");
    	JsonObject Response = new JsonObject();
    	
    	return Response;
    	
    }
	/****************************************************************/
	
	/*SAMPLE PAYLOAD
	{   
	    "jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
	    "datasource":"mysql_127.0.0.1_world_mysqladmin",
	    "sql":"INSERT into world.country(Code, Name, Continent, Region, SurfaceArea, IndepYear, Population, LifeExpectancy, GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, Code2)Values ('JJA', 'j', 'Asia', 'j', 1,1,1,1.1,1.1, 1.0,'j', 'j','j',1,'jj');",
	}
	
	{   
    	"jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
    	"datasource":"mysql_127.0.0.1_world_mysqladmin",
    	"sql":"DELETE from world.country where code = 'JJA';",
    }
	
	{   
    	"jwt":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
    	"datasource":"mysql_127.0.0.1_world_mysqladmin",
    	"sql":"SELECT * from world.country;",
    }
	
	*/
    /****************************************************************/
	private void handleRunDatabaseQueryByDatasourceMap(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleRunDatabaseQueryByDatasourceMap");  
		
		String method = "handleRunDatabaseQueryByDatasourceMap";
		
		HttpServerResponse response = routingContext.response();
		JsonObject JSONpayload = routingContext.getBodyAsJson();
		
		JsonArray JsonResponse = new JsonArray();
		JsonArray ja = new JsonArray();
        JsonArray LoopRun = new JsonArray();
		
		if (JSONpayload.getString("jwt") == null) 
	    {
	    	LOGGER.info("handleRunDatabaseQueryByDatasourceMap required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String datasource = JSONpayload.getString("datasource");
				String sqlParameter = JSONpayload.getString("sql");
				String query_loop_string = JSONpayload.getString("query_loop");
				JsonObject override = JSONpayload.getJsonObject("override");
                
                if(override!=null)
                {
                	LOGGER.debug("Have Recieved an OverRide: " + override);
                	try
                	{
                		LOGGER.debug("Successfully created override json object: " + override.getString("function"));
                	}
                	catch(Exception e)
                	{
                		LOGGER.error("Unable to build overrideJson :" + e.toString());
                	}
                }
                
                
				
				
				
				
				int query_loop = 1;
				
				try
				{
					query_loop = Integer.parseInt(query_loop_string);
					if(query_loop >= 100)
					{
						query_loop = 100;
						LOGGER.debug("set query loop to 100 by force");
					}
					 if (query_loop == 0) {
                         Random random = new Random();
                         query_loop = random.nextInt(20) + 1;
                         LOGGER.debug("RANDOM QUERY LOOP IS : " + query_loop);
                     }
				}
				catch(Exception e)
				{
						LOGGER.error("Error setting up query loop - setting to default value of 1 because: " + e.toString());
						query_loop = 1;
				}
				
				
				
				
				//String type = JSONpayload.getString("type");
				
				LOGGER.debug("datasource recieved: " + datasource);
				LOGGER.debug("sqlParameter recieved: " + sqlParameter);
				
				utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
		        	Ram ram = new Ram();
		        	List<Map<String, Object>> rows = new ArrayList<>();
		        	BasicDataSource BDS = null;
		        	try
		        	{
		        		HashMap<String, DatabasePoolPOJO> dataSourceMap = ram.getDBPM();
		        		
		        		DatabasePoolPOJO databasePoolPojo = dataSourceMap.get(datasource);
    					BDS = databasePoolPojo.getBDS();
		        		LOGGER.debug("Successfully initialized the datasource");
			        	
			        	
			        	
			        	
			        	 StringTokenizer tokenizer = new StringTokenizer(sqlParameter, "\r\n");
			        	 for (int loopIndex = 0; loopIndex < query_loop; loopIndex++) 
                         {
			        		 while (tokenizer.hasMoreTokens()) 
    			             {
    			                 String sql = tokenizer.nextToken();
				                 LOGGER.debug("Query[DatasourceMap]: " + loopIndex + " identified: " + sql );
				                 
				                // filterSystemVariables(sql, loopIndex, ram);
				                 
				                 
				                while(sql.contains("{SYSTEMVARIABLE}"))
   				                {
   				                	
   				                	LOGGER.debug("Found a system variable string");
   				                	
   				                	JsonObject jo = ram.getSystemVariable();
   				                	LOGGER.debug("My system variable: " + jo.encodePrettily());
   				                	
   				                	String swap = jo.getJsonObject("data").getString("mydatavariable");
   				                	LOGGER.debug("Swap: " + swap); 
   				                	
   				                	sql = sql.replaceFirst("\\{SYSTEMVARIABLE\\}", swap);
   				                	LOGGER.debug("query updated to: " + sql);
   				                } 
				                while(sql.contains("{STRING}"))
				                {
				                	
				                	LOGGER.debug("Found a variable string");
				                	String swap = generateRandomString();
				                	sql = sql.replaceFirst("\\{STRING\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                
				                while(sql.contains("{INT}"))
				                {
				                	
				                	LOGGER.debug("Found a variable integer");
				                	String swap = String.valueOf(generateRandomInteger());
				                	sql = sql.replaceFirst("\\{INT\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                
				                while(sql.contains("{i}"))
				                {
				                	
				                	LOGGER.debug("Found a variable iteration");
				                	String swap = String.valueOf(loopIndex);
				                	sql = sql.replaceFirst("\\{i\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                 
				                while(sql.contains("{FIRSTNAME}"))
				                {
				                	
				                	LOGGER.debug("Found a variable firstname");
				                	
				                	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomFirstName());
				                	sql = sql.replaceFirst("\\{FIRSTNAME\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                while(sql.contains("{SURNAME}"))
				                {
				                	
				                	LOGGER.debug("Found a variable surname");
				                	
				                	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomSurname());
				                	sql = sql.replaceFirst("\\{SURNAME\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                while(sql.contains("{ADDRESSLINE1}"))
				                {
				                	
				                	LOGGER.debug("Found a variable addressline1");
				                	
				                	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine1());
				                	sql = sql.replaceFirst("\\{ADDRESSLINE1\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				                while(sql.contains("{ADDRESSLINE2}"))
				                {
				                	
				                	LOGGER.debug("Found a variable addressline2");
				                	
				                	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine2());
				                	sql = sql.replaceFirst("\\{ADDRESSLINE2\\}", swap);
				                	LOGGER.debug("query updated to: " + sql);
				                }
				             
				                if (sql.trim().toUpperCase().startsWith("SELECT")) 
				                {
				                	
				                	String regex = "\\{bruteforce(?::([^}]+))?\\}";

			                        Pattern pattern = Pattern.compile(regex);
			                        Matcher matcher = pattern.matcher(sql);

			                           	                            			                	
			                		if(matcher.find())
			                		{
			                			String username = matcher.group(1);
			                            LOGGER.debug("username found for brute force: " + username);
			                			LOGGER.debug("Generating a brute force based off of datasource: " + datasource);
			                			BruteForceDBConnections BF = new BruteForceDBConnections();
			                			JsonArray ja_hold = new JsonArray();
			                			ja_hold.add(BF.BruteForceConnectionErrors(datasource));
			                			JsonObject jo = new JsonObject();
			                			jo.put("Result",ja_hold );
			                			jo.put("loopIndex", loopIndex);
			                			jo.put("SQL", "Create bad connection");
			                			JsonResponse.add(jo);
			                		}
			                		else
			                		{
					                	
					                	Connection connection = BDS.getConnection();
					                	JsonObject jo = executeSelect(connection, sql);
					                	jo.put("loopIndex", loopIndex);
					                	JsonResponse.add(jo);
							            connection.close();
							            LOGGER.debug("Closed " + method +" connection to pool: " +datasource);
			                		}
						        }
				                else if(sql.trim().toUpperCase().startsWith("--"))
    			                {
    			                	LOGGER.debug("Comment detected - Ignoring");
    			                }
								else 
								{
									String regex = "\\{bruteforce(?::([^}]+))?\\}";

			                        Pattern pattern = Pattern.compile(regex);
			                        Matcher matcher = pattern.matcher(sql);

			                           	                            			                	
			                		if(matcher.find())
			                		{
			                			String username = matcher.group(1);
			                			JsonArray ja_hold = new JsonArray();
			                			JsonObject jo = new JsonObject();
			                			
			                			
			                			if(username == null)
			                			{
			                				LOGGER.debug("No additional username over ride passed in");
			                				jo.put("SQL", "Create brute force connection");
			                			}
			                			else
			                			{
			                				LOGGER.debug("Additional username over ride passed in");  
			                				datasource = datasource.replaceAll("_(?!.*_).*", "_"+username);
			                				jo.put("SQL", "Create brute force connection: " + username);
			                			}
			                            LOGGER.debug("Generating a brute force based off of datasource: " + datasource);
			                			BruteForceDBConnections BF = new BruteForceDBConnections();
			                			
			                			ja_hold.add(BF.BruteForceConnectionErrors(datasource));
			                			jo.put("Result",ja_hold );
			                			jo.put("loopIndex", loopIndex);
			                			JsonResponse.add(jo);
										
			                		}
			                		else
			                		{
										Connection connection = BDS.getConnection();
										JsonObject jo = executeUpdate(connection, sql);
										jo.put("loopIndex", loopIndex);
										JsonResponse.add(jo);
										connection.close();
										LOGGER.debug("Closed " + method +" connection to pool: " +datasource);
			                		}
								}
				             }
                        	//response.send(JsonResponse.encodePrettily());
                             tokenizer = new StringTokenizer(sqlParameter, ";\r\n");
                             LOGGER.debug("Query run successfully loop:  " + loopIndex);
                             LoopRun.add(JsonResponse);
                             JsonResponse = new JsonArray();
                         }
			        	 response.send(LoopRun.encodePrettily());
				            
		        	}
		        	catch(Exception e)
		        	{
		        		String error = e.getMessage().replaceAll("\"", "");
		        		LOGGER.error("Unable to load data sources: " + error);
		        		
		        		JsonObject jo = new JsonObject("{\"response\":\"error: " + error +"\"}");
                    	ja.add(jo);
                    	LOGGER.error("error: " + e.getMessage());
                    	response.send(ja.encodePrettily());
			        	
		        	}
		        }
		        else
		        {
		        	JsonObject jo = new JsonObject("{\"response\":\"error: Issufficent authentication level to run API\"}");
                	ja.add(jo);
                	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/****************************************************************/
	public static JsonArray convertResultSetToJson(ResultSet resultSet) throws SQLException 
	{
        // Create a JSONArray to hold the results
		JsonArray jsonArray = new JsonArray();
        
        // Get column metadata to know the column names
        ResultSetMetaData metaData = resultSet.getMetaData();
        int columnCount = metaData.getColumnCount();

        // Loop through the ResultSet and convert each row to a JSONObject
        while (resultSet.next()) 
        {
            JsonObject jsonObject = new JsonObject();
            
            // Loop through the columns and add the values to the JSONObject
            for (int i = 1; i <= columnCount; i++) 
            {
            	String columnName = metaData.getColumnName(i);
                Object value = resultSet.getObject(i);
                jsonObject.put(columnName, value);
            }
            // Add the current row (JSONObject) to the JSONArray
            jsonArray.add(jsonObject);
        }

        if(jsonArray.isEmpty())
        {
        	LOGGER.debug("Empty result found from query");
        	JsonObject jsonObject = new JsonObject();
        	String columnName = "Result";
            Object value = "Null";
            jsonObject.put(columnName, value);
            jsonArray.add(jsonObject);
        }
        
        
        return jsonArray;
    }
	
	/****************************************************************/
	private void handleGetDatabaseQueryByDbType(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetDatabaseQueryByDbType";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
			JsonObject JSONpayload = routingContext.getBodyAsJson();
			if (JSONpayload.getString("jwt") == null) 
			{
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			} 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String query_db_type = JSONpayload.getString("query_db_type");
						
						LOGGER.debug("Query recieved: " + query_db_type);
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						
						map.put("query_db_type", query_db_type);
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("select * from public.tb_query where fk_tb_databaseConnections_id = $1;")
					                .execute(Tuple.of(Integer.parseInt(map.get("query_db_type").toString())),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
					                        	LOGGER.info("Row: " + row.toJson());
					                            try
					                            {
					                            	JsonObject jo = new JsonObject(row.toJson().encode());
					                                jo.put("query_string", Encodings.UnescapeString(jo.getValue("query_string").toString()));
					                                ja.add(jo);
					                                LOGGER.info("Successfully added json object to array");
					                             }
					                             catch(Exception e)
					                             {
					                            	 LOGGER.error("Unable to add JSON Object to array: " + e.toString());
					                             }
					                                    
					                         });
					                         response.send(ja.encodePrettily());
					                         connection.close();
				                             LOGGER.debug("Closed " + method +" connection to pool");
					                    } 
					                    else 
					                    {
					                    	JsonObject jo = new JsonObject("{\"response\":\"error: " +ar.cause().getMessage().replaceAll("\"", "") +"\"}");
			                                ja.add(jo);
					                        LOGGER.error("error: " + ar.cause().getMessage() );
					                        response.send(ja.encodePrettily());
					                    	connection.close();
				                            LOGGER.error("Closed " + method +" connection to pool");
					                    }
					                    connection.close();
					                });
					            } 
								else 
								{
									JsonArray ja = new JsonArray();
					                JsonObject jo = new JsonObject("{\"response\":\"error: " +ar.cause().getMessage().replaceAll("\"", "") +"\"}");
	                                ja.add(jo);
			                        LOGGER.error("error: " + ar.cause().getMessage() );
			                        response.send(ja.encodePrettily());
					            }
					            
					        });
				        }
						else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        	
				        }
					}
				}
		     }
		});
	}
	/****************************************************************/
	private String generateRandomString()
	{
		String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		Random RANDOM = new Random();
		
		int length = 6 + RANDOM.nextInt(3); // Generates 6, 7, or 8
        StringBuilder sb = new StringBuilder(length);

        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(RANDOM.nextInt(CHARACTERS.length())));
        }

        return sb.toString();
	}
	/****************************************************************/
	private Integer generateRandomInteger()
	{
		Random RANDOM = new Random();
		int randomNumber = 1 + RANDOM.nextInt(50);
		return randomNumber;
		
	}
	
	
	
	/****************************************************************/
	private void handleUpdateDatabaseQueryByQueryId(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleUpdateDatabaseQueryByQueryId");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleUpdateDatabaseQueryByQueryId required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				
				String query_id = JSONpayload.getString("query_id");
				String query_db_type = JSONpayload.getString("query_db_type");
				String db_connection_id = JSONpayload.getString("db_connection_id");
				String query_string = JSONpayload.getString("query_string");
				String query_type = JSONpayload.getString("query_type");
				String query_usecase = JSONpayload.getString("query_usecase");
				String query_loop = JSONpayload.getString("query_loop");
				String query_description = JSONpayload.getString("query_description");
				String video_link = JSONpayload.getString("video_link");
				
				
				
				LOGGER.debug("Query id recieved: " + query_id);
				LOGGER.debug("Query db type recieved: " + query_db_type);
				LOGGER.debug("Query connection id recieved: " + db_connection_id);
				LOGGER.debug("Query string recieved: " + query_string);
				LOGGER.debug("Query type recieved: " + query_type);
				LOGGER.debug("Query Usecase recieved: " + query_usecase);
				LOGGER.debug("Query Loop recieved: " + query_loop);
				LOGGER.debug("query description recieved: " + query_description);
				LOGGER.debug("video_link recieved: " + video_link);
				
				
				utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
				
				String encoded_query = Encodings.EscapeString(query_string);
				LOGGER.debug("Query recieved: " + query_string);
				LOGGER.debug("Query encoded: " + encoded_query);
				
				//The map is passed to the SQL query
				Map<String,Object> map = new HashMap<String, Object>();
				
				map.put("query_id", query_id);
				map.put("query_db_type", query_db_type);
				map.put("db_connection_id", db_connection_id);
				map.put("query_string", encoded_query);
				map.put("query_type", query_type);
				map.put("query_usecase", query_usecase);
				map.put("query_loop", query_loop);
				map.put("query_description", query_description);
				map.put("video_link", video_link);
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                
							connection.preparedQuery("UPDATE public.tb_query SET query_db_type = $4, fk_tb_databaseConnections_id = $2, query_string = $3, query_type = $1, query_usecase = $6 , query_loop = $7, query_description = $8, video_link = $9 where id = $5")
			                        .execute(Tuple.of(map.get("query_db_type").toString(),
			                        		Integer.parseInt(map.get("db_connection_id").toString()),
			                        		map.get("query_string").toString(),
			                        		map.get("query_type").toString(),
			                        		Integer.parseInt(map.get("query_id").toString()),
			                        		map.get("query_usecase").toString(),
			                        		Integer.parseInt(map.get("query_loop").toString()),
			                        		map.get("query_description").toString(),
			                        		map.get("video_link").toString())
			                        		,
			                        res -> {
			                            if (res.succeeded()) 
			                            {
			                            	JsonObject jo = new JsonObject("{\"response\":\"Successfully updated sql statement\"}");
	                                    	ja.add(jo);
	                                    	LOGGER.info("Successfully added json object to array: " + res.toString().replaceAll("\"", ""));
			                            	
			                            	// Process the query result
			                                /*RowSet<Row> rows = res.result();
			                                rows.forEach(row -> {
			                                    // Print out each row
			                                    LOGGER.info("Row: " + row.toJson());
			                                    try
			                                    {
			                                    	
			                                    	JsonObject jo = new JsonObject(row.toJson().encode());
			                                    	jo.put("query_string", Encodings.UnescapeString(jo.getValue("query_string").toString()));
			                                    	ja.add(jo);
			                                    	LOGGER.info("Successfully added json object to array");
			                                    }
			                                    catch(Exception e)
			                                    {
			                                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
			                                    }
			                                    
			                                });*/
			                                response.send(ja.encodePrettily());
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	JsonObject jo = new JsonObject("{\"response\":\"error: " +res.cause().getMessage().replaceAll("\"", "") +"\"}");
	                                    	ja.add(jo);
			                            	LOGGER.error("error: " + res.cause() );
			                            	response.send(ja.encodePrettily());
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/****************************************************************/
	/****************************************************************/
	private void handleDeleteDatabaseQueryByQueryId(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleDeleteDatabaseQueryByQueryId";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				if (JSONpayload.getString("jwt") == null) 
				{
				    	LOGGER.info(method + " required fields not detected (jwt)");
				    	routingContext.fail(400);
				} 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						String query_id = JSONpayload.getString("query_id");
						
						LOGGER.debug("Query id recieved: " + query_id);
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						
						map.put("query_id", query_id);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                
					                connection.preparedQuery("delete from public.tb_query where id = $1;")
					                .execute(Tuple.of(Integer.parseInt(map.get("query_id").toString())),
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		JsonObject jo = new JsonObject("{\"response\":\"Successfully deleted sql statement\"}");
			                                ja.add(jo);
			                                LOGGER.info("Successfully added json object to array: " + res.toString());
					                        response.send(ja.encodePrettily());
					                        connection.close();
					                        LOGGER.debug("Closed " + method +" connection to pool");
					                    } 
					                    else 
					                    {
					                    	JsonObject jo = new JsonObject("{\"response\":\"error: " +res.cause().getMessage().replaceAll("\"", "") +"\"}");
			                                ja.add(jo);
					                        LOGGER.error("error: " + res.cause() );
					                        response.send(ja.encodePrettily());
					                        connection.close();
					                        LOGGER.error("Closed " + method +" connection to pool");       
					                    }
					                    connection.close();
					                });
					            } 
								else 
								{
					                // Handle connection failure
					                JsonArray ja = new JsonArray();
					                response.send(ar.cause().getMessage());
					                JsonObject jo = new JsonObject("{\"response\":\"error: " +ar.cause().getMessage().replaceAll("\"", "") +"\"}");
	                                ja.add(jo);
			                        LOGGER.error("error: " + ar.cause().getMessage() );
			                        response.send(ja.encodePrettily());
					            }
					            
					        });
				        }
						else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        	
				        }
					}
				}
		     }
		});
	}
	/****************************************************************/
	/****************************************************************/
	private void handleGetDatabaseQueryByQueryId(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleGetDatabaseQueryByQueryId");  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Pool pool = context.get("pool");
		
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
	    	LOGGER.info("handleGetDatabaseQueryByQueryId required fields not detected (jwt)");
	    	routingContext.fail(400);
	    } 
		else
		{
			if(validateJWTToken(JSONpayload))
			{
				LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
				String [] chunks = JSONpayload.getString("jwt").split("\\.");
				
				JsonObject payload = new JsonObject(decode(chunks[1]));
				LOGGER.info("Payload: " + payload );
				int authlevel  = Integer.parseInt(payload.getString("authlevel"));
				String query_id = JSONpayload.getString("query_id");
				
				LOGGER.debug("Query id recieved: " + query_id);
				
				utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
				
				//The map is passed to the SQL query
				Map<String,Object> map = new HashMap<String, Object>();
				
				map.put("query_id", query_id);
				
				LOGGER.info("Accessible Level is : " + authlevel);
		       
				if(authlevel >= 1)
		        {
		        	LOGGER.debug("User allowed to execute the API");
		        	response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> 
					{
			            if (ar.succeeded()) 
			            {
			                SqlConnection connection = ar.result();
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			               
							connection.preparedQuery("select * from public.tb_query where id = $1;")
			                        .execute(Tuple.of(Integer.parseInt(map.get("query_id").toString())),
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
			                                    	jo.put("query_string", Encodings.UnescapeString(jo.getValue("query_string").toString()));
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
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response.send(ar.cause().getMessage());
			            }
			            
			        });
		        }
		        else
		        {
		        	JsonArray ja = new JsonArray();
		        	JsonObject jo = new JsonObject();
		        	jo.put("Error", "Issufficent authentication level to run API");
		        	ja.add(jo);
		        	response.send(ja.encodePrettily());
		        }
		        
		        
			}
		}
	}
	/****************************************************************/
	private void handleGetQueryTypes(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleGetQueryTypes";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
			JsonObject JSONpayload = routingContext.getBodyAsJson();
			if (JSONpayload.getString("jwt") == null) 
			{
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			} 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						
						utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						
						
						LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("select * from public.tb_query_types;")
					                .execute(
					                res -> 
					                {
					                	if (res.succeeded()) 
					                    {
					                		RowSet<Row> rows = res.result();
					                        rows.forEach(row -> 
					                        {
					                        	//LOGGER.info("Row: " + row.toJson());
					                            try
					                            {
					                              	JsonObject jo = new JsonObject(row.toJson().encode());
					                              	ja.add(jo);
					                               	//LOGGER.info("Successfully added json object to array");
					                            }
					                            catch(Exception e)
					                            {
					                                    	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
					                            }
					                            
					                        });
					                        connection.close();
					                        LOGGER.debug("Closed " + method +" connection to pool");
					                        response.send(ja.encodePrettily());
					                    } 
					                    else 
					                    {
					                      	LOGGER.error("error: " + res.cause() );
					                      	JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause().toString().replaceAll("\"", "")+"}");
			                               	ja.add(jo);
			                               	response.send(ja.encodePrettily());
			                               	connection.close();
					                        LOGGER.error("Closed " + method +" connection to pool");
					                     }
					                     connection.close();
					                });
					            } 
								else 
								{
					                // Handle connection failure
					            	JsonArray ja = new JsonArray();
					                LOGGER.error("error: " + ar.cause() );
		                        	JsonObject jo = new JsonObject("{\"response\":\"error \" "+ar.cause().toString().replaceAll("\"", "")+"}");
		                        	ja.add(jo);
		                        	response.send(ja.encodePrettily());
					            }
							});
				        }
						else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        	
				        }
					}
				}
		     }
		});
		
	}
	/****************************************************************/
	private void handleGetDatabaseQuery(RoutingContext routingContext) 
	{
		
		String method = "SetupPostHandlers.handleGetDatabaseQuery";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
			if (validation.failed()) 
		    {
				LOGGER.error("DB validation failed: " + validation.cause().getMessage());
				return;
		    }
		    if (validation.succeeded())
		    {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
		    	JsonObject JSONpayload = routingContext.getBodyAsJson();
			if (JSONpayload.getString("jwt") == null) 
			{
			    LOGGER.info(method + " required fields not detected (jwt)");
			    routingContext.fail(400);
			} 
			else
			{
				if(validateJWTToken(JSONpayload))
				{
					LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
					String [] chunks = JSONpayload.getString("jwt").split("\\.");
					
					JsonObject payload = new JsonObject(decode(chunks[1]));
					LOGGER.info("Payload: " + payload );
					int authlevel  = Integer.parseInt(payload.getString("authlevel"));
					
					
					utils.thejasonengine.com.Encodings Encodings = new utils.thejasonengine.com.Encodings();
					
					//The map is passed to the SQL query
					Map<String,Object> map = new HashMap<String, Object>();
					
					
					LOGGER.info("Accessible Level is : " + authlevel);
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                
					                // Execute a SELECT query
					                connection.preparedQuery("select * from public.tb_query;")
					                .execute(
					                 res -> 
					                 {
					                	 if (res.succeeded()) 
					                     {
					                		 // Process the query result
					                         RowSet<Row> rows = res.result();
					                         rows.forEach(row -> 
					                         {
					                        	 // Print out each row
					                             //LOGGER.info("Row: " + row.toJson());
					                             try
					                             {
					                                  	
					                              	JsonObject jo = new JsonObject(row.toJson().encode());
					                               	jo.put("query_string", Encodings.UnescapeString(jo.getValue("query_string").toString()));
					                               	ja.add(jo);
					                               	//LOGGER.info("Successfully added json object to array");
					                             }
					                             catch(Exception e)
					                             {
					                               	LOGGER.error("Unable to add JSON Object to array: " + e.toString());
					                             }
					                         });
					                         response.send(ja.encodePrettily());
					                         connection.close();
					                         LOGGER.error("Closed " + method +" connection to pool");
					                     	} 
					                     	else 
					                        {
					                     		// Handle query failure
					                            LOGGER.error("error in " +method+ ":" + res.cause() );
					                            JsonObject jo = new JsonObject("{\"response\":\"error \" "+res.cause().getMessage().replaceAll("\"", "")+"}");
		                                    	ja.add(jo);
		                                    	response.send(ja.encodePrettily());
					                            connection.close();
		                                    	LOGGER.error("Closed " + method +" connection to pool");
					                         }
					                         // Close the connection
					                         //response.end();
					                         connection.close();
					                 	});
					            	} 
									else 
									{
										JsonArray ja = new JsonArray();
										JsonObject jo = new JsonObject("{\"response\":\"error \" "+ar.cause().getMessage().replaceAll("\"", "")+"}");
                                    	ja.add(jo);
                                    	response.send(ja.encodePrettily());
			                        }
					        	});
					         } 
					         else 
					         {
					        	JsonArray ja = new JsonArray();
								JsonObject jo = new JsonObject("{\"response\":\"error \"" +method+"\"}");
                             	ja.add(jo);
                             	response.send(ja.encodePrettily());
		                      }
							}
						}
					}
		    	});
		
	}
	/****************************************************************/
	
	/****************************************************************/
	/*	
	 	Accessed via post route: /api/login
	 	handleRegisterUser takes in a POST JSON Body Payload as:
	 	{
     		"username":"theUsername",
     		"password":"thePassword"
 		}
	 */
	/****************************************************************/
	private void handleValidateCredentials(RoutingContext routingContext) 
	{
		
		LOGGER.info("Inside SetupPostHandlers.handleValidateCredentials");  
		HttpServerResponse response = routingContext.response();
		JsonObject loginPayloadJSON = routingContext.getBodyAsJson();
		LOGGER.info(loginPayloadJSON);
		try 
		  { 
			//Make sure the context has the parameter that is expected.
				if (loginPayloadJSON.getString("username") == null || loginPayloadJSON.getString("password") == null) 
			    {
			    	LOGGER.info("Login ( username or password ) required fields not detected" + ", at IP:" + routingContext.request().remoteAddress());
			    	routingContext.fail(400);
			    } 
			    else 
			    {
			    	//JsonObject temp = new JsonObject();
			    	boolean verified = true;
			    		
			    	
			    		
			    	Map<String,Object> map = new HashMap<String, Object>();  
				    map.put("username", loginPayloadJSON.getValue("username"));
				    map.put("password", hashAndSaltPass(loginPayloadJSON.getValue("password").toString()));
				   
				    LOGGER.info("Setting user session for username: " + loginPayloadJSON.getValue("username"));
				    LOGGER.info("salty password: " + map.get("password"));
				   
				    /*****************************************************************************/
				    Context context = routingContext.vertx().getOrCreateContext();
					Pool pool = context.get("pool");
					
					if (pool == null)
					{
						LOGGER.debug("pull is null - restarting");
						DatabaseController DB = new DatabaseController(routingContext.vertx());
						LOGGER.debug("Taking the refreshed context pool object");
						pool = context.get("pool");
					}
					response
			        .putHeader("content-type", "application/json");
					
					pool.getConnection(ar -> {
			            if (ar.succeeded()) {
			                SqlConnection connection = ar.result();
			                
			                JsonArray ja = new JsonArray();
			                
			                // Execute a SELECT query
			                connection.preparedQuery("select * FROM function_login($1,$2)")
	                        .execute(Tuple.of(map.get("username"), map.get("password")), 
	                        		res -> {
	                        			if (res.succeeded()) 
			                            {
			                                // Process the query result
			                            	
			                                RowSet<Row> rows = res.result();
			                                
			                                rows.forEach(row -> 
			                                {
			                                	JsonObject jo = new JsonObject(row.toJson().encode());
			                                	ja.add(jo);
			                                	LOGGER.debug("Found user: " + ja.encodePrettily());
			                                });
			                                
			                                LOGGER.debug("Result size: " + ja.size());
			                                
			                                if(ja.size() > 0)
			                                {
			                                	LOGGER.debug("Found user: " + ja.encodePrettily());
			                                	
			                                	JsonObject dbObject = ja.getJsonObject(0);
			                                	
			                                	JWTAuth jwt;
			        						    // Set up the authentication tokens 
			        						    String name = "JWT";
			        						    
			        						    AuthUtils AU = new AuthUtils();
			        						    jwt = AU.createJWTToken(context);
			        						        	
			        						    JsonObject tokenObject = new JsonObject();
			        						        	
			        						    tokenObject.put("id", dbObject.getValue("id"));
			        						    tokenObject.put("firstname", dbObject.getValue("firstname"));
			        						    tokenObject.put("surname", dbObject.getValue("surname"));
			        						    tokenObject.put("email", dbObject.getValue("email"));
			        						    tokenObject.put("username", dbObject.getValue("username"));
			        						    tokenObject.put("active", dbObject.getValue("active"));
			        						    tokenObject.put("authlevel", dbObject.getValue("authlevel"));
			        						    		
			        						    String token = jwt.generateToken(tokenObject, new JWTOptions().setExpiresInSeconds(60000));
			        						    LOGGER.info("JWT TOKEN: " + token);
			        						        	
			        						    response
			        					        .putHeader("content-type", "application/json")
			        					        .end("{\"result\":\"ok\", \"jwt\": \""+token+"\"}");
			                                	
			                                	
			                                }
			                                else
			                                {
			                                	 response
			     						        .putHeader("content-type", "application/json")
			     						        .end("{\"result\":\"fail\", \"jwt\": \"Invalid credentials\"}");
			                                }
			                            } 
			                            else 
			                            {
			                                // Handle query failure
			                            	LOGGER.error("error: " + res.cause() );
			                            	response
			     						    .putHeader("content-type", "application/json")
			     						    .end("{\"result\":\"fail\", \"jwt\": \"Invalid credentials\"}");
			                                //res.cause().printStackTrace();
			                            }
			                            // Close the connection
			                            //response.end();
			                            connection.close();
			                        });
			            } else {
			                // Handle connection failure
			                ar.cause().printStackTrace();
			                response
 						    .putHeader("content-type", "application/json")
 						    .end("{\"result\":\"fail\", \"jwt\": \"Invalid credentials\"}");
			            }
			            
			        });
				   
				}
		}
		catch(Exception e)
		{
		  		LOGGER.info("ERROR: " + e.toString());
		  		response
				    .putHeader("content-type", "application/json")
				    .end("{\"result\":\"fail\", \"jwt\": \"Invalid credentials\"}");
		}
	}
	/****************************************************************/
	/*	
	 	Accessed via route: /api/createCookie
	 	handleRegisterUser takes in a POST JSON Body Payload as:
	 	{
     		"jwt":"theJWT"
 		}
	 */
	private void handleCreateCookie(RoutingContext routingContext) 
	{
		LOGGER.info("Inside SetupPostHandlers.handleCreateCookie");  
		HttpServerResponse response = routingContext.response();
		try
		{
		  String CookiePayload = new String(routingContext.getBodyAsString().getBytes("ISO-8859-1"), "UTF-8");
		  LOGGER.info("Cookie Payload:" + CookiePayload);
		  JsonObject createCookieJSON = routingContext.getBodyAsJson();
		  LOGGER.info("Cookie json value: " + createCookieJSON.encodePrettily());
		  LOGGER.info("Creating JSON cookie data");
		  if (createCookieJSON.getString("jwt") == null) 
		  {
		    	LOGGER.info("Create Cookie required fields (jwt) not detected" + ", at IP:" + routingContext.request().remoteAddress());
		    	routingContext.fail(400);
		  } 
		  else
		  {
			 
			  String token = createCookieJSON.getString("jwt");
			  
			  LOGGER.info("Created cookie JWT : " + token);
			  
			  
			  Vertx vertx = routingContext.vertx();	
			  
	      	  Context context = vertx.getOrCreateContext();
	      	  AuthUtils au = new AuthUtils();
	      	  
	      	  
	      	  /*****************************************************************/
	      	  /* We need to validate the JWT token before we add it as a cookie
	      	  /*****************************************************************/
	      	 LOGGER.info("Creating cookie");
	      	  Cookie cookie  = au.createCookie(routingContext, 60000, "JWT", token, "/");
	      	 LOGGER.info("Created cookie");
	      	
	      	 
	      	 response
	      	  .addCookie(cookie)
	      	  .setChunked(true)
	      	  .putHeader("content-type", "application/json")
	      	  .end("{\"result\":\"OK\", \"reason\": \"Cookie created\"}");
	      }	 
		}
		catch(Exception e)
		{
			LOGGER.error("Unable to get body of post as string: " + e.getMessage() + ", at IP:" + routingContext.request().remoteAddress());
			response
            .putHeader("content-type", "application/json")
            .end("{\"result\":\"Fail\", \"reason\": \""+e.toString()+"\"}");
		}
	
	}
	/****************************************************************/
	/*	
	 	Accessed via route: /api/createSession
	 	handleRegisterUser takes in a POST JSON Body Payload as:
	 	{
     		"jwt":"theJWT"
 		}
	 */
	private void handleCreateSession(RoutingContext routingContext) 
	{
		LOGGER.info("Inside SetupPostHandlers.handleCreateSession");  
		HttpServerResponse response = routingContext.response();
		try
		{
		  String SessionPayload = new String(routingContext.getBodyAsString().getBytes("ISO-8859-1"), "UTF-8");
		  LOGGER.info("Session Payload:" + SessionPayload);
		  
		  JsonObject createSessionJSON = routingContext.getBodyAsJson();
		  LOGGER.info(createSessionJSON);
		  
		  if (createSessionJSON.getString("jwt") == null) 
		  {
		    	LOGGER.info("CreateSession required fields (jwt) not detected" + ", at IP:" + routingContext.request().remoteAddress());
		    	routingContext.fail(400);
		  } 
		  else
		  {
			  String token = createSessionJSON.getString("jwt");
			  Vertx vertx = routingContext.vertx();					        	
	      	  Context context = vertx.getOrCreateContext();
			  SetupSession setupSession = new SetupSession(vertx);
	      	  setupSession.putTokenInSession(routingContext, "jwt", token);
	      	  LOGGER.info("Session created");
	      	  response
	      	  .putHeader("content-type", "application/json")
	      	  .end("{\"result\":\"OK\", \"reason\": \"Session Added To Context\"}");
	      }	  
		  
		}
		catch(Exception e)
		{
			LOGGER.error("Unable to get body of post as string: " + e.getMessage());
			response
            .putHeader("content-type", "application/json")
            .end("{\"result\":\"Fail\", \"reason\": \""+e.toString()+"\"}");
		}
	
	}
	/****************************************************************/
	/*	
	 	Accessed via route: /api/login
	 	handleRegisterUser takes in a POST JSON Body Payload as:
	 	{
     		"username":"theUsername"
 		}
	 */
	private void handleWebLogin(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleWebLogin";
		
		LOGGER.info("Inside: " + method);  
		
		Context context = routingContext.vertx().getOrCreateContext();
		Ram ram = new Ram();
		HttpServerResponse response = routingContext.response();
		
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				LOGGER.info(JSONpayload);
				
				if (JSONpayload.getString("username") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (username)");
			    	routingContext.fail(400);
			    } 
				else
				{
					LOGGER.info("Starting login prep for username: " + JSONpayload.getValue("username") );
		    		
		    		Map<String,Object> map = new HashMap<String, Object>();  
			    	map.put("username", JSONpayload.getValue("username"));
			    	map.put("password", hashAndSaltPass(JSONpayload.getValue("password").toString()));
			    	
			    	LOGGER.debug("map username: " + map.get("username"));
			    	LOGGER.debug("map password: " + map.get("password"));
					
			    	LOGGER.debug("User allowed to execute the API");
				    response
					.putHeader("content-type", "application/json");
				    pool.getConnection(ar -> 
					{
						if (ar.succeeded()) 
					    {
							SqlConnection connection = ar.result();
					        JsonArray ja = new JsonArray();
					        connection.preparedQuery("select * FROM function_login($1,$2)")
			                .execute(Tuple.of(map.get("username"), map.get("password")), 
					        res -> 
					        {
					        	if (res.succeeded()) 
			                    {
					        		RowSet<Row> rows = res.result();
			                        rows.forEach(row -> 
			                        {
			                        	JsonObject jo = new JsonObject(row.toJson().encode());
			                            ja.add(jo);
			                            LOGGER.debug("Found user: " + ja.encodePrettily());
			                        });
				                    LOGGER.debug("Result size: " + ja.size());
				                    if(ja.size() > 0)
			                        {
				                    	LOGGER.debug("Found user: " + ja.encodePrettily());
				                    	JsonObject dbObject = ja.getJsonObject(0);
			                            LOGGER.info("Successfully ran query: webLogin");
									    Vertx vertx = routingContext.vertx();					        	
									    FreeMarkerTemplateEngine engine = FreeMarkerTemplateEngine.create(vertx);
									    JWTAuth jwt;
									    String name = "JWT";
									    AuthUtils AU = new AuthUtils();
									    jwt = AU.createJWTToken(context);
									    JsonObject tokenObject = new JsonObject();
									        	
									        	// We would need to tweak these values to determine the authorization rights for the user
									    tokenObject.put("username", dbObject.getValue("username").toString());
									    tokenObject.put("authlevel", dbObject.getValue("authlevel").toString());
									    Map<String, String> memoryMap = ram.getRamSharedMap();
									    		
									    memoryMap.put("username", dbObject.getValue("username").toString());
									    memoryMap.put("authlevel",dbObject.getValue("authlevel").toString());
									        	
									    JSONObject jsonObject = new JSONObject(memoryMap);
							    		JsonObject jsonMemoryObject = new JsonObject(jsonObject.toString());
							    		String token = jwt.generateToken(jsonMemoryObject, new JWTOptions().setExpiresInSeconds(60000));
									    		
							    		LOGGER.info("JWT TOKEN CREATED AT WEB LOGIN: " + token + ", From IP:" + routingContext.request().remoteAddress());
									    memoryMap.put("jwt", token);
									    tokenObject.put("jwt", token);
									        	
									    LOGGER.debug("Added JWT Token to RAM");
									    //Not going to use session variables
									    //SetupSession setupSession = new SetupSession(vertx);
									    //LOGGER.info("created the session object");
									    //setupSession.putTokenInSession(routingContext, "token", token);
									    //setupSession.putTokenInSession(routingContext, "tokenObject", tokenObject.toString());
									    		
									    // Now we add the cookie values to the system such that they can be used for future manipulation
									    AuthUtils au = new AuthUtils();
									    Cookie cookie  = au.createCookie(routingContext, 60000, name, token, "/");
									    		
									    response.addCookie(cookie);
									    response.setChunked(true);
									    response.putHeader("Authorization", dbObject.getValue("authlevel").toString());
									    response.putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*");
									    //response.putHeader("content-type", "application/json");
									    response.putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_METHODS, "GET");
									    //response.send("{\"redirect\":\"loggedIn\\dashboard.ftl\"}");
									    		
									    routingContext.put("jsonMemoryObject", jsonMemoryObject);
									    routingContext.put("tokenObject", tokenObject);
									    		
									    engine.render(routingContext.data(), "templates/loggedIn/dashboard.ftl", 
										resy -> 
										{
											if (resy.succeeded()) 
										   	{
												String renderedContent = resy.result().toString();
										   		if (renderedContent.isEmpty()) 
										   		{
										   			LOGGER.error("Rendered content is empty!");
										   		}
										   		LOGGER.info(renderedContent);
										   		routingContext.response()
										   		.putHeader("content-type", "text/html")
										   		.end(renderedContent);
										   		
										   		LOGGER.debug("Successfully sent template");
										   	} 
										   	else 
										   	{
										   		routingContext.fail(resy.cause());
										   		LOGGER.error("Unable to send template : " + resy.cause().getMessage());
										   	}
										 });
			                        }
				                    else
				                    {
				                    	LOGGER.error("*Potential security violation* Signin error for username: " + map.get("username") + ", at IP:" + routingContext.request().remoteAddress());
									    response.sendFile("index.html", result -> 
									    {
									        if (res.failed()) 
									        {
									        	routingContext.fail(404);
									        }
									    });
									    response.end();
				                    }
			                    }
					        	else
			                    {
			                    	LOGGER.error("*Potential security violation* Signin error for username: " + map.get("username") + ", at IP:" + routingContext.request().remoteAddress());
								    response.sendFile("index.html", result -> 
								    {
								        if (res.failed()) 
								        {
								        	routingContext.fail(404);
								        }
								    });
								    response.end();
			                    }
					        });
					        connection.close();
                        	LOGGER.error("Closed " + method +" connection to pool");
					    }
						else
						{
							LOGGER.error("Cannot get connection to database");
							
						}
					});
		      }}
		      else
		      {
		    	  JsonArray ja = new JsonArray();
				  JsonObject jo = new JsonObject();
				  jo.put("Error", "ERROR on weblogin");
				  ja.add(jo);
				  LOGGER.info("ERROR on weblogin");
				  response.sendFile("index.html");
				  
				  
		      }
		});
	}
	/** **********************************************************/
	/* This function is called repeatidly to validate that the user
	 * has access to the site.
	 */
	/*************************************************************/ 
	private void handleValidateUserStatus(RoutingContext routingContext) 
	{
		String method = "SetupPostHandlers.handleValidateUserStatus";
		
		LOGGER.info("Inside: " + method);  
		
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		
		validateSystemPool(pool, method).onComplete(validation -> 
		{
		      if (validation.failed()) 
		      {
		        LOGGER.error("DB validation failed: " + validation.cause().getMessage());
		        return;
		      }
		      if (validation.succeeded())
		      {
		    	LOGGER.debug("DB Validation passed: " + method);
		    	HttpServerResponse response = routingContext.response();
				JsonObject JSONpayload = routingContext.getBodyAsJson();
				
				if (JSONpayload.getString("jwt") == null) 
			    {
			    	LOGGER.info(method + " required fields not detected (jwt)");
			    	routingContext.fail(400);
			    } 
				else
				{
					if(validateJWTToken(JSONpayload))
					{
						LOGGER.info("jwt: " + JSONpayload.getString("jwt") );
						String [] chunks = JSONpayload.getString("jwt").split("\\.");
						JsonObject payload = new JsonObject(decode(chunks[1]));
						LOGGER.info("Payload: " + payload );
						int authlevel  = Integer.parseInt(payload.getString("authlevel"));
						
						//The map is passed to the SQL query
						Map<String,Object> map = new HashMap<String, Object>();
						map.put("username", payload.getValue("username"));
						LOGGER.info("Accessible Level is : " + authlevel);
				        LOGGER.info("username: " + map.get("username"));
						
						if(authlevel >= 1)
				        {
				        	LOGGER.debug("User allowed to execute the API");
				        	response
					        .putHeader("content-type", "application/json");
				        	pool.getConnection(ar -> 
							{
					            
								if (ar.succeeded()) 
					            {
					                SqlConnection connection = ar.result();
					                JsonArray ja = new JsonArray();
					                connection.preparedQuery("select username, active from tb_user where username = $1")
			                        .execute(Tuple.of(map.get("username")), 
			                        res -> 
			                        {
			                        	if (res.succeeded()) 
					                    {
			                        		boolean active = true;
			                        		RowSet<Row> rows = res.result();
						                    rows.forEach(row -> 
						                    {
						                    	JsonObject jo = new JsonObject(row.toJson().encode());
						                        ja.add(jo);
						                        LOGGER.debug("Found user: " + ja.encodePrettily());
						                    });
						                    LOGGER.debug("Result size: " + ja.size());
						                    if(ja.size() > 0)
						                    {
						                    	LOGGER.debug("Found user: " + ja.encodePrettily());
						                    	JsonObject dbObject = ja.getJsonObject(0);
						                        if(dbObject.getString("active").compareToIgnoreCase("inactive") == 0)
							    	        	{
						                        	LOGGER.error("**Potential security violation* STATUS ERROR**, From IP:" + routingContext.request().remoteAddress() + " for username: " + dbObject.getString("username"));
							    	        		active = false;
							    	        	}
						                    }
						                    LOGGER.info("Successfully ran query: handleValidateUserStatus");
						        			if(!active)
						        			{
						        				response
						        			    .putHeader("content-type", "application/json")
						        			    .end("{\"result\":\"Fail\", \"reason\": \"inactive\"}");
						        			}
						        			else
						        			{
						        				response
						        			    .putHeader("content-type", "application/json")
						        			    .end("{\"result\":\"ok\", \"reason\": \"ok\"}");
						        			}
						        			connection.close();
						                    LOGGER.error("Closed " + method +" connection to pool");
					                    }
			                        	else
			                        	{
			                        		response
			                        		.putHeader("content-type", "application/json")
			                        		.end("{\"result\":\"Fail\", \"reason\": \"invalid authorization token\"}"); 
			                        		connection.close();
						                    LOGGER.error("Closed " + method +" connection to pool");
			                        	}
			                        });
					            } 
					            else 
					            {
					            	LOGGER.error("Unable to validate user status: " + ar.cause().getMessage());
					            	response
			        				.putHeader("content-type", "application/json")
			        				.end("{\"result\":\"Fail\", \"reason\": \"invalid authorization token\"}"); 
		                        	
					            }
							});
				        }
						else
				        {
				        	JsonArray ja = new JsonArray();
				        	JsonObject jo = new JsonObject();
				        	jo.put("Error", "Issufficent authentication level to run API");
				        	ja.add(jo);
				        	response.send(ja.encodePrettily());
				        	
				        }
					}
				}
		     }
		});
		
	}
	/**
	 * @return **********************************************************/
	/*
	/* This function validates and returns true if JWT token validates
	/*
	/************************************************************/
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
	/**
	 * Method to hash and salt password before use
	 * @param inputPass
	 * @returns actual password in db for match
	 * 
	 */
	public static String hashAndSaltPass (String inputPass)
	{
		String salt = "Rasputin";
		//hash the input password for later comparison with password in db
		MessageDigest md = null;
		try 
		{
			md = MessageDigest.getInstance("SHA-256");
		} 
		catch (NoSuchAlgorithmException e1) 
		{
			LOGGER.error("SHA-256 Not Found: " + e1.toString());
		}
		String text = inputPass+salt;
		try 
		{
			md.update(text.getBytes("UTF-8"));
		} 
		catch (UnsupportedEncodingException e) 
		{
			LOGGER.error("Could not convert Hash to Encoding: " + e.toString());
		} 
		// Change this to "UTF-16" if needed
		byte[] digest = md.digest();
	
		//convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < digest.length; i++) 
        {
          sb.append(Integer.toString((digest[i] & 0xff) + 0x100, 16).substring(1));
        }
        
        return sb.toString();
	}
	private String filterSystemVariables(String SQL, int loopIndex, Ram ram)
	{
		String sql = SQL;
		while(sql.contains("{SYSTEMVARIABLE}"))
          {
			
          	LOGGER.debug("Found a system variable string");
          	
          	JsonObject jo = ram.getSystemVariable();
          	LOGGER.debug("My system variable: " + jo.encodePrettily());
          	
          	String swap = jo.getJsonObject("data").getString("mydatavariable");
          	LOGGER.debug("Swap: " + swap); 
          	
          	sql = sql.replaceFirst("\\{SYSTEMVARIABLE\\}", swap);
          	LOGGER.debug("query updated to: " + sql);
          }
        while(sql.contains("{STRING}"))
         {
         	
         	LOGGER.debug("Found a variable string");
         	String swap = generateRandomString();
         	sql = sql.replaceFirst("\\{STRING\\}", swap);
         	LOGGER.debug("query updated to: " + sql);
         }
        while(sql.contains("{INT}"))
        {
        	
        	LOGGER.debug("Found a variable integer");
        	String swap = String.valueOf(generateRandomInteger());
        	sql = sql.replaceFirst("\\{INT\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        while(sql.contains("{FIRSTNAME}"))
        {
        	
        	LOGGER.debug("Found a variable firstname");
        	
        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomFirstName());
        	sql = sql.replaceFirst("\\{FIRSTNAME\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        while(sql.contains("{SURNAME}"))
        {
        	
        	LOGGER.debug("Found a variable surname");
        	
        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomSurname());
        	sql = sql.replaceFirst("\\{SURNAME\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        while(sql.contains("{ADDRESSLINE1}"))
        {
        	
        	LOGGER.debug("Found a variable addressline1");
        	
        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine1());
        	sql = sql.replaceFirst("\\{ADDRESSLINE1\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        while(sql.contains("{ADDRESSLINE2}"))
        {
        	
        	LOGGER.debug("Found a variable addressline2");
        	
        	String swap = String.valueOf(utils.thejasonengine.com.DataVariableBuilder.randomAddressLine2());
        	sql = sql.replaceFirst("\\{ADDRESSLINE2\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        while(sql.contains("{i}"))
        {
        	
        	LOGGER.debug("Found a iteration string");
        	String swap = String.valueOf(loopIndex);
        	sql = sql.replaceFirst("\\{i\\}", swap);
        	LOGGER.debug("query updated to: " + sql);
        }
        return sql;
	}
}


class asyncWrapper<T> 
{
	  // asyncWrapper<String> message = new asyncWrapper<>("Initial");
	  // message.value = "Updated value";
	  T value;
	  asyncWrapper(T value) 
	  { 
		  this.value = value; 
	  }
}
	
	

