/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package database.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.SqlConnection;
import pojos.thejasonengine.com.DatasourcePojo;
import router.thejasonengine.com.SetupPostHandlers;

public class AgentDatabaseController 
{
	private static final Logger LOGGER = LogManager.getLogger(AgentDatabaseController.class);
	
	public Handler<RoutingContext> agentDatabase; 
	
	public AgentDatabaseController(Vertx vertx)
    {
		agentDatabase = AgentDatabaseController.this::handleAgentDatabase;
    }
	private void handleAgentDatabase(RoutingContext routingContext)
	{
		JsonObject PayloadJSON = routingContext.getBodyAsJson();

		String databaseId = PayloadJSON.getString("databaseId");
		String queryID = PayloadJSON.getString("queryID");
		
		LOGGER.info("Inside AgentDatabaseController.handleAgentDatabase");
		HttpServerResponse response = routingContext.response();
		try 
		{ 
			if(databaseId.compareToIgnoreCase("postgres") == 0)
			{
				DatasourcePojo dbs = new DatasourcePojo();
				Pool pool = dbs.DatasourcePojo(databaseId, routingContext.vertx());
				JsonArray ja = new JsonArray();
				
				pool.getConnection(ar -> 
				{
				    if (ar.succeeded()) 
				    {
				        // Connection obtained from pool
				    	SqlConnection connection = ar.result();

				        // Execute a query
				        connection.query("SELECT * FROM public.tb_user").execute(query -> 
				        {
				            if (query.succeeded()) 
				            {
				            	 RowSet<Row> rows = query.result();
	                             rows.forEach(row -> 
	                             {
	                                	JsonObject jo = new JsonObject(row.toJson().encode());
	                                	ja.add(jo);
	                                	LOGGER.debug(ja.encodePrettily());
	                             });
	                            
				            } 
				            else 
				            {
				                LOGGER.error("Query failed: " + query.cause());
				                JsonObject jo = new JsonObject();
				                jo.put("Error", query.cause());
				                ja.add(jo);
				            }
				            response
 					        .putHeader("content-type", "application/json")
 					        .end(ja.encodePrettily());	
				            // Close the connection after the query
				            connection.close();
				        });

				    } else {
				        LOGGER.error("Failed to get connection: " + ar.cause());
				    }
				});
				
			}
		}
		catch(Exception e)
		{
			LOGGER.error("Unable to complete simple test: " + e.toString());
		}
		
		
	}
	
}
