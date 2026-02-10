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
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;

/**
 * Handles all admin and system management routes
 */
public class AdminRoutes {
    
    private static final Logger LOGGER = LogManager.getLogger(AdminRoutes.class);
    private final Vertx vertx;
    private final SetupPostHandlers setupPostHandlers;
    private final ContentPackHandler contentPackHandler;
    private final UpgradeHandler upgradeHandler;
    
    public AdminRoutes(Vertx vertx, SetupPostHandlers setupPostHandlers, 
                      ContentPackHandler contentPackHandler, UpgradeHandler upgradeHandler) {
        this.vertx = vertx;
        this.setupPostHandlers = setupPostHandlers;
        this.contentPackHandler = contentPackHandler;
        this.upgradeHandler = upgradeHandler;
    }
    
    /**
     * Register all admin routes
     */
    public void registerRoutes(Router router) {
        LOGGER.info("Registering admin routes");
        
        // Content pack management
        router.post("/api/addContentPack").handler(BodyHandler.create()).handler(setupPostHandlers.addPack);
        router.post("/api/getContentPacks").handler(BodyHandler.create()).handler(setupPostHandlers.getPacks);
        router.post("/api/getPackByPackId").handler(BodyHandler.create()).handler(setupPostHandlers.getPackByPackId);
        router.post("/api/deletePacksByPackId").handler(BodyHandler.create()).handler(setupPostHandlers.deletePackByPackId);
        router.post("/api/installContentPack").handler(BodyHandler.create()).handler(contentPackHandler.installContentPack);
        router.post("/api/uninstallContentPack").handler(BodyHandler.create()).handler(contentPackHandler.uninstallContentPack);
        
        // Admin functions
        router.post("/api/createAdminFunction").handler(BodyHandler.create()).handler(setupPostHandlers.createAdminFunctions);
        router.post("/api/getAdminFunctions").handler(BodyHandler.create()).handler(setupPostHandlers.getAdminFunctions);
        router.post("/api/runAdminFunctions").handler(BodyHandler.create()).handler(setupPostHandlers.runAdminFunctions);
        router.post("/api/toggleAdminFunctions").handler(BodyHandler.create()).handler(setupPostHandlers.toggleAdminFunctions);
        router.post("/api/toggleAdminFunctionsByID").handler(BodyHandler.create()).handler(setupPostHandlers.toggleAdminFunctionsByID);
        
        // System variables
        router.post("/api/getMySystemVariables").handler(BodyHandler.create()).handler(setupPostHandlers.getMySystemVariables);
        router.post("/api/setMySystemVariables").handler(BodyHandler.create()).handler(setupPostHandlers.setMySystemVariables);
        
        // Plugin management
        router.post("/api/getAvailablePlugins").handler(BodyHandler.create()).handler(setupPostHandlers.getAvailablePlugins);
        
        // Upgrade management
        router.post("/api/checkForUpgrade").handler(BodyHandler.create()).handler(upgradeHandler.checkForUpgrade);
        
        // Swagger documentation
        router.get("/getSwagger").handler(BodyHandler.create()).handler(setupPostHandlers.getSwagger);
        
        LOGGER.info("Admin routes registered successfully");
    }
}
