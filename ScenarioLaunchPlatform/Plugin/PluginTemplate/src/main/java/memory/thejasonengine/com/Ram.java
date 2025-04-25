/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package memory.thejasonengine.com;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.core.shareddata.LocalMap;
import io.vertx.core.shareddata.SharedData;
import io.vertx.ext.web.Router;
import io.vertx.mysqlclient.MySQLPool;
import io.vertx.sqlclient.Pool;

public class Ram extends AbstractVerticle 
{
	
	private static final Logger LOGGER = LogManager.getLogger(Ram.class);
	private static LocalMap<String, String> ramSharedMap;
	private static HashMap<String, BasicDataSource> dataSourceMap;
	private static Pool pool;
	private static MySQLPool mySQLPool;
	private static JsonObject systemConfig;
	private static JsonObject pluginConfig;
	private static Router router;
	
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
	public HashMap<String, BasicDataSource> getDBPM()
	{
		return Ram.dataSourceMap;
	}
	public void setDBPM(HashMap<String, BasicDataSource> dataSourceMap)
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
	public JsonObject getPluginConfig()
	{
		return Ram.pluginConfig;
	}
	public void setPluginConfig(JsonObject pluginConfig)
	{
		Ram.pluginConfig = pluginConfig;
		LOGGER.info("Have set the RAM pluginConfig");
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