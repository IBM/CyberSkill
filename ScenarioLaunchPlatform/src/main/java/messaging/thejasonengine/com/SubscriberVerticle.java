/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package messaging.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.eventbus.EventBus;

public class SubscriberVerticle extends AbstractVerticle 
{	private static final Logger LOGGER = LogManager.getLogger(SubscriberVerticle.class);
	
    @Override
    public void start() {
        EventBus eventBus = vertx.eventBus();
        
        // Listening to the queue address for incoming messages
        eventBus.consumer("general.queue", message -> {
            LOGGER.debug("Received message general.queue: " + message.body());
            // Here you can process the message, e.g., adding to a queue, etc.
        });
        
        // Listening to the queue address for incoming messages
        eventBus.consumer("special.queue", message -> {
            LOGGER.debug("Received message special.queue: " + message.body());
            // Here you can process the message, e.g., adding to a queue, etc.
        });
        
     // Listening to the queue address for incoming messages
        eventBus.consumer("query.queue", message -> {
            LOGGER.debug("Received message query.queue: " + message.body());
            // Here you can process the message, e.g., adding to a queue, etc.
        });
    }
}