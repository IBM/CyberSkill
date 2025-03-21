/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package demodata.thejasonengine.com;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import memory.thejasonengine.com.Ram;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import io.vertx.core.Context;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.core.shareddata.LocalMap;

public class DatabasePoolManager 
{

	private static final Logger LOGGER = LogManager.getLogger(DatabasePoolManager.class);
	
	public DatabasePoolManager(Context context) 
    {
        Ram ram = new Ram();
        HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
        HashMap<String, JsonArray> validatedConnections = ram.getValidatedConnections();
     // Modify the userAlias_Access
        JsonObject newAlias_Access = new JsonObject();
        
        if(dataSourceMap == null)
        {
        	dataSourceMap = new HashMap<String, BasicDataSource>();
        }
        if(validatedConnections == null)
        {
        	validatedConnections = new HashMap<String, JsonArray>();
        }
        try
		{
			JsonArray ja = context.get("ConnectionData");
			LOGGER.info("Number of context served ConnectionData elements: " + ja.size()); /*This will error if there is non found*/
			for (int i = 0; i < ja.size(); i ++)
			{
				JsonObject jo = ja.getJsonObject(i);
                BasicDataSource DataSource = new BasicDataSource();
		        LOGGER.debug("Creating Database pool for: jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database")+ " using: " + jo.getString("db_username"));
		        LOGGER.info("The database type is: " + jo.getString("db_type"));
		        if (jo.getString("db_type").equalsIgnoreCase("mysql"))
		        {
		        	LOGGER.debug("Setting Datasource URL for mysql -  setting useSSL=False");
		        	DataSource.setUrl("jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database")+"?allowPublicKeyRetrieval=true&useSSL=false");
		        }
		        else
		        {
		        	DataSource.setUrl("jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database"));
		        }
		        
		    	DataSource.setUsername(jo.getString("db_username"));
		    	DataSource.setPassword(jo.getString("db_password"));
		    	DataSource.setDriverClassName(jo.getString("db_jdbcclassname"));
		    	DataSource.setInitialSize(5);
		    	DataSource.setMaxTotal(10);
		    	DataSource.setMinIdle(2);
		    	DataSource.setMaxIdle(5);
		    	DataSource.setMaxWaitMillis(10000);
		    	
		    	String dpName = jo.getString("db_type")+"_"+jo.getString("db_url")+"_"+jo.getString("db_database")+"_"+jo.getString("db_username"); 	
		
		    	try
		    	{
		    		LOGGER.debug("Testing datasource connection");
		    		DataSource.getConnection();
		    		
		    		LOGGER.debug("Connection successul adding the connection the the datasource map");
		    		String alias = jo.getString("db_alias");
		    		String access = jo.getString("db_access");
		    		LOGGER.debug("Connection ID" + dpName + " Alias: " + alias + " Access: " + access);
		    		JsonArray jaa = new JsonArray();
		    		
		    		JsonObject details = new JsonObject();
		    		details.put("alias", alias);
		    		
		    		details.put("access", access);
		    	
		    		//details.put("connection", dpName);
		    		
		    		jaa.add(details);
		    		validatedConnections.put(dpName, jaa);
		    		dataSourceMap.put(dpName, DataSource);		
		    		//ram.setUserAlias_Access(newAlias_Access);
		    		
			        LOGGER.debug("Database pool created  "+ dpName +"  and added to the dataSourceMap");
		    	}
		    	catch(Exception e)
		    	{
		    		LOGGER.error("Unable to add Datasource because of connection issue: " + e.toString());
		    	}
		    	
		    	
			}
			LOGGER.debug("All Database Pool Objects created");
			ram.setDBPM(dataSourceMap);
			ram.setValidatedConnections(validatedConnections);
			context.put("ValidatedConnectionData", dataSourceMap);
			context.put("ValidatedConnections", validatedConnections);
			LOGGER.debug("All Database Pool Objects added to Ram/Context dataSourceMap ");
		}
        catch(Exception e)
        {
        	LOGGER.error("Unable to load connects from connections file: " + e.toString());
        }
    	
    }
	
	
	public DatabasePoolManager(JsonArray ja) 
    {
		Ram ram = new Ram();
		HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
		 // Modify the userAlias_Access
        JsonObject newAlias_Access = new JsonObject();
		if(dataSourceMap == null)
		{
			LOGGER.debug("datasource map has not been initialized");
			dataSourceMap = new HashMap<>();
		}
		
        for (int i = 0; i < ja.size(); i ++)
		{
        	BasicDataSource DataSource = new BasicDataSource();
        	JsonObject jo = ja.getJsonObject(i);
        	LOGGER.debug("Creating Database pool for: jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database")+ " using: " + jo.getString("db_username"));
        	LOGGER.info("The database type is: " + jo.getString("db_type"));
        	if (jo.getString("db_type").equalsIgnoreCase("mysql"))
	        {
        		LOGGER.debug("Setting Datasource URL for mysql -  setting useSSL=False");
        		DataSource.setUrl("jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database")+"?allowPublicKeyRetrieval=true&useSSL=false");
	        }
	        else
	        {
	        	DataSource.setUrl("jdbc:"+jo.getString("db_type")+"://"+jo.getString("db_url")+":"+jo.getString("db_port")+"/"+jo.getString("db_database"));
	        }
	    	DataSource.setUsername(jo.getString("db_username"));
	    	DataSource.setPassword(jo.getString("db_password"));
	    	DataSource.setDriverClassName(jo.getString("db_jdbcClassName"));
	    	DataSource.setInitialSize(5);
	    	DataSource.setMaxTotal(10);
	    	DataSource.setMinIdle(2);
	    	DataSource.setMaxIdle(5);
	    	DataSource.setMaxWaitMillis(10000);
    	
	    	String dpName = jo.getString("db_type")+"_"+jo.getString("db_url")+"_"+jo.getString("db_database")+"_"+jo.getString("db_username"); 	
	    	dataSourceMap.put(dpName, DataSource);
	    	ram.setDBPM(dataSourceMap);
	    	//dataSourceMap = ram.getDBPM();
	    	LOGGER.debug("Number of datasource elements: "+dataSourceMap.size());
	    	LOGGER.debug("Database pool created  "+ dpName +"  and added to the dataSourceMap");
		}
    	
    }
 	public Connection getConnectionFromPool(String dpName) throws SQLException 
    {
		Ram ram = new Ram();
		HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
		if(dataSourceMap == null)
		{
			LOGGER.debug("datasource map has not been initialized");
			dataSourceMap = new HashMap<>();
		}
		BasicDataSource dataSource = dataSourceMap.get(dpName);
        if (dataSource != null) 
        {
            return dataSource.getConnection();
        }
        throw new SQLException("No connection pool found for the database: " + dpName);
    }

    public void closeAllPools() throws SQLException 
    {
    	Ram ram = new Ram();
		Map<String, BasicDataSource> dataSourceMap = ram.getDBPM();
    	if(dataSourceMap == null)
    	{
    		LOGGER.debug("dataSourceMap is null");
    	}
    	else
    	{
			for (BasicDataSource dataSource : dataSourceMap.values()) 
	        {
	            if (dataSource != null) 
	            {
	                dataSource.close();
	            }
	        }
    	}
    }
    
    
    /*This function is called at the start up of the system to make the subsequent connection calls faster */
	public void initialzeConnectionPool(Context context)
	{
		LOGGER.debug("inside DBPMgetHandlers.initialzeConnectionPool");
		
		JsonArray ja = context.get("connectionPoolArray");
    	Ram ram = new Ram();
    	
		for (int i = 0; i < ja.size(); i ++)
		{
			JsonObject jo = ja.getJsonObject(i);
            String dpName = jo.getString("id");
            LOGGER.debug("dpName/id:" + dpName + " type:" + jo.getString("type"));
            try 
            {
            	HashMap<String, BasicDataSource> dataSourceMap = ram.getDBPM();
        		if(dataSourceMap == null)
        		{
        			LOGGER.debug("datasource map has not been initialized");
        		}
        		else
        		{
        			LOGGER.debug("datasource map has been initialized");
        			if(dataSourceMap.containsKey(dpName))
        			{
        				LOGGER.debug("Found datasource: " +dpName+ " for datasource map.");
        				
        				
        				context.executeBlocking(promise -> 
        				{
        				    try 
        				    {
        				    	Connection dbpConnection = dataSourceMap.get(dpName).getConnection();
                	            LOGGER.debug("added a connection to the pool: " + dpName);
        				    }
        				    catch(Exception e)
        				    {
        				    	LOGGER.error("Unable to set up pool connection: " + e.toString());
        				    }
        				}, 
        				result -> 
        				{
        					if (result.succeeded()) 
        					{
        						LOGGER.debug("Successfully created connection");
        					}
        				});
        			
        			}
        		}
            }
            catch(Exception e)
            {
            	LOGGER.error("Unable to set the database pool connections: " + e.toString());
            }
		}
	}
	
	
	
	
}