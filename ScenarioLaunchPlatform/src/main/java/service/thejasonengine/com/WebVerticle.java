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

import com.hazelcast.config.Config;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.VertxOptions;

import io.vertx.core.eventbus.EventBus;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.ServerWebSocket;
import io.vertx.core.json.JsonObject;
import io.vertx.core.spi.cluster.ClusterManager;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import cluster.thejasonengine.com.*;
import file.thejasonengine.com.Read;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.micrometer.MicrometerMetricsOptions;
import io.vertx.micrometer.backends.BackendRegistries;
import io.vertx.spi.cluster.hazelcast.HazelcastClusterManager;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import manager.thejasonengine.com.Admin;
import messaging.thejasonengine.com.PublisherVerticle;
import messaging.thejasonengine.com.SubscriberVerticle;
import cluster.thejasonengine.com.ClusteredVerticle;


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
		
		
		Config hazelcastConfig = new Config();
		
		/*
		hazelcastConfig.getNetworkConfig().getJoin().getMulticastConfig().setEnabled(false);  // Disable multicast for cluster discovery
		hazelcastConfig.getNetworkConfig().getJoin().getTcpIpConfig()
		    .addMember("192.168.1.2")  // Replace with the IP address of another node in the cluster
		    .setEnabled(true);
		 */
		ClusterManager clusterManager = new HazelcastClusterManager(hazelcastConfig);
		
		
		//ClusterSetup.createHazelcastCluster(vertx);
    	//HazelcastClusterManager clusterManager = new HazelcastClusterManager();
    	
    	VertxOptions options = new VertxOptions().setClusterManager(clusterManager)
			.setMetricsOptions(new MicrometerMetricsOptions()
            .setEnabled(true)  // Enable metrics
            .setMicrometerRegistry(BackendRegistries.getDefaultNow())); // Use default registry
		 // Create the clustered Vert.x instance
        
		Vertx.clusteredVertx(options, res -> 
        {
            if (res.succeeded()) 
            {
            	LOGGER.debug("Clustered Vert.x instance created!");

                // You can deploy verticles here, like PublisherVerticle and SubscriberVerticle
                //vertx = res.result();
            	
            	 Vertx vertx = res.result();
                 vertx.deployVerticle(new ClusteredVerticle());
            	 vertx.deployVerticle(new PublisherVerticle());
            	 vertx.deployVerticle(new SubscriberVerticle());
        
            	
            } 
            
            else 
            {
                LOGGER.error("Failed to create clustered Vert.x instance: " + res.cause());
            }
        });
    }
    
}