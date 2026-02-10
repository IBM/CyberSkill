/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Vertx;
import io.vertx.core.http.ServerWebSocket;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import messaging.thejasonengine.com.Websocket;

/**
 * Handles all story and scheduling-related routes
 */
public class StoryRoutes {
    
    private static final Logger LOGGER = LogManager.getLogger(StoryRoutes.class);
    private final Vertx vertx;
    private final SetupPostHandlers setupPostHandlers;
    
    public StoryRoutes(Vertx vertx, SetupPostHandlers setupPostHandlers) {
        this.vertx = vertx;
        this.setupPostHandlers = setupPostHandlers;
    }
    
    /**
     * Register all story and scheduling routes
     */
    public void registerRoutes(Router router) {
        LOGGER.info("Registering story routes");
        
        // Story management
        router.post("/api/addStory").handler(BodyHandler.create()).handler(setupPostHandlers.addStory);
        router.post("/api/getAllStories").handler(BodyHandler.create()).handler(setupPostHandlers.getAllStories);
        router.post("/api/runStoryById").handler(BodyHandler.create()).handler(setupPostHandlers.runStoryById);
        router.post("/api/deleteStoryById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteStoryById);
        
        // Schedule jobs
        router.post("/api/getScheduleJobs").handler(BodyHandler.create()).handler(setupPostHandlers.getScheduleJobs);
        router.post("/api/addScheduleJob").handler(BodyHandler.create()).handler(setupPostHandlers.addScheduleJob);
        router.post("/api/deleteScheduleJobById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteScheduleJobById);
        
        // OS tasks
        router.post("/api/addOSTask").handler(BodyHandler.create()).handler(setupPostHandlers.addOSTask);
        router.post("/api/getOSTasks").handler(BodyHandler.create()).handler(setupPostHandlers.getOSTasks);
        router.post("/api/getOSTaskByTaskId").handler(BodyHandler.create()).handler(setupPostHandlers.getOSTaskByTaskId);
        router.post("/api/deleteOSTasksByTaskId").handler(BodyHandler.create()).handler(setupPostHandlers.deleteOSTaskByTaskId);
        
        // WebSocket for story execution
        router.get("/websocket/story/:username").handler(ctx -> {
            ctx.request().toWebSocket(socket -> {
                if (socket.succeeded()) {
                    String username = ctx.pathParam("username");
                    LOGGER.debug("New WebSocket connection: " + socket.result().remoteAddress() + " username: " + username);
                    
                    ServerWebSocket webSocket = socket.result();
                    Websocket ws = new Websocket();
                    
                    ws.addNewSocket(webSocket, username);
                    
                    webSocket.handler(buffer -> {
                        String message = buffer.toString();
                        LOGGER.debug("Received message: " + message);
                        webSocket.writeTextMessage("Echo: " + message);
                    });
                    
                    webSocket.closeHandler(v -> {
                        LOGGER.debug("WebSocket closed");
                        ws.removeSocket(webSocket);
                    });
                    
                    webSocket.exceptionHandler(err -> {
                        LOGGER.debug("WebSocket error: " + err.getMessage());
                    });
                } else {
                    LOGGER.error("Failed to create WebSocket: " + socket.cause());
                }
            });
        });
        
        LOGGER.info("Story routes registered successfully");
    }
}

