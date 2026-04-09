package com.cyberskill.service;

import com.cyberskill.repository.*;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Service for platform analytics and reporting
 */
public class AnalyticsService {
    private static final Logger logger = LoggerFactory.getLogger(AnalyticsService.class);
    
    private final UserRepository userRepository;
    private final ProgressRepository progressRepository;
    private final QuizRepository quizRepository;
    private final BadgeRepository badgeRepository;
    private final CertificateRepository certificateRepository;
    private final LearningPathRepository learningPathRepository;

    public AnalyticsService(
            UserRepository userRepository,
            ProgressRepository progressRepository,
            QuizRepository quizRepository,
            BadgeRepository badgeRepository,
            CertificateRepository certificateRepository,
            LearningPathRepository learningPathRepository
    ) {
        this.userRepository = userRepository;
        this.progressRepository = progressRepository;
        this.quizRepository = quizRepository;
        this.badgeRepository = badgeRepository;
        this.certificateRepository = certificateRepository;
        this.learningPathRepository = learningPathRepository;
    }

    /**
     * Get platform overview statistics
     */
    public Future<JsonObject> getPlatformOverview() {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                getTotalUsers(),
                getActiveUsers(),
                getTotalCertificates(),
                getTotalBadges(),
                getTotalQuizAttempts(),
                getAverageCompletionRate()
        ).onSuccess(composite -> {
            JsonObject overview = new JsonObject()
                    .put("totalUsers", composite.resultAt(0))
                    .put("activeUsers", composite.resultAt(1))
                    .put("totalCertificates", composite.resultAt(2))
                    .put("totalBadges", composite.resultAt(3))
                    .put("totalQuizAttempts", composite.resultAt(4))
                    .put("averageCompletionRate", composite.resultAt(5))
                    .put("timestamp", System.currentTimeMillis());
            
            promise.complete(overview);
        }).onFailure(err -> {
            logger.error("Error getting platform overview", err);
            promise.fail(err);
        });

        return promise.future();
    }

    /**
     * Get user engagement metrics
     */
    public Future<JsonObject> getUserEngagementMetrics() {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                getActiveUsers(),
                getTotalUsers(),
                getAverageLessonsPerUser(),
                getAverageTimeSpentPerUser()
        ).onSuccess(composite -> {
            int activeUsers = composite.resultAt(0);
            int totalUsers = composite.resultAt(1);
            double avgLessons = composite.resultAt(2);
            double avgTime = composite.resultAt(3);
            
            double engagementRate = totalUsers > 0 ? (double) activeUsers / totalUsers * 100 : 0;
            
            JsonObject metrics = new JsonObject()
                    .put("activeUsers", activeUsers)
                    .put("totalUsers", totalUsers)
                    .put("engagementRate", String.format("%.2f%%", engagementRate))
                    .put("averageLessonsPerUser", String.format("%.1f", avgLessons))
                    .put("averageTimeSpentPerUser", String.format("%.1f hours", avgTime / 3600))
                    .put("timestamp", System.currentTimeMillis());
            
            promise.complete(metrics);
        }).onFailure(err -> {
            logger.error("Error getting engagement metrics", err);
            promise.fail(err);
        });

        return promise.future();
    }

    /**
     * Get learning path statistics
     */
    public Future<JsonArray> getLearningPathStatistics() {
        Promise<JsonArray> promise = Promise.promise();

        learningPathRepository.findAllPaths()
                .compose(paths -> {
                    JsonArray pathStats = new JsonArray();
                    
                    // For each path, get enrollment and completion stats
                    for (int i = 0; i < paths.size(); i++) {
                        var path = paths.get(i);
                        JsonObject stat = new JsonObject()
                                .put("pathId", path.getId().toString())
                                .put("pathName", path.getName())
                                .put("enrollments", 0) // Placeholder
                                .put("completions", 0) // Placeholder
                                .put("averageProgress", "0%");
                        pathStats.add(stat);
                    }
                    
                    return Future.succeededFuture(pathStats);
                })
                .onSuccess(promise::complete)
                .onFailure(err -> {
                    logger.error("Error getting path statistics", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get quiz performance analytics
     */
    public Future<JsonObject> getQuizPerformanceAnalytics() {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                getTotalQuizAttempts(),
                getAverageQuizScore(),
                getQuizPassRate()
        ).onSuccess(composite -> {
            JsonObject analytics = new JsonObject()
                    .put("totalAttempts", composite.resultAt(0))
                    .put("averageScore", String.format("%.1f%%", (double) composite.resultAt(1)))
                    .put("passRate", String.format("%.1f%%", (double) composite.resultAt(2)))
                    .put("timestamp", System.currentTimeMillis());
            
            promise.complete(analytics);
        }).onFailure(err -> {
            logger.error("Error getting quiz analytics", err);
            promise.fail(err);
        });

        return promise.future();
    }

    /**
     * Get certificate issuance trends
     */
    public Future<JsonObject> getCertificateTrends() {
        return certificateRepository.getCertificateStatistics()
                .map(count -> new JsonObject().put("totalCertificates", count));
    }

    /**
     * Get badge award statistics
     */
    public Future<JsonObject> getBadgeStatistics() {
        return badgeRepository.getBadgeStatistics()
                .map(count -> new JsonObject().put("totalBadges", count));
    }

    // ==================== Helper Methods ====================

    private Future<Integer> getTotalUsers() {
        return userRepository.countAllUsers();
    }

    private Future<Integer> getActiveUsers() {
        // Users who have completed at least one lesson in the last 30 days
        return progressRepository.countActiveUsers(30);
    }

    private Future<Integer> getTotalCertificates() {
        return certificateRepository.countAllCertificates();
    }

    private Future<Integer> getTotalBadges() {
        return badgeRepository.countAllUserBadges();
    }

    private Future<Integer> getTotalQuizAttempts() {
        return quizRepository.countAllAttempts();
    }

    private Future<Double> getAverageCompletionRate() {
        Promise<Double> promise = Promise.promise();
        
        // Calculate average completion rate across all users and paths
        progressRepository.getAverageCompletionRate()
                .onSuccess(rate -> promise.complete(rate))
                .onFailure(err -> {
                    logger.warn("Error calculating completion rate, returning 0", err);
                    promise.complete(0.0);
                });
        
        return promise.future();
    }

    private Future<Double> getAverageLessonsPerUser() {
        Promise<Double> promise = Promise.promise();
        
        Future.all(
                progressRepository.countAllCompletedLessons(),
                getTotalUsers()
        ).onSuccess(composite -> {
            int totalLessons = composite.resultAt(0);
            int totalUsers = composite.resultAt(1);
            double average = totalUsers > 0 ? (double) totalLessons / totalUsers : 0;
            promise.complete(average);
        }).onFailure(err -> {
            logger.warn("Error calculating average lessons per user", err);
            promise.complete(0.0);
        });
        
        return promise.future();
    }

    private Future<Double> getAverageTimeSpentPerUser() {
        Promise<Double> promise = Promise.promise();
        
        Future.all(
                progressRepository.getTotalTimeSpent(),
                getTotalUsers()
        ).onSuccess(composite -> {
            long totalTime = composite.resultAt(0);
            int totalUsers = composite.resultAt(1);
            double average = totalUsers > 0 ? (double) totalTime / totalUsers : 0;
            promise.complete(average);
        }).onFailure(err -> {
            logger.warn("Error calculating average time per user", err);
            promise.complete(0.0);
        });
        
        return promise.future();
    }

    private Future<Double> getAverageQuizScore() {
        return quizRepository.getAverageScore();
    }

    private Future<Double> getQuizPassRate() {
        return quizRepository.getPassRate();
    }
}

// Made with Bob
