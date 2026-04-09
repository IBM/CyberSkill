package com.cyberskill.handler;

import com.cyberskill.model.Badge;
import com.cyberskill.model.BadgeType;
import com.cyberskill.service.BadgeService;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Handler for Badge HTTP requests
 */
public class BadgeHandler {
    private static final Logger logger = LoggerFactory.getLogger(BadgeHandler.class);
    private final BadgeService badgeService;

    public BadgeHandler(BadgeService badgeService) {
        this.badgeService = badgeService;
    }

    // ==================== Public Badge Endpoints ====================

    /**
     * GET /api/badges - Get all badges
     */
    public void getAllBadges(RoutingContext ctx) {
        badgeService.getAllBadges()
                .onSuccess(badges -> {
                    JsonArray jsonArray = new JsonArray();
                    badges.forEach(badge -> jsonArray.add(badgeToJson(badge)));
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(jsonArray.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting all badges", err);
                    ctx.response().setStatusCode(500).end(new JsonObject()
                            .put("error", "Failed to get badges")
                            .encode());
                });
    }

    /**
     * GET /api/badges/:id - Get badge by ID
     */
    public void getBadgeById(RoutingContext ctx) {
        try {
            UUID badgeId = UUID.fromString(ctx.pathParam("id"));

            badgeService.getBadgeById(badgeId)
                    .onSuccess(badgeOpt -> {
                        if (badgeOpt.isPresent()) {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(badgeToJson(badgeOpt.get()).encode());
                        } else {
                            ctx.response().setStatusCode(404).end(new JsonObject()
                                    .put("error", "Badge not found")
                                    .encode());
                        }
                    })
                    .onFailure(err -> {
                        logger.error("Error getting badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get badge")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge ID")
                    .encode());
        }
    }

    // ==================== User Badge Endpoints ====================

    /**
     * GET /api/user/badges - Get user's earned badges
     */
    public void getUserBadges(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            badgeService.getUserBadgesWithDetails(userId)
                    .onSuccess(badges -> {
                        JsonArray jsonArray = new JsonArray();
                        badges.forEach(jsonArray::add);
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("badges", jsonArray)
                                        .put("count", badges.size())
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting user badges", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get user badges")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * GET /api/user/badges/count - Get user's badge count
     */
    public void getUserBadgeCount(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            badgeService.getUserBadgeCount(userId)
                    .onSuccess(count -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("count", count)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting badge count", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get badge count")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    // ==================== Admin Badge Endpoints ====================

    /**
     * POST /api/admin/badges - Create badge
     */
    public void createBadge(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            Badge badge = jsonToBadge(body);

            badgeService.createBadge(badge)
                    .onSuccess(created -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(badgeToJson(created).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error creating badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to create badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge data")
                    .encode());
        }
    }

    /**
     * PUT /api/admin/badges/:id - Update badge
     */
    public void updateBadge(RoutingContext ctx) {
        try {
            UUID badgeId = UUID.fromString(ctx.pathParam("id"));
            JsonObject body = ctx.body().asJsonObject();
            Badge badge = jsonToBadge(body);
            badge.setId(badgeId);

            badgeService.updateBadge(badge)
                    .onSuccess(updated -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(badgeToJson(updated).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error updating badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to update badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge data")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/badges/:id - Delete badge
     */
    public void deleteBadge(RoutingContext ctx) {
        try {
            UUID badgeId = UUID.fromString(ctx.pathParam("id"));

            badgeService.deleteBadge(badgeId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to delete badge")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge ID")
                    .encode());
        }
    }

    /**
     * POST /api/admin/badges/award - Award badge to user
     */
    public void awardBadge(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            UUID userId = UUID.fromString(body.getString("userId"));
            UUID badgeId = UUID.fromString(body.getString("badgeId"));
            String earnedFor = body.getString("earnedFor", "Manually awarded");

            badgeService.awardBadge(userId, badgeId, earnedFor)
                    .onSuccess(userBadge -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(new JsonObject()
                                        .put("id", userBadge.getId().toString())
                                        .put("userId", userBadge.getUserId().toString())
                                        .put("badgeId", userBadge.getBadgeId().toString())
                                        .put("earnedAt", userBadge.getEarnedAt().toString())
                                        .put("earnedFor", userBadge.getEarnedFor())
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error awarding badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to award badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid request data")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/badges/revoke - Revoke badge from user
     */
    public void revokeBadge(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            UUID userId = UUID.fromString(body.getString("userId"));
            UUID badgeId = UUID.fromString(body.getString("badgeId"));

            badgeService.revokeBadge(userId, badgeId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error revoking badge", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to revoke badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid request data")
                    .encode());
        }
    }

    /**
     * POST /api/admin/badges/:badgeId/award/:userId - Award badge to specific user
     */
    public void awardBadgeToUser(RoutingContext ctx) {
        try {
            UUID badgeId = UUID.fromString(ctx.pathParam("badgeId"));
            UUID userId = UUID.fromString(ctx.pathParam("userId"));
            String earnedFor = "Manually awarded by admin";

            badgeService.awardBadge(userId, badgeId, earnedFor)
                    .onSuccess(userBadge -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(new JsonObject()
                                        .put("id", userBadge.getId().toString())
                                        .put("userId", userBadge.getUserId().toString())
                                        .put("badgeId", userBadge.getBadgeId().toString())
                                        .put("earnedAt", userBadge.getEarnedAt().toString())
                                        .put("earnedFor", userBadge.getEarnedFor())
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error awarding badge to user", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to award badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge or user ID")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/badges/:badgeId/revoke/:userId - Revoke badge from specific user
     */
    public void revokeBadgeFromUser(RoutingContext ctx) {
        try {
            UUID badgeId = UUID.fromString(ctx.pathParam("badgeId"));
            UUID userId = UUID.fromString(ctx.pathParam("userId"));

            badgeService.revokeBadge(userId, badgeId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error revoking badge from user", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to revoke badge")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid badge or user ID")
                    .encode());
        }
    }

    /**
     * GET /api/admin/badges/statistics - Get badge statistics
     */
    public void getBadgeStatistics(RoutingContext ctx) {
        badgeService.getAllBadges()
                .onSuccess(badges -> {
                    JsonObject stats = new JsonObject()
                            .put("totalBadges", badges.size())
                            .put("activeBadges", badges.stream().filter(b -> b.getIsActive()).count());
                    
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(stats.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting badge statistics", err);
                    ctx.response().setStatusCode(500).end(new JsonObject()
                            .put("error", "Failed to get badge statistics")
                            .encode());
                });
    }

    // ==================== JSON Conversion Methods ====================

    private JsonObject badgeToJson(Badge badge) {
        return new JsonObject()
                .put("id", badge.getId().toString())
                .put("name", badge.getName())
                .put("description", badge.getDescription())
                .put("iconUrl", badge.getIconUrl())
                .put("badgeType", badge.getBadgeType().name())
                .put("criteria", badge.getCriteria())
                .put("pointsRequired", badge.getPointsRequired())
                .put("isActive", badge.getIsActive())
                .put("createdAt", badge.getCreatedAt().toString())
                .put("updatedAt", badge.getUpdatedAt().toString());
    }

    private Badge jsonToBadge(JsonObject json) {
        Badge badge = new Badge();
        if (json.containsKey("id")) {
            badge.setId(UUID.fromString(json.getString("id")));
        }
        badge.setName(json.getString("name"));
        badge.setDescription(json.getString("description"));
        badge.setIconUrl(json.getString("iconUrl"));
        badge.setBadgeType(BadgeType.valueOf(json.getString("badgeType")));
        badge.setCriteria(json.getString("criteria"));
        badge.setPointsRequired(json.getInteger("pointsRequired"));
        if (json.containsKey("isActive")) {
            badge.setIsActive(json.getBoolean("isActive"));
        }
        return badge;
    }
}

// Made with Bob
