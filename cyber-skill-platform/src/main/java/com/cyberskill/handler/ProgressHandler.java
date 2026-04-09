package com.cyberskill.handler;

import com.cyberskill.model.UserProgress;
import com.cyberskill.service.ProgressService;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.UUID;

/**
 * Handler for Progress Tracking HTTP requests
 */
public class ProgressHandler {
    private static final Logger logger = LoggerFactory.getLogger(ProgressHandler.class);
    private final ProgressService progressService;

    public ProgressHandler(ProgressService progressService) {
        this.progressService = progressService;
    }

    /**
     * POST /api/progress/lessons/:lessonId/start - Start a lesson
     */
    public void startLesson(RoutingContext ctx) {
        try {
            UUID lessonId = UUID.fromString(ctx.pathParam("lessonId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.startLesson(userId, lessonId)
                    .onSuccess(progress -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(progressToJson(progress).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error starting lesson", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to start lesson")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid lesson ID")
                    .encode());
        }
    }

    /**
     * POST /api/progress/lessons/:lessonId/complete - Mark lesson as completed
     */
    public void completeLesson(RoutingContext ctx) {
        try {
            UUID lessonId = UUID.fromString(ctx.pathParam("lessonId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.completeLesson(userId, lessonId)
                    .onSuccess(progress -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(progressToJson(progress).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error completing lesson", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to complete lesson")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid lesson ID")
                    .encode());
        }
    }

    /**
     * POST /api/progress/lessons/:lessonId/time - Update time spent on lesson
     */
    public void updateTimeSpent(RoutingContext ctx) {
        try {
            UUID lessonId = UUID.fromString(ctx.pathParam("lessonId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));
            JsonObject body = ctx.body().asJsonObject();
            
            Integer seconds = body.getInteger("seconds");
            if (seconds == null || seconds < 0) {
                ctx.response().setStatusCode(400).end(new JsonObject()
                        .put("error", "Invalid seconds value")
                        .encode());
                return;
            }

            progressService.updateTimeSpent(userId, lessonId, seconds)
                    .onSuccess(progress -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(progressToJson(progress).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating time spent", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to update time spent")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid request data")
                    .encode());
        }
    }

    /**
     * GET /api/progress/lessons/:lessonId - Get progress for a specific lesson
     */
    public void getLessonProgress(RoutingContext ctx) {
        try {
            UUID lessonId = UUID.fromString(ctx.pathParam("lessonId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getLessonProgress(userId, lessonId)
                    .onSuccess(progressOpt -> {
                        if (progressOpt.isPresent()) {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(progressToJson(progressOpt.get()).encode());
                        } else {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(new JsonObject()
                                            .put("completed", false)
                                            .put("timeSpentSeconds", 0)
                                            .encode());
                        }
                    })
                    .onFailure(err -> {
                        logger.error("Error getting lesson progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get lesson progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid lesson ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress - Get all user progress
     */
    public void getUserProgress(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getUserProgress(userId)
                    .onSuccess(progressList -> {
                        JsonArray jsonArray = new JsonArray();
                        progressList.forEach(progress -> jsonArray.add(progressToJson(progress)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(jsonArray.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting user progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get user progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress/completed - Get completed lessons
     */
    public void getCompletedLessons(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getCompletedLessons(userId)
                    .onSuccess(progressList -> {
                        JsonArray jsonArray = new JsonArray();
                        progressList.forEach(progress -> jsonArray.add(progressToJson(progress)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(jsonArray.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting completed lessons", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get completed lessons")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress/sections/:sectionId - Get section progress summary
     */
    public void getSectionProgress(RoutingContext ctx) {
        try {
            UUID sectionId = UUID.fromString(ctx.pathParam("sectionId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getSectionProgress(userId, sectionId)
                    .onSuccess(summary -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(summary.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting section progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get section progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid section ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress/modules/:moduleId - Get module progress summary
     */
    public void getModuleProgress(RoutingContext ctx) {
        try {
            UUID moduleId = UUID.fromString(ctx.pathParam("moduleId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getModuleProgress(userId, moduleId)
                    .onSuccess(summary -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(summary.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting module progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get module progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid module ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress/paths/:pathId - Get learning path progress summary
     */
    public void getPathProgress(RoutingContext ctx) {
        try {
            UUID pathId = UUID.fromString(ctx.pathParam("pathId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getPathProgress(userId, pathId)
                    .onSuccess(summary -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(summary.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting path progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get path progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid path ID")
                    .encode());
        }
    }

    /**
     * GET /api/progress/statistics - Get overall user statistics
     */
    public void getUserStatistics(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.getUserStatistics(userId)
                    .onSuccess(statistics -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(statistics.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting user statistics", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get user statistics")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * DELETE /api/progress/lessons/:lessonId - Reset lesson progress
     */
    public void resetLessonProgress(RoutingContext ctx) {
        try {
            UUID lessonId = UUID.fromString(ctx.pathParam("lessonId"));
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            progressService.resetLessonProgress(userId, lessonId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error resetting lesson progress", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to reset lesson progress")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid lesson ID")
                    .encode());
        }
    }

    /**
     * Convert UserProgress to JSON
     */
    private JsonObject progressToJson(UserProgress progress) {
        JsonObject json = new JsonObject()
                .put("id", progress.getId().toString())
                .put("userId", progress.getUserId().toString())
                .put("lessonId", progress.getLessonId().toString())
                .put("completed", progress.getCompleted())
                .put("timeSpentSeconds", progress.getTimeSpentSeconds())
                .put("startedAt", progress.getStartedAt().toString())
                .put("lastAccessedAt", progress.getLastAccessedAt().toString());

        if (progress.getCompletedAt() != null) {
            json.put("completedAt", progress.getCompletedAt().toString());
        }

        return json;
    }
}

// Made with Bob
