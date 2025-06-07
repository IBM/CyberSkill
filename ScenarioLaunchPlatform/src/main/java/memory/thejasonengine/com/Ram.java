/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package memory.thejasonengine.com;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import demodata.thejasonengine.com.DatabasePoolPOJO;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.core.shareddata.LocalMap;
import io.vertx.core.shareddata.SharedData;
import io.vertx.ext.web.Router;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.sqlclient.Pool;
import messaging.thejasonengine.com.Websocket.StorySocket;

public class Ram extends AbstractVerticle 
{
	
	private static final Logger LOGGER = LogManager.getLogger(Ram.class);
	private static LocalMap<String, String> ramSharedMap;
	private static HashMap<String, DatabasePoolPOJO> dataSourceMap;
	private static Pool pool;
	private static MySQLPool mySQLPool;
	private static JsonObject systemConfig;
	private static Router router;
	private static JsonObject userAlias_Access;
	private static JsonObject systemVariable;
	private static HashMap<String, JsonArray> validatedConnections;
	private static ArrayList<StorySocket> StorySocketList;
	
	private static HashMap<String, JsonObject> plugins;
	
	/*******************************************************************************/
	public Ram()
	{
		
	}
	public void initializeSharedMap(Vertx vertx) 
	{
	    SharedData sharedData = vertx.sharedData();
	    ramSharedMap = sharedData.getLocalMap("ram-map");
	}
	public LocalMap<String, String> getRamSharedMap()
	{
		LOGGER.info("Have retrieved the RAM LocalMap");
		return Ram.ramSharedMap;
	}
	public void setRamSharedMap(LocalMap<String, String> ramSharedMap)
	{
		ramSharedMap = Ram.ramSharedMap;
		LOGGER.info("Have set the RAM ramSharedMap");
	}
	/*********************************************************************/
	public ArrayList<StorySocket> getStorySocketList()
	{
		return Ram.StorySocketList;
	}
	public void setStorySocketList(ArrayList<StorySocket> StorySocketList)
	{
		Ram.StorySocketList = StorySocketList;
		LOGGER.info("Have set the RAM StorySocketList");
	}
	/*********************************************************************/
	public HashMap<String, DatabasePoolPOJO> getDBPM()
	{
		return Ram.dataSourceMap;
	}
	public void setDBPM(HashMap<String, DatabasePoolPOJO> dataSourceMap)
	{
		Ram.dataSourceMap = dataSourceMap;
		LOGGER.info("Have set the RAM dataSourceMap");
	}
	/*********************************************************************/
	public Router getRouter()
	{
		return Ram.router;
	}
	public void setRouter(Router router)
	{
		Ram.router = router;
		LOGGER.info("Have set the RAM router");
	}
	/*********************************************************************/
	public JsonObject getSystemVariable()
	{
		return Ram.systemVariable;
	}
	public void setSystemVariable(JsonObject systemVariable)
	{
		Ram.systemVariable = systemVariable;
		LOGGER.info("Have set the RAM systemVariable");
	}
	/*********************************************************************/
	public JsonObject getSystemConfig()
	{
		return Ram.systemConfig;
	}
	public void setSystemConfig(JsonObject systemConfig)
	{
		Ram.systemConfig = systemConfig;
		LOGGER.info("Have set the RAM systemConfig");
	}
	/*********************************************************************/
	public JsonObject getUserAlias_Access()
	{
		return Ram.userAlias_Access;
	}
	public void setUserAlias_Access(JsonObject userAlias_Access)
	{
		Ram.userAlias_Access = userAlias_Access;
		LOGGER.info("Have set the RAM user alias and access");
	}
	/*********************************************************************/
	public HashMap<String, JsonObject> getPlugins()
	{
		return Ram.plugins;
	}
	public void setPlugins(HashMap<String, JsonObject> plugins)
	{
		Ram.plugins = plugins;
		LOGGER.info("Have set the RAM plugins");
	}
	/*********************************************************************/
	public HashMap<String, JsonArray> getValidatedConnections()
	{
		return Ram.validatedConnections;
	}
	public void setValidatedConnections(HashMap<String, JsonArray> validatedConnections)
	{
		Ram.validatedConnections = validatedConnections;
		LOGGER.info("Have set the RAM validatedConnections");
	}
	/*********************************************************************/
	public Pool getPostGresSystemPool()
	{
		return Ram.pool;
	}
	public void setPostGresSystemPool(Pool pool)
	{
		Ram.pool = pool;
		LOGGER.info("Have set the RAM PostGresSystemPool");
	}
	/*********************************************************************/
	public MySQLPool getMySQLGuardiumCollectorPool()
	{
		return Ram.mySQLPool;
	}
	public void setMySQLGuardiumCollectorPool(MySQLPool mySQLPool)
	{
		Ram.mySQLPool = mySQLPool;
		LOGGER.info("Have set the RAM MySQLGuardiumCollectorPool");
	}
	/*********************************************************************/
	
}