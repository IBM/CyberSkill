package com.cyberskill.handler;

import com.cyberskill.service.LearningService;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for learning content endpoints
 */
public class LearningHandler {
    private static final Logger logger = LoggerFactory.getLogger(LearningHandler.class);
    private final LearningService learningService;

    public LearningHandler(LearningService learningService) {
        this.learningService = learningService;
    }

    /**
     * Get all active learning paths
     * GET /api/paths
     */
    public Handler<RoutingContext> getAllPaths() {
        return ctx -> {
            learningService.getAllActivePaths()
                .onSuccess(paths -> {
                    ctx.response()
                        .setStatusCode(200)
                        .putHeader("Content-Type", "application/json")
                        .end(paths.encode());
                })
                .onFailure(err -> {
                    logger.error("Error retrieving learning paths", err);
                    sendError(ctx, 500, "Error retrieving learning paths");
                });
        };
    }

    /**
     * Get learning path by ID
     * GET /api/paths/:id
     */
    public Handler<RoutingContext> getPathById() {
        return ctx -> {
            try {
                Integer pathId = Integer.parseInt(ctx.pathParam("id"));
                
                learningService.getPathById(pathId)
                    .onSuccess(path -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(path.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving learning path: {}", pathId, err);
                        sendError(ctx, 404, "Learning path not found");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid path ID");
            }
        };
    }

    /**
     * Get learning path by slug
     * GET /api/paths/slug/:slug
     */
    public Handler<RoutingContext> getPathBySlug() {
        return ctx -> {
            String slug = ctx.pathParam("slug");
            
            learningService.getPathBySlug(slug)
                .onSuccess(path -> {
                    ctx.response()
                        .setStatusCode(200)
                        .putHeader("Content-Type", "application/json")
                        .end(path.encode());
                })
                .onFailure(err -> {
                    logger.error("Error retrieving learning path by slug: {}", slug, err);
                    sendError(ctx, 404, "Learning path not found");
                });
        };
    }

    /**
     * Create new learning path (admin only)
     * POST /api/admin/paths
     */
    public Handler<RoutingContext> createPath() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                
                // Validate required fields
                if (body.getString("name") == null || body.getString("slug") == null) {
                    sendError(ctx, 400, "Name and slug are required");
                    return;
                }
                
                learningService.createPath(body)
                    .onSuccess(path -> {
                        ctx.response()
                            .setStatusCode(201)
                            .putHeader("Content-Type", "application/json")
                            .end(path.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating learning path", err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing create path request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Update learning path (admin only)
     * PUT /api/admin/paths/:id
     */
    public Handler<RoutingContext> updatePath() {
        return ctx -> {
            try {
                Integer pathId = Integer.parseInt(ctx.pathParam("id"));
                JsonObject body = ctx.body().asJsonObject();
                
                learningService.updatePath(pathId, body)
                    .onSuccess(path -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(path.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating learning path: {}", pathId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid path ID");
            } catch (Exception e) {
                logger.error("Error processing update path request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Delete learning path (admin only)
     * DELETE /api/admin/paths/:id
     */
    public Handler<RoutingContext> deletePath() {
        return ctx -> {
            try {
                Integer pathId = Integer.parseInt(ctx.pathParam("id"));
                
                learningService.deletePath(pathId)
                    .onSuccess(v -> {
                        ctx.response()
                            .setStatusCode(204)
                            .end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting learning path: {}", pathId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid path ID");
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
