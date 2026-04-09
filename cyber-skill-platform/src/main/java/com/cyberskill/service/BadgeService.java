package com.cyberskill.service;

import com.cyberskill.model.Badge;
import com.cyberskill.model.BadgeType;
import com.cyberskill.model.UserBadge;
import com.cyberskill.repository.BadgeRepository;
import com.cyberskill.repository.ProgressRepository;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;

/**
 * Service layer for Badge business logic
 */
public class BadgeService {
    private static final Logger logger = LoggerFactory.getLogger(BadgeService.class);
    private final BadgeRepository badgeRepository;
    private final ProgressRepository progressRepository;

    public BadgeService(BadgeRepository badgeRepository, ProgressRepository progressRepository) {
        this.badgeRepository = badgeRepository;
        this.progressRepository = progressRepository;
    }

    // ==================== Badge CRUD Operations ====================

    public Future<Badge> createBadge(Badge badge) {
        return badgeRepository.createBadge(badge);
    }

    public Future<Optional<Badge>> getBadgeById(UUID id) {
        return badgeRepository.findBadgeById(id);
    }

    public Future<List<Badge>> getAllBadges() {
        return badgeRepository.findAllBadges();
    }

    public Future<List<Badge>> getBadgesByType(BadgeType badgeType) {
        return badgeRepository.findBadgesByType(badgeType);
    }

    public Future<Badge> updateBadge(Badge badge) {
        return badgeRepository.updateBadge(badge);
    }

    public Future<Void> deleteBadge(UUID id) {
        return badgeRepository.deleteBadge(id);
    }

    // ==================== User Badge Operations ====================

    public Future<UserBadge> awardBadge(UUID userId, UUID badgeId, String earnedFor) {
        UserBadge userBadge = new UserBadge(userId, badgeId, earnedFor);
        return badgeRepository.awardBadge(userBadge);
    }

    public Future<List<UserBadge>> getUserBadges(UUID userId) {
        return badgeRepository.findUserBadges(userId);
    }

    public Future<Integer> getUserBadgeCount(UUID userId) {
        return badgeRepository.countUserBadges(userId);
    }

    public Future<Boolean> hasUserEarnedBadge(UUID userId, UUID badgeId) {
        return badgeRepository.hasUserEarnedBadge(userId, badgeId);
    }

    public Future<Void> revokeBadge(UUID userId, UUID badgeId) {
        return badgeRepository.revokeBadge(userId, badgeId);
    }

    /**
     * Get user badges with full badge details
     */
    public Future<List<JsonObject>> getUserBadgesWithDetails(UUID userId) {
        Promise<List<JsonObject>> promise = Promise.promise();

        badgeRepository.findUserBadges(userId)
                .compose(userBadges -> {
                    if (userBadges.isEmpty()) {
                        return Future.succeededFuture(new ArrayList<>());
                    }

                    // Fetch badge details for each user badge
                    List<Future<JsonObject>> badgeFutures = new ArrayList<>();
                    for (UserBadge userBadge : userBadges) {
                        Future<JsonObject> badgeFuture = badgeRepository.findBadgeById(userBadge.getBadgeId())
                                .map(badgeOpt -> {
                                    JsonObject result = new JsonObject();
                                    result.put("userBadgeId", userBadge.getId().toString());
                                    result.put("earnedAt", userBadge.getEarnedAt().toString());
                                    result.put("earnedFor", userBadge.getEarnedFor());
                                    
                                    if (badgeOpt.isPresent()) {
                                        Badge badge = badgeOpt.get();
                                        result.put("badgeId", badge.getId().toString());
                                        result.put("name", badge.getName());
                                        result.put("description", badge.getDescription());
                                        result.put("iconUrl", badge.getIconUrl());
                                        result.put("badgeType", badge.getBadgeType().name());
                                    }
                                    
                                    return result;
                                });
                        badgeFutures.add(badgeFuture);
                    }

                    return Future.all(badgeFutures).map(compositeFuture -> {
                        List<JsonObject> results = new ArrayList<>();
                        for (int i = 0; i < compositeFuture.size(); i++) {
                            results.add((JsonObject) compositeFuture.resultAt(i));
                        }
                        return results;
                    });
                })
                .onComplete(ar -> {
                    if (ar.succeeded()) {
                        @SuppressWarnings("unchecked")
                        List<JsonObject> results = (List<JsonObject>) ar.result();
                        promise.complete(results);
                    } else {
                        promise.fail(ar.cause());
                    }
                });

        return promise.future();
    }

    // ==================== Auto-Award Logic ====================

    /**
     * Check and award section completion badge
     */
    public Future<Optional<UserBadge>> checkAndAwardSectionBadge(UUID userId, UUID sectionId, String sectionName) {
        Promise<Optional<UserBadge>> promise = Promise.promise();

        // Check if section is completed
        Future.all(
                progressRepository.countCompletedInSection(userId, sectionId),
                progressRepository.countLessonsInSection(sectionId)
        ).compose(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);

            if (total > 0 && completed == total) {
                // Section completed, find or create badge
                return findOrCreateSectionBadge(sectionName)
                        .compose(badge -> {
                            // Award badge
                            String earnedFor = "Completed " + sectionName + " section";
                            return awardBadge(userId, badge.getId(), earnedFor)
                                    .map(Optional::of);
                        });
            } else {
                return Future.succeededFuture(Optional.<UserBadge>empty());
            }
        }).onSuccess(promise::complete)
          .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Check and award module completion badge
     */
    public Future<Optional<UserBadge>> checkAndAwardModuleBadge(UUID userId, UUID moduleId, String moduleName) {
        Promise<Optional<UserBadge>> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInModule(userId, moduleId),
                progressRepository.countLessonsInModule(moduleId)
        ).compose(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);

            if (total > 0 && completed == total) {
                return findOrCreateModuleBadge(moduleName)
                        .compose(badge -> {
                            String earnedFor = "Completed " + moduleName + " module";
                            return awardBadge(userId, badge.getId(), earnedFor)
                                    .map(Optional::of);
                        });
            } else {
                return Future.succeededFuture(Optional.<UserBadge>empty());
            }
        }).onSuccess(promise::complete)
          .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Check and award learning path completion badge
     */
    public Future<Optional<UserBadge>> checkAndAwardPathBadge(UUID userId, UUID pathId, String pathName) {
        Promise<Optional<UserBadge>> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInPath(userId, pathId),
                progressRepository.countLessonsInPath(pathId)
        ).compose(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);

            if (total > 0 && completed == total) {
                return findOrCreatePathBadge(pathName)
                        .compose(badge -> {
                            String earnedFor = "Completed " + pathName + " learning path";
                            return awardBadge(userId, badge.getId(), earnedFor)
                                    .map(Optional::of);
                        });
            } else {
                return Future.succeededFuture(Optional.<UserBadge>empty());
            }
        }).onSuccess(promise::complete)
          .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Check and award streak achievement badge
     */
    public Future<Optional<UserBadge>> checkAndAwardStreakBadge(UUID userId, int streakDays) {
        Promise<Optional<UserBadge>> promise = Promise.promise();

        // Award badges for milestone streaks (7, 30, 100 days)
        String badgeName = null;
        String earnedFor = null;

        if (streakDays >= 100) {
            badgeName = "Century Streak";
            earnedFor = "Maintained a 100-day learning streak";
        } else if (streakDays >= 30) {
            badgeName = "Monthly Dedication";
            earnedFor = "Maintained a 30-day learning streak";
        } else if (streakDays >= 7) {
            badgeName = "Week Warrior";
            earnedFor = "Maintained a 7-day learning streak";
        }

        if (badgeName != null) {
            String finalBadgeName = badgeName;
            String finalEarnedFor = earnedFor;
            
            findOrCreateStreakBadge(finalBadgeName, streakDays)
                    .compose(badge -> {
                        // Check if already earned
                        return hasUserEarnedBadge(userId, badge.getId())
                                .compose(hasEarned -> {
                                    if (!hasEarned) {
                                        return awardBadge(userId, badge.getId(), finalEarnedFor)
                                                .map(Optional::of);
                                    } else {
                                        return Future.succeededFuture(Optional.<UserBadge>empty());
                                    }
                                });
                    })
                    .onSuccess(promise::complete)
                    .onFailure(promise::fail);
        } else {
            promise.complete(Optional.empty());
        }

        return promise.future();
    }

    // ==================== Helper Methods ====================

    private Future<Badge> findOrCreateSectionBadge(String sectionName) {
        Promise<Badge> promise = Promise.promise();

        // Try to find existing badge
        badgeRepository.findBadgesByType(BadgeType.SECTION_COMPLETION)
                .compose(badges -> {
                    Optional<Badge> existing = badges.stream()
                            .filter(b -> b.getName().equals(sectionName + " Completion"))
                            .findFirst();

                    if (existing.isPresent()) {
                        return Future.succeededFuture(existing.get());
                    } else {
                        // Create new badge
                        Badge newBadge = new Badge(
                                sectionName + " Completion",
                                "Completed all lessons in " + sectionName,
                                BadgeType.SECTION_COMPLETION
                        );
                        return badgeRepository.createBadge(newBadge);
                    }
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    private Future<Badge> findOrCreateModuleBadge(String moduleName) {
        Promise<Badge> promise = Promise.promise();

        badgeRepository.findBadgesByType(BadgeType.MODULE_COMPLETION)
                .compose(badges -> {
                    Optional<Badge> existing = badges.stream()
                            .filter(b -> b.getName().equals(moduleName + " Master"))
                            .findFirst();

                    if (existing.isPresent()) {
                        return Future.succeededFuture(existing.get());
                    } else {
                        Badge newBadge = new Badge(
                                moduleName + " Master",
                                "Mastered the " + moduleName + " module",
                                BadgeType.MODULE_COMPLETION
                        );
                        return badgeRepository.createBadge(newBadge);
                    }
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    private Future<Badge> findOrCreatePathBadge(String pathName) {
        Promise<Badge> promise = Promise.promise();

        badgeRepository.findBadgesByType(BadgeType.PATH_COMPLETION)
                .compose(badges -> {
                    Optional<Badge> existing = badges.stream()
                            .filter(b -> b.getName().equals(pathName + " Expert"))
                            .findFirst();

                    if (existing.isPresent()) {
                        return Future.succeededFuture(existing.get());
                    } else {
                        Badge newBadge = new Badge(
                                pathName + " Expert",
                                "Completed the entire " + pathName + " learning path",
                                BadgeType.PATH_COMPLETION
                        );
                        return badgeRepository.createBadge(newBadge);
                    }
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    private Future<Badge> findOrCreateStreakBadge(String badgeName, int streakDays) {
        Promise<Badge> promise = Promise.promise();

        badgeRepository.findBadgesByType(BadgeType.STREAK_ACHIEVEMENT)
                .compose(badges -> {
                    Optional<Badge> existing = badges.stream()
                            .filter(b -> b.getName().equals(badgeName))
                            .findFirst();

                    if (existing.isPresent()) {
                        return Future.succeededFuture(existing.get());
                    } else {
                        Badge newBadge = new Badge(
                                badgeName,
                                "Maintained a " + streakDays + "-day learning streak",
                                BadgeType.STREAK_ACHIEVEMENT
                        );
                        return badgeRepository.createBadge(newBadge);
                    }
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }
}

// Made with Bob
