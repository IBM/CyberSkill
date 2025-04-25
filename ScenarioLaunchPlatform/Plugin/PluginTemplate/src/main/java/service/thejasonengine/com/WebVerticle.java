/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package service.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.VertxOptions;
import io.vertx.micrometer.MicrometerMetricsOptions;
import io.vertx.micrometer.backends.BackendRegistries;
import io.vertx.spi.cluster.hazelcast.HazelcastClusterManager;
import messaging.thejasonengine.com.PublisherVerticle;
import messaging.thejasonengine.com.SubscriberVerticle;

import cluster.thejasonengine.com.Plugin;


public class WebVerticle extends AbstractVerticle {
	
	private static final Logger LOGGER = LogManager.getLogger(WebVerticle.class);
	
    /*****************************************************************************/
    @Override
    public void start() 
    {
    	
    	LOGGER.info("This is an WebVerticle 'INFO' TEST MESSAGE");
		LOGGER.debug("This is a WebVerticle 'DEBUG' TEST MESSAGE");
		LOGGER.warn("This is a WebVerticle 'WARN' TEST MESSAGE");
		LOGGER.error("This is an WebVerticle 'ERROR' TEST MESSAGE");
		
    	HazelcastClusterManager clusterManager = new HazelcastClusterManager();
		VertxOptions options = new VertxOptions().setClusterManager(clusterManager)
			.setMetricsOptions(new MicrometerMetricsOptions()
            .setEnabled(true)  // Enable metrics
            .setMicrometerRegistry(BackendRegistries.getDefaultNow())); // Use default registry
		
		Vertx.clusteredVertx(options, res -> 
        {
            if (res.succeeded()) 
            {
            	LOGGER.debug("Clustered Vert.x instance created!");
            	Vertx vertx = res.result();

            	vertx.deployVerticle(new Plugin()); //Deploy Plugin.
            	vertx.deployVerticle(new PublisherVerticle()); //Deploy publishing service.
            	vertx.deployVerticle(new SubscriberVerticle()); //Deploy subscribing service.
            } 
            
            else 
            {
                LOGGER.error("Failed to create clustered Vert.x instance: " + res.cause());
            }
        });
    }
    
}