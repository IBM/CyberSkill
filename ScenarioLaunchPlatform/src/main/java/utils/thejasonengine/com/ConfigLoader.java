/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package utils.thejasonengine.com;

import io.vertx.config.ConfigRetriever;
import io.vertx.config.ConfigRetrieverOptions;
import io.vertx.config.ConfigStoreOptions;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import memory.thejasonengine.com.Ram;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.nio.file.Paths;

public class ConfigLoader 
{
	
	private static final Logger LOGGER = LogManager.getLogger(ConfigLoader.class);
	
    public static void loadProperties(String filename) 
    {
	    Vertx vertx = Vertx.vertx();
	    Ram ram = new Ram();
	    
	    
	    String configPath = Paths.get(filename).toAbsolutePath().toString();
        System.out.println("Loading config from: " + configPath);
	    
	    ConfigStoreOptions fileStore = new ConfigStoreOptions()
	        .setType("file")
	        .setConfig(new JsonObject().put("path", configPath));
	
	    ConfigRetrieverOptions options = new ConfigRetrieverOptions().addStore(fileStore);
	    ConfigRetriever retriever = ConfigRetriever.create(vertx, options);
	
	    LOGGER.debug("Attempting to load system properties from: " + filename);
	    
	    retriever.getConfig(ar -> 
	    {
	        if (ar.succeeded()) 
	        {
	            JsonObject config = ar.result();
	            ram.setSystemConfig(config);
	            LOGGER.debug("Config version value retrieved from "+filename+" : " + config.getString("config.version"));
	            //config.getJsonObject("dbserver").getInteger("port"));
	        } 
	        else 
	        {
	           LOGGER.error("Failed to load "+filename+" : " + ar.cause());
	        }
	    });
	}
}