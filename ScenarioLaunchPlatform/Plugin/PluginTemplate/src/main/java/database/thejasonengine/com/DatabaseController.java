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

import io.vertx.mysqlclient.MySQLConnectOptions;
import io.vertx.mysqlclient.MySQLPool;


public class DatabaseController 
{
	private static final Logger LOGGER = LogManager.getLogger(DatabaseController.class);
	
	public DatabaseController(Vertx vertx) 
	{
		
		LOGGER.debug("Setting up Database Controller");
		SystemDatabaseController(vertx); 
		
	}
	
	
	public void SystemDatabaseController(Vertx vertx) 
	{
		
		Ram ram = new Ram();
		
		JsonObject configs = ram.getSystemConfig();
	
		PgConnectOptions connectOptions = new PgConnectOptions()
			      .setHost(configs.getJsonObject("systemDatabaseController").getString("host"))
			      .setPort(configs.getJsonObject("systemDatabaseController").getInteger("port"))
			      .setDatabase(configs.getJsonObject("systemDatabaseController").getString("database"))
			      .setUser(configs.getJsonObject("systemDatabaseController").getString("user"))
			      .setPassword(configs.getJsonObject("systemDatabaseController").getString("password"));

	    PoolOptions poolOptions = new PoolOptions().setMaxSize(configs.getJsonObject("systemDatabaseController").getInteger("maxConnections")); // Max pool size
        LOGGER.debug("Set pool options");
        Pool pool = Pool.pool(vertx, connectOptions, poolOptions);
        try
        {
        	pool.getConnection(ar ->
        	{
        		if(ar.succeeded())
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
}
