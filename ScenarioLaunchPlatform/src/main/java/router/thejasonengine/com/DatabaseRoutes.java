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

import database.thejasonengine.com.AgentDatabaseController;
import io.vertx.core.Vertx;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;

/**
 * Handles all database-related routes
 */
public class DatabaseRoutes {
    
    private static final Logger LOGGER = LogManager.getLogger(DatabaseRoutes.class);
    private final Vertx vertx;
    private final SetupPostHandlers setupPostHandlers;
    private final AgentDatabaseController agentDatabaseController;
    
    public DatabaseRoutes(Vertx vertx, SetupPostHandlers setupPostHandlers, AgentDatabaseController agentDatabaseController) {
        this.vertx = vertx;
        this.setupPostHandlers = setupPostHandlers;
        this.agentDatabaseController = agentDatabaseController;
    }
    
    /**
     * Register all database-related routes
     */
    public void registerRoutes(Router router) {
        LOGGER.info("Registering database routes");
        
        // Database query management
        router.post("/api/addDatabaseQuery").handler(BodyHandler.create()).handler(setupPostHandlers.addDatabaseQuery);
        router.post("/api/getDatabaseQueryByDbType").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQueryByDbType);
        router.post("/api/getDatabaseQuery").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQuery);
        router.post("/api/getDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseQueryByQueryId);
        router.post("/api/deleteDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.deleteDatabaseQueryByQueryId);
        router.post("/api/updateDatabaseQueryByQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.updateDatabaseQueryByQueryId);
        
        // Database connection management
        router.post("/api/getDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseConnections);
        router.post("/api/getAllDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getAllDatabaseConnections);
        router.post("/api/getRefreshedDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getRefreshedDatabaseConnections);
        router.post("/api/getDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseConnectionsById);
        router.post("/api/deleteDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.deleteDatabaseConnectionsById);
        router.post("/api/updateDatabaseConnectionsById").handler(BodyHandler.create()).handler(setupPostHandlers.updateDatabaseConnectionById);
        router.post("/api/setDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.setDatabaseConnections);
        router.post("/api/getValidatedDatabaseConnections").handler(BodyHandler.create()).handler(setupPostHandlers.getValidatedDatabaseConnections);
        router.post("/api/toggleDatabaseConnectionStatusByDbConnectionID").handler(BodyHandler.create()).handler(setupPostHandlers.toggleDatabaseConnectionStatusByID);
        router.post("/api/toggleDatabaseConnectionStatusByID").handler(BodyHandler.create()).handler(setupPostHandlers.toggleDatabaseConnectionStatusByID);
        
        // Query type management
        router.post("/api/getQueryTypes").handler(BodyHandler.create()).handler(setupPostHandlers.getQueryTypes);
        router.post("/api/addQueryTypes").handler(BodyHandler.create()).handler(setupPostHandlers.addQueryTypes);
        router.post("/api/deleteQueryTypesByID").handler(BodyHandler.create()).handler(setupPostHandlers.deleteQueryTypesByID);
        
        // Database query execution
        router.post("/api/runDatabaseQueryByDatasourceMap").handler(BodyHandler.create()).handler(setupPostHandlers.runDatabaseQueryByDatasourceMap);
        router.post("/api/runDatabaseQueryByDatasourceMapAndQueryId").handler(BodyHandler.create()).handler(setupPostHandlers.runDatabaseQueryByDatasourceMapAndQueryId);
        router.post("/api/sendDatabaseSelect").handler(BodyHandler.create()).handler(agentDatabaseController.agentDatabase);
        
        // Database version
        router.get("/api/getDatabaseVersion").handler(BodyHandler.create()).handler(setupPostHandlers.getDatabaseVersion);
        
        // Test endpoints
        router.get("/api/simpleTest").handler(setupPostHandlers.simpleTest);
        router.get("/api/simpleDBTest").handler(setupPostHandlers.simpleDBTest);
        
        LOGGER.info("Database routes registered successfully");
    }
}

