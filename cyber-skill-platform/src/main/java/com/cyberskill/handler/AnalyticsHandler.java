package com.cyberskill.handler;

import com.cyberskill.service.AnalyticsService;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for Analytics HTTP requests
 */
public class AnalyticsHandler {
    private static final Logger logger = LoggerFactory.getLogger(AnalyticsHandler.class);
    private final AnalyticsService analyticsService;

    public AnalyticsHandler(AnalyticsService analyticsService) {
        this.analyticsService = analyticsService;
    }

    /**
     * GET /api/admin/analytics/overview - Get platform overview
     */
    public void getPlatformOverview(RoutingContext ctx) {
        analyticsService.getPlatformOverview()
                .onSuccess(overview -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(overview.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting platform overview", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get platform overview\"}");
                });
    }

    /**
     * GET /api/admin/analytics/engagement - Get user engagement metrics
     */
    public void getUserEngagement(RoutingContext ctx) {
        analyticsService.getUserEngagementMetrics()
                .onSuccess(metrics -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(metrics.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting engagement metrics", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get engagement metrics\"}");
                });
    }

    /**
     * GET /api/admin/analytics/paths - Get learning path statistics
     */
    public void getPathStatistics(RoutingContext ctx) {
        analyticsService.getLearningPathStatistics()
                .onSuccess(stats -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(stats.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting path statistics", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get path statistics\"}");
                });
    }

    /**
     * GET /api/admin/analytics/quizzes - Get quiz performance analytics
     */
    public void getQuizAnalytics(RoutingContext ctx) {
        analyticsService.getQuizPerformanceAnalytics()
                .onSuccess(analytics -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(analytics.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting quiz analytics", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get quiz analytics\"}");
                });
    }

    /**
     * GET /api/admin/analytics/certificates - Get certificate trends
     */
    public void getCertificateTrends(RoutingContext ctx) {
        analyticsService.getCertificateTrends()
                .onSuccess(trends -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(trends.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting certificate trends", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get certificate trends\"}");
                });
    }

    /**
     * GET /api/admin/analytics/badges - Get badge statistics
     */
    public void getBadgeStatistics(RoutingContext ctx) {
        analyticsService.getBadgeStatistics()
                .onSuccess(stats -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(stats.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting badge statistics", err);
                    ctx.response().setStatusCode(500)
                            .putHeader("Content-Type", "application/json")
                            .end("{\"error\":\"Failed to get badge statistics\"}");
                });
    }
}

// Made with Bob
