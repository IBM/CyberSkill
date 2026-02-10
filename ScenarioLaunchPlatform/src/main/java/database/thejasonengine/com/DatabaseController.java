/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package database.thejasonengine.com;

import java.util.HashMap;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Context;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.sqlclient.SqlClient;
import io.vertx.sqlclient.SqlConnection;
import memory.thejasonengine.com.Ram;
import metrics.thejasonengine.com.MetricsCollector;

import io.vertx.mysqlclient.MySQLConnectOptions;
import io.vertx.mysqlclient.MySQLPool;


public class DatabaseController 
{
	private static final Logger LOGGER = LogManager.getLogger(DatabaseController.class);
	
	public DatabaseController(Vertx vertx) 
	{
		
		LOGGER.debug("Setting up Database Controller");
		SystemDatabaseController(vertx); 
		//CollectorDatabaseController(vertx);
	}
	
	
	public void SystemDatabaseController(Vertx vertx) 
	{
		
		Ram ram = new Ram();
		
		LOGGER.debug("Evaluating postgres system pool");
		
		if(ram.getPostGresSystemPool() == null)
		{
			LOGGER.debug("ram postgresSystemPool not initialized.");
			JsonObject configs = ram.getSystemConfig();
			
			PgConnectOptions connectOptions = new PgConnectOptions()
				      .setHost(configs.getJsonObject("systemDatabaseController").getString("host"))
				      .setPort(configs.getJsonObject("systemDatabaseController").getInteger("port"))
				      .setDatabase(configs.getJsonObject("systemDatabaseController").getString("database"))
				      .setUser(configs.getJsonObject("systemDatabaseController").getString("user"))
				      .setPassword(configs.getJsonObject("systemDatabaseController").getString("password"));
	
		    PoolOptions poolOptions = new PoolOptions()
		    		.setIdleTimeout(30000) // 30 seconds
		    		.setShared(true) 
		    		.setMaxSize(configs.getJsonObject("systemDatabaseController").getInteger("maxConnections"));
		    		
		    					
		    				
	        LOGGER.debug("Set pool options");
	        Pool pool = Pool.pool(vertx, connectOptions, poolOptions);
	        try
	        {
	        	MetricsCollector metrics = MetricsCollector.getInstance();
	        	long startTime = System.currentTimeMillis();
	        	metrics.incrementActiveConnections();
	        	
	        	pool.getConnection(con_ar ->
	        	{
	        		long duration = System.currentTimeMillis() - startTime;
	        		
	        		if(con_ar.succeeded())
	        		{
	        			LOGGER.debug("--- POOL TEST COMPLETE, SYSTEM CONNECTION AVAILABLE ---");
	        			metrics.recordQuery(true, duration);
	        		}
	        		else
	        		{
	        			LOGGER.error("--- POOL TEST FAILURE, SYSTEM CONNECTION UNAVAILABLE ---");
	        			metrics.recordQuery(false, duration);
	        			metrics.recordError("DatabaseConnectionError", "Pool test failure: " + con_ar.cause().getMessage(), "");
	        		}
	        		
	        		metrics.decrementActiveConnections();
	        	});
	        }
	        catch(Exception e)
	        {
	        	LOGGER.error("Unable to get connection to pool :" + e.toString());
	        	MetricsCollector.getInstance().recordError("DatabaseException", "Unable to get connection: " + e.toString(), e.toString());
	        }
	        
	        LOGGER.debug("Pool Created");
	        
	        Context context = vertx.getOrCreateContext();
	        context.put("pool", pool);
	        LOGGER.debug("Pool added to context");
	        ram.setPostGresSystemPool(pool);
	        LOGGER.info("JDBC Pool SET");
		}
		else
		{
			ram.getPostGresSystemPool().getConnection(ar -> 
			{
				if (ar.succeeded()) 
				{
					 LOGGER.debug("JDBC Pool SET already - not recreating!!");
				}
				if(ar.failed())
				{
					JsonObject configs = ram.getSystemConfig();
				
					PgConnectOptions connectOptions = new PgConnectOptions()
						      .setHost(configs.getJsonObject("systemDatabaseController").getString("host"))
						      .setPort(configs.getJsonObject("systemDatabaseController").getInteger("port"))
						      .setDatabase(configs.getJsonObject("systemDatabaseController").getString("database"))
						      .setUser(configs.getJsonObject("systemDatabaseController").getString("user"))
						      .setPassword(configs.getJsonObject("systemDatabaseController").getString("password"));
			
					PoolOptions poolOptions = new PoolOptions()
					    		.setIdleTimeout(30000) // 30 seconds
					    		.setShared(true) 
					    		.setMaxSize(configs.getJsonObject("systemDatabaseController").getInteger("maxConnections"));
					  
			        LOGGER.debug("Set pool options");
			        Pool pool = Pool.pool(vertx, connectOptions, poolOptions);
			        try
			        {
			        	pool.getConnection(con_ar ->
			        	{
			        		if(con_ar.succeeded())
			        		{
			        			LOGGER.debug("--- POOL TEST COMPLETE, SYSTEM CONNECTION AVAILABLE ---");
			        		}
			        		else
			        		{
			        			LOGGER.error("--- POOL TEST FAILURE, SYSTEM CONNECTION UNAVAILABLE ---");
			        		}
			        	});
			        }
			        catch(Exception e)
			        {
			        	LOGGER.error("Unable to get connection to pool :" + e.toString());
			        }
			        
			        LOGGER.debug("Pool Created");
			        
			        Context context = vertx.getOrCreateContext();
			        context.put("pool", pool);
			        LOGGER.debug("Pool added to context");
			        ram.setPostGresSystemPool(pool);
			        LOGGER.info("JDBC Pool SET");
				}
			});
			}
		}
	}
