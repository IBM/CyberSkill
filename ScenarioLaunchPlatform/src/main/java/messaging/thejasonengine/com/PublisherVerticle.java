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

import io.micrometer.core.instrument.Counter;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.eventbus.EventBus;
import io.vertx.core.json.JsonObject;

public class PublisherVerticle extends AbstractVerticle {
    
	private static final Logger LOGGER = LogManager.getLogger(PublisherVerticle.class);
	@Override
    public void start() {
        EventBus eventBus = vertx.eventBus();
        
        PrometheusMeterRegistry prometheusRegistry = new PrometheusMeterRegistry(io.micrometer.prometheus.PrometheusConfig.DEFAULT);
        Counter general_queue_counter = prometheusRegistry.counter("general.queue", "type", "counter");
        general_queue_counter.increment();
        
        
        JsonObject generalMessage = new JsonObject().put("message", "Hello from Publisher to general.queue");
        eventBus.send("general.queue", generalMessage);
        LOGGER.debug("Message sent to general.queue: " + generalMessage);
        
        JsonObject specialMessage = new JsonObject().put("message", "Hello from Publisher to special.queue");
        eventBus.send("special.queue", specialMessage);
        LOGGER.debug("Message sent to special.queue: " + specialMessage);
        
        Counter special_queue_counter = prometheusRegistry.counter("special.queue", "type", "counter");
        special_queue_counter.increment();
        
        JsonObject queryMessage = new JsonObject().put("message", "Hello from Publisher to general.queue");
        eventBus.send("query.queue", queryMessage);
        LOGGER.debug("Message sent to query.queue: " + queryMessage);
        
        Counter query_queue_counter = prometheusRegistry.counter("query.queue", "type", "counter");
        query_queue_counter.increment();
        
        // Simulating a producer that sends messages to a queue
        /*vertx.setPeriodic(1000, id -> {
            JsonObject message = new JsonObject().put("message", "Hello from Publisher");
            eventBus.send("queue.address", message);
            System.out.println("Message sent to queue: " + message);
        });*/
    }
}