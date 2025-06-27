package push.ctf.thejasonengine.com;


import io.vertx.core.Handler;
import io.vertx.core.eventbus.MessageConsumer;
import io.vertx.ext.web.RoutingContext;

import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.BiConsumer;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class SSEHandler implements Handler<RoutingContext> {
    private static final Logger LOGGER = LogManager.getLogger(SSEHandler.class);
    
    @Override
    public void handle(RoutingContext ctx) {
        final long[] timerHolder = {-1};
        final MessageConsumer<?>[] consumerHolder = {null};
        final AtomicBoolean isClosed = new AtomicBoolean(false);
        
        // Safe write function
        BiConsumer<String, Boolean> safeWrite = (data, isCritical) -> {
        	if (ctx.response().ended() || ctx.response().closed() || isClosed.get()) {
        	    return;
        	}

            if (isClosed.get() || ctx.response().closed()) {
                LOGGER.debug("Write skipped (connection closed)");
                return;
            }
            
            try {
                ctx.response().write(data);
            } catch (IllegalStateException e) {
                LOGGER.warn("Write failed: {}", e.getMessage());
                isClosed.set(true);
                if (isCritical) {
                    cleanupResources(ctx.vertx(), timerHolder[0], consumerHolder[0]);
                }
                
            }
        };
        
        try {
            // Set SSE headers
            ctx.response()
                .putHeader("Content-Type", "text/event-stream")
                .putHeader("Cache-Control", "no-cache")
                .putHeader("Connection", "keep-alive")
                .setChunked(true);
            
            // Send initial connection message
            safeWrite.accept("event: connect\ndata: Connected to CTF notifications\n\n", true);
            
            // Register for broadcast messages
            consumerHolder[0] = ctx.vertx().eventBus().consumer("sse.broadcast", msg -> {
                safeWrite.accept("event: message\ndata: " + msg.body() + "\n\n", false);
            });
            
            // Send periodic keep-alive messages
            timerHolder[0] = ctx.vertx().setPeriodic(15000, id -> {
                safeWrite.accept(":keep-alive\n\n", false);
            });
            
            // Cleanup on disconnect
            ctx.response().closeHandler(v -> {
                LOGGER.info("SSE connection closed: {}", ctx.request().remoteAddress());
                isClosed.set(true);
                cleanupResources(ctx.vertx(), timerHolder[0], consumerHolder[0]);
            });
            
            // Cleanup on end
            ctx.response().endHandler(v -> {
                isClosed.set(true);
                cleanupResources(ctx.vertx(), timerHolder[0], consumerHolder[0]);
            });
            
        } catch (Exception e) {
            LOGGER.error("SSE handler initialization failed: {}", e.getMessage());
            cleanupResources(ctx.vertx(), timerHolder[0], consumerHolder[0]);
            if (!ctx.response().ended() && !ctx.response().headWritten()) {
                ctx.response().setStatusCode(500).end("Error initializing SSE connection");
            } else {
                ctx.response().end(); // Fallback: just close stream if already in progress
            }

        }
    }
    
    private void cleanupResources(io.vertx.core.Vertx vertx, long timerId, MessageConsumer<?> consumer) {
        if (timerId > 0) {
            vertx.cancelTimer(timerId);
        }
        if (consumer != null) {
            consumer.unregister();
        }
    }
}