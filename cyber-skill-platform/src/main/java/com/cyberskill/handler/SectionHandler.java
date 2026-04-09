package com.cyberskill.handler;

import com.cyberskill.service.SectionService;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for section endpoints
 */
public class SectionHandler {
    private static final Logger logger = LoggerFactory.getLogger(SectionHandler.class);
    private final SectionService sectionService;

    public SectionHandler(SectionService sectionService) {
        this.sectionService = sectionService;
    }

    /**
     * Get all sections for a module
     * GET /api/modules/:moduleId/sections
     */
    public Handler<RoutingContext> getSectionsByModuleId() {
        return ctx -> {
            try {
                Integer moduleId = Integer.parseInt(ctx.pathParam("moduleId"));
                
                sectionService.getSectionsByModuleId(moduleId)
                    .onSuccess(sections -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(sections.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving sections for module: {}", moduleId, err);
                        sendError(ctx, 500, "Error retrieving sections");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid module ID");
            }
        };
    }

    /**
     * Get section by ID
     * GET /api/sections/:id
     */
    public Handler<RoutingContext> getSectionById() {
        return ctx -> {
            try {
                Integer sectionId = Integer.parseInt(ctx.pathParam("id"));
                
                sectionService.getSectionById(sectionId)
                    .onSuccess(section -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(section.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving section: {}", sectionId, err);
                        sendError(ctx, 404, "Section not found");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid section ID");
            }
        };
    }

    /**
     * Get all sections (admin)
     * GET /api/admin/sections
     */
    public Handler<RoutingContext> getAllSections() {
        return ctx -> {
            sectionService.getAllSections()
                .onSuccess(sections -> {
                    ctx.response()
                        .setStatusCode(200)
                        .putHeader("Content-Type", "application/json")
                        .end(sections.encode());
                })
                .onFailure(err -> {
                    logger.error("Error retrieving all sections", err);
                    sendError(ctx, 500, "Error retrieving sections");
                });
        };
    }

    /**
     * Create new section (admin)
     * POST /api/admin/sections
     */
    public Handler<RoutingContext> createSection() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                
                // Validate required fields
                if (body.getInteger("moduleId") == null || body.getString("name") == null) {
                    sendError(ctx, 400, "Module ID and name are required");
                    return;
                }
                
                sectionService.createSection(body)
                    .onSuccess(section -> {
                        ctx.response()
                            .setStatusCode(201)
                            .putHeader("Content-Type", "application/json")
                            .end(section.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating section", err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing create section request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Update section (admin)
     * PUT /api/admin/sections/:id
     */
    public Handler<RoutingContext> updateSection() {
        return ctx -> {
            try {
                Integer sectionId = Integer.parseInt(ctx.pathParam("id"));
                JsonObject body = ctx.body().asJsonObject();
                
                sectionService.updateSection(sectionId, body)
                    .onSuccess(section -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(section.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating section: {}", sectionId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid section ID");
            } catch (Exception e) {
                logger.error("Error processing update section request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Delete section (admin)
     * DELETE /api/admin/sections/:id
     */
    public Handler<RoutingContext> deleteSection() {
        return ctx -> {
            try {
                Integer sectionId = Integer.parseInt(ctx.pathParam("id"));
                
                sectionService.deleteSection(sectionId)
                    .onSuccess(v -> {
                        ctx.response()
                            .setStatusCode(204)
                            .end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting section: {}", sectionId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid section ID");
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