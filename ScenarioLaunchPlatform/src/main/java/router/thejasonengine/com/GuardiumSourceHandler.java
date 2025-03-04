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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import database.thejasonengine.com.DatabaseController;
import io.vertx.core.Context;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.mysqlclient.MySQLPool;
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

public class GuardiumSourceHandler 
{
	private static final Logger LOGGER = LogManager.getLogger(GuardiumSourceHandler.class);
	
	/******************************************************************************************/
	public static void handleMonitorGuardium(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public static void handleMonitorGuardiumSourcesForCron(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public static void handleMonitorGuardiumSources(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public static void handleMonitorGuardiumSourceMessageStatById(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	public static void handleMonitorGuardiumDataByMessageIdHash(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	}
	/******************************************************************************************/
	public static void handleMonitorGuardiumDataByMessageIdHashAndInternalId(RoutingContext routingContext)
	{
		Context context = routingContext.vertx().getOrCreateContext();
		HttpServerResponse response = routingContext.response();
		JsonArray ja = new JsonArray();
		
		JsonObject jo = new JsonObject("{\"response\":\"Not available in Opensource edition\"}");
    	ja.add(jo);
    	response.send(ja.encodePrettily());	
	
	}
	/******************************************************************************************/
	
}
