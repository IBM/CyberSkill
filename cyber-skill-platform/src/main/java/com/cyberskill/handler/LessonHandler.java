package com.cyberskill.handler;

import com.cyberskill.service.LessonService;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for lesson endpoints
 */
public class LessonHandler {
    private static final Logger logger = LoggerFactory.getLogger(LessonHandler.class);
    private final LessonService lessonService;

    public LessonHandler(LessonService lessonService) {
        this.lessonService = lessonService;
    }

    /**
     * Get all lessons for a section
     * GET /api/sections/:sectionId/lessons
     */
    public Handler<RoutingContext> getLessonsBySectionId() {
        return ctx -> {
            try {
                Integer sectionId = Integer.parseInt(ctx.pathParam("sectionId"));
                
                lessonService.getLessonsBySectionId(sectionId)
                    .onSuccess(lessons -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(lessons.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving lessons for section: {}", sectionId, err);
                        sendError(ctx, 500, "Error retrieving lessons");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid section ID");
            }
        };
    }

    /**
     * Get lesson by ID
     * GET /api/lessons/:id
     */
    public Handler<RoutingContext> getLessonById() {
        return ctx -> {
            try {
                Integer lessonId = Integer.parseInt(ctx.pathParam("id"));
                
                lessonService.getLessonById(lessonId)
                    .onSuccess(lesson -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(lesson.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error retrieving lesson: {}", lessonId, err);
                        sendError(ctx, 404, "Lesson not found");
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid lesson ID");
            }
        };
    }

    /**
     * Get all lessons (admin)
     * GET /api/admin/lessons
     */
    public Handler<RoutingContext> getAllLessons() {
        return ctx -> {
            lessonService.getAllLessons()
                .onSuccess(lessons -> {
                    ctx.response()
                        .setStatusCode(200)
                        .putHeader("Content-Type", "application/json")
                        .end(lessons.encode());
                })
                .onFailure(err -> {
                    logger.error("Error retrieving all lessons", err);
                    sendError(ctx, 500, "Error retrieving lessons");
                });
        };
    }

    /**
     * Create new lesson (admin)
     * POST /api/admin/lessons
     */
    public Handler<RoutingContext> createLesson() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                
                // Validate required fields
                if (body.getInteger("sectionId") == null || body.getString("name") == null) {
                    sendError(ctx, 400, "Section ID and name are required");
                    return;
                }
                
                lessonService.createLesson(body)
                    .onSuccess(lesson -> {
                        ctx.response()
                            .setStatusCode(201)
                            .putHeader("Content-Type", "application/json")
                            .end(lesson.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating lesson", err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing create lesson request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Update lesson (admin)
     * PUT /api/admin/lessons/:id
     */
    public Handler<RoutingContext> updateLesson() {
        return ctx -> {
            try {
                Integer lessonId = Integer.parseInt(ctx.pathParam("id"));
                JsonObject body = ctx.body().asJsonObject();
                
                lessonService.updateLesson(lessonId, body)
                    .onSuccess(lesson -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(lesson.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating lesson: {}", lessonId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid lesson ID");
            } catch (Exception e) {
                logger.error("Error processing update lesson request", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Delete lesson (admin)
     * DELETE /api/admin/lessons/:id
     */
    public Handler<RoutingContext> deleteLesson() {
        return ctx -> {
            try {
                Integer lessonId = Integer.parseInt(ctx.pathParam("id"));
                
                lessonService.deleteLesson(lessonId)
                    .onSuccess(v -> {
                        ctx.response()
                            .setStatusCode(204)
                            .end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting lesson: {}", lessonId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (NumberFormatException e) {
                sendError(ctx, 400, "Invalid lesson ID");
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