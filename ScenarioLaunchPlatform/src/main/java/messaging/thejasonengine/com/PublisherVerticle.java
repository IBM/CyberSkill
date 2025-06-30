/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package messaging.thejasonengine.com;

import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.micrometer.core.instrument.Counter;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.eventbus.EventBus;
import io.vertx.core.json.JsonObject;

public class PublisherVerticle extends AbstractVerticle {
    
	private final Set<String> processedMessages = ConcurrentHashMap.newKeySet();
	 private static final Logger LOGGER = LogManager.getLogger(PublisherVerticle.class);
	    private Counter notificationCounter;
	    
	    @Override
	    public void start() {
	        EventBus eventBus = vertx.eventBus();
	        PrometheusMeterRegistry prometheusRegistry = new PrometheusMeterRegistry(io.micrometer.prometheus.PrometheusConfig.DEFAULT);
	        
	        // Create counter for notifications
	        notificationCounter = prometheusRegistry.counter("push.notifications", "type", "counter");
	        
	        JsonObject ctfMessage = new JsonObject().put("message", "Hello from Publisher to send.notification");
	        eventBus.consumer("send.notification", message -> {
	            try {
	                JsonObject notification = (JsonObject) message.body();
	                String messageId = notification.getString("id");
	                
	                // Deduplication check
	                if (messageId != null && processedMessages.contains(messageId)) {
	                    LOGGER.debug("Duplicate message ignored: {}", messageId);
	                    message.reply("DUPLICATE");
	                    return;
	                }
	                
	                LOGGER.info("Received notification request: {}", notification.encodePrettily());
	                
	                // Add timestamp and ID
	                String id = UUID.randomUUID().toString();
	                notification.put("id", id)
	                    .put("timestamp", System.currentTimeMillis());
	                
	                // Add to processed set
	                processedMessages.add(id);
	                
	                // Broadcast to all connected clients
	                eventBus.publish("sse.broadcast", notification.encode());
	                
	                // Increment counter
	                notificationCounter.increment();
	                
	                LOGGER.debug("Notification broadcasted to clients");
	                
	                // Reply to sender
	                message.reply("OK");
	            } catch (Exception e) {
	                LOGGER.error("Error processing notification: {}", e.getMessage());
	                message.fail(500, "Internal server error");
	            }
	        });
	        
	        // Cleanup processed IDs periodically
	        vertx.setPeriodic(60000, id -> {
	            int size = processedMessages.size();
	            processedMessages.clear();
	            LOGGER.debug("Cleared {} processed message IDs", size);
	        });
	        // Initialize other queues (keep your existing code)
	        initializeOtherQueues(eventBus, prometheusRegistry);
	    }
	

	    
	        
	  
	   
        private void initializeOtherQueues(EventBus eventBus, PrometheusMeterRegistry registry) {
        Counter general_queue_counter = registry.counter("general.queue", "type", "counter");
        general_queue_counter.increment();
        
        
        JsonObject generalMessage = new JsonObject().put("message", "Hello from Publisher to general.queue");
        eventBus.send("general.queue", generalMessage);
        LOGGER.debug("Message sent to general.queue: " + generalMessage);
        
        JsonObject specialMessage = new JsonObject().put("message", "Hello from Publisher to special.queue");
        eventBus.send("special.queue", specialMessage);
        LOGGER.debug("Message sent to special.queue: " + specialMessage);
        
        Counter special_queue_counter = registry.counter("special.queue", "type", "counter");
        special_queue_counter.increment();
        
        JsonObject queryMessage = new JsonObject().put("message", "Hello from Publisher to general.queue");
        eventBus.send("query.queue", queryMessage);
        LOGGER.debug("Message sent to query.queue: " + queryMessage);
        
        Counter query_queue_counter = registry.counter("query.queue", "type", "counter");
        query_queue_counter.increment();
        
        
        JsonObject extensionService = new JsonObject()
        	      .put("name", "John Doe")
        	      .put("age", 30)
        	      .put("city", "New York");
        
        eventBus.send("extensionService.queue", extensionService);
        LOGGER.debug("Message sent to query.queue: " + extensionService.encodePrettily());
        
        Counter extensionService_counter = registry.counter("extensionService.queue", "type", "counter");
        extensionService_counter.increment();
        
        // Simulating a producer that sends messages to a queue
        /*vertx.setPeriodic(1000, id -> {
            JsonObject message = new JsonObject().put("message", "Hello from Publisher");
            eventBus.send("queue.address", message);
            LOGGER.debug("Message sent to queue: " + message);
        });*/
    }

	    
	   
	    
	  
	    
	   
	  
	
}