package com.cyberskill.handler;

import com.cyberskill.service.ModuleService;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for module endpoints
 */
public class ModuleHandler {
    private static final Logger logger = LoggerFactory.getLogger(ModuleHandler.class);
    private final ModuleService moduleService;

    public ModuleHandler(ModuleService moduleService) {
        this.moduleService = moduleService;
    }

    /**
     * Get all modules for a learning path
     * GET /api/paths/:pathId/modules
     */
    public Handler<RoutingContext> getModulesByPathId() {
        return ctx -> {
            try {
                Integer pathId = Integer.parseInt(ctx.pathParam("pathId"));
                
                moduleService.getModulesByPathId(pathId)
                    .onSuccess(modules -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(modules.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving modules for path: {}", pathId, err);
                        sendError(ctx, 500, "Error retrieving modules");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid path ID");
            }
        };
    }

    /**
     * Get module by ID
     * GET /api/modules/:id
     */
    public Handler<RoutingContext> getModuleById() {
        return ctx -> {
            try {
                Integer moduleId = Integer.parseInt(ctx.pathParam("id"));
                
                moduleService.getModuleById(moduleId)
                    .onSuccess(module -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(module.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving module: {}", moduleId, err);
                        sendError(ctx, 404, "Module not found");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid module ID");
            }
        };
    }

    /**
     * Get all modules (admin)
     * GET /api/admin/modules
     */
    public Handler<RoutingContext> getAllModules() {
        return ctx -> {
            moduleService.getAllModules()
                .onSuccess(modules -> {
                    ctx.response()
                        .setStatusCode(200)
                        .putHeader("Content-Type", "application/json")
                        .end(modules.encode());
                })
                .onFailure(err -> {
                    logger.error("Error retrieving all modules", err);
                    sendError(ctx, 500, "Error retrieving modules");
                });
        };
    }

    /**
     * Create new module (admin)
     * POST /api/admin/modules
     */
    public Handler<RoutingContext> createModule() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                
                // Validate required fields
                if (body.getInteger("learningPathId") == null || body.getString("name") == null) {
                    sendError(ctx, 400, "Learning path ID and name are required");
                    return;
                }
                
                moduleService.createModule(body)
                    .onSuccess(module -> {
                        ctx.response()
                            .setStatusCode(201)
                            .putHeader("Content-Type", "application/json")
                            .end(module.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating module", err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing create module request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Update module (admin)
     * PUT /api/admin/modules/:id
     */
    public Handler<RoutingContext> updateModule() {
        return ctx -> {
            try {
                Integer moduleId = Integer.parseInt(ctx.pathParam("id"));
                JsonObject body = ctx.body().asJsonObject();
                
                moduleService.updateModule(moduleId, body)
                    .onSuccess(module -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(module.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating module: {}", moduleId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid module ID");
            } catch (Exception e) {
                logger.error("Error processing update module request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Delete module (admin)
     * DELETE /api/admin/modules/:id
     */
    public Handler<RoutingContext> deleteModule() {
        return ctx -> {
            try {
                Integer moduleId = Integer.parseInt(ctx.pathParam("id"));
                
                moduleService.deleteModule(moduleId)
                    .onSuccess(v -> {
                        ctx.response()
                            .setStatusCode(204)
                            .end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting module: {}", moduleId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid module ID");
            }
        };
    }

    /**
     * Send error response
     */
    private void sendError(RoutingContext ctx, int statusCode, String message) {
        ctx.response()
            .setStatusCode(statusCode)
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("error", message)
                .encode());
    }
}

// Made with Bob