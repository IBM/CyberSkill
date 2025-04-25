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
import messaging.thejasonengine.com.PublisherVerticle;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.nio.file.Paths;

public class PluginLoader 
{
	
	private static final Logger LOGGER = LogManager.getLogger(PluginLoader.class);
	
    public static void loadPlugin(String filename) 
    {
	    Vertx vertx = Vertx.vertx();
	    Ram ram = new Ram();
	    
	    
	    String pluginPath = Paths.get(filename).toAbsolutePath().toString();
        LOGGER.debug("Loading plugin from: " + pluginPath);
	    
        vertx.fileSystem().readFile(pluginPath, result -> {
            if (result.succeeded()) 
            {
            	JsonObject jo = new JsonObject(result.result().toString());
            	LOGGER.debug("plugin content: " + jo.encodePrettily());
            	try
            	{
            		PublisherVerticle.sendJOtoPluginQueue(jo);
            		ram.setPluginConfig(jo);
            		LOGGER.debug("Successfully published plugin details");
            	}
            	catch(Exception e)
            	{
            		LOGGER.error("Unable to publish plugin details: " + e.getLocalizedMessage());
            	}
            } 
            else 
            {
            	LOGGER.debug("Failed to read plugin content: " + result.cause());
            }
        });
	}
}