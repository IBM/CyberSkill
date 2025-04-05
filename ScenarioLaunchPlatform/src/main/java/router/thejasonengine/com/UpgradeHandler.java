/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import java.sql.Timestamp;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import database.thejasonengine.com.DatabaseController;
import file.thejasonengine.com.Read;
import io.vertx.core.Context;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.SqlClient;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;
import memory.thejasonengine.com.Ram;
import story.thejasonengine.com.RunStoryVerticle;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.DeploymentOptions;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;

public class UpgradeHandler 
{
	private static final Logger LOGGER = LogManager.getLogger(UpgradeHandler.class);
	
	public Handler<RoutingContext> checkForUpgrade;
	public Handler<RoutingContext> upgradeToLatest;
	public Handler<RoutingContext> upgradeToVersion;
	
	/******************************************************************************************/
	public UpgradeHandler(Vertx vertx)
    {
		checkForUpgrade = UpgradeHandler.this::handleCheckForUpgrade;
		upgradeToLatest = UpgradeHandler.this::handleUpgradeToLatest;
		upgradeToVersion = UpgradeHandler.this::handleUpgradeToVersion;
    }
	/******************************************************************************************/
	public void handleCheckForUpgrade(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		
		
		
		/************************************************************/
		try 
        {
    		response.putHeader("content-type", "application/json");
            Ram ram = new Ram();
            Pool pool = ram.getPostGresSystemPool();
            HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
        	
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

                    String query = "SELECT * FROM public.tb_version";

                    systemConnection.preparedQuery(query)
                        .execute(res -> 
                        {
                            
                        	if (res.succeeded()) 
                            {
                            	RowSet<Row> queryrows = res.result();
                            	String schemaVersion = "01.0000";
                        		
                                for (Row row : queryrows) 
                                {
                                    JsonObject jo_row = row.toJson();
                                    LOGGER.debug("Row data: " + jo_row);
                                    schemaVersion = jo_row.getString("version");
                                    schemaVersion = schemaVersion.replaceAll("[a-zA-Z]", "");
                                    
                                    
                                }
                                LOGGER.debug("Query run successfully");
                                double currentSchemaVersion = Double.parseDouble(schemaVersion);
                                
                                
                        		LOGGER.debug("Current build number: " + currentSchemaVersion);
                        		
                        		JsonObject systemConfig = ram.getSystemConfig();
                        		JsonObject jo_server = systemConfig.getJsonObject("server");
                        		
                        		String requiredSchemaVersion = jo_server.getString("schema");
                        		LOGGER.debug("System build schema: " + requiredSchemaVersion);
                        		double requiredSchema = Double.parseDouble(requiredSchemaVersion);
                        		
                        		int result = Double.compare(requiredSchema, currentSchemaVersion);
                        		if(result > 0)
                        		{
                        			LOGGER.debug("Required is greater than current - perform an upgrade");
                        			upgradeToLatest(routingContext, currentSchemaVersion);
                        		}
                        		else if(result < 0)
                        		{
                        			JsonObject jo = new JsonObject("{\"response\":\"error: unable to check for upgrade\"}");
                        			LOGGER.debug("Required schema is less than current schema - this really should not happen");
                        			response.send(jo.encodePrettily());
                        		}
                        		else
                        		{
                        			JsonObject jo = new JsonObject("{\"response\":\"error: unable to check for upgrade\"}");
                        			LOGGER.debug("No update required as the required and current are the same");
                        			response.send(jo.encodePrettily());
                        		}
                            } 
                            else 
                            {
                                LOGGER.error("Query failed: " + res.cause());
                                JsonObject jo1 = new JsonObject("{\"response\":\"error: Query failed\"}");
                                response.send(jo1.encodePrettily());
                            }
                        });

                    systemConnection.close();
                   
                } 
                else 
                {
                    LOGGER.error("Unable to get connection to master system database");
                    JsonObject jo = new JsonObject("{\"response\":\"error: Unable to get connection to master system database\"}");
                    response.send(jo.encodePrettily());
                }
            });
        } 
        catch (Exception e) 
        {
            LOGGER.error("Unable to load data sources: " + e.toString());
            JsonObject jo = new JsonObject("{\"response\":\"error: Unable to load data sources\"}");
            response.send(jo.encodePrettily());
        }
		
		
		
		/************************************************************/
	}
	/******************************************************************************************/
	public void handleUpgradeToLatest(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"No upgrade available\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public void handleUpgradeToVersion(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"No upgrade available\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public void upgradeToLatest(RoutingContext routingContext, double currentSchemaVersion)
	{
		LOGGER.debug("Upgrading schema to latest from: " + String.valueOf(currentSchemaVersion));
		
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		Read read = new Read();
		String schema = Read.getDatabaseSchemaInfo(String.valueOf(currentSchemaVersion));
		
		LOGGER.debug("Scheama updates to run: " + schema);
		
		updateSchema(schema);
		
		JsonObject jo = new JsonObject("{\"response\":\"Upgrade completed successfully\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	private void updateSchema(String schema)
	{
		String[] statements = schema.split(";");
		Ram ram = new Ram();
		Pool pool = ram.getPostGresSystemPool();
		executeSqlStatements(pool, statements, 0);
	}
	private static void executeSqlStatements(Pool pool, String[] statements, int index) 
	{
		LOGGER.debug("Number of statements to run: " + statements.length);
		int i = 0;
        for (i = 0; i < statements.length; i++) 
        {
            String statement = statements[i].trim();
            if (!statement.isEmpty()) 
            {
            	pool.query(statement).execute(res -> 
                {
                    if (res.succeeded()) 
                    {
                        LOGGER.debug("Executed: " + statement);
                    }
                    else 
                    {
                    	LOGGER.debug("Error executing: " + statement);
                        res.cause().printStackTrace();
                    }
                });
                i = i+1;
                executeSqlStatements(pool, statements, i);
            }
            else
            {
            	i = i+1;
            	executeSqlStatements(pool, statements, i);
            }
        }
        // All SQL statements executed
        LOGGER.debug("All SQL statements executed.");
        pool.close(); // Close the pool
        
    }
}
