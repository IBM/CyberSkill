package com.cyberskill.repository;

import com.cyberskill.model.Badge;
import com.cyberskill.model.BadgeType;
import com.cyberskill.model.UserBadge;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository for Badge database operations
 */
public class BadgeRepository {
    private static final Logger logger = LoggerFactory.getLogger(BadgeRepository.class);
    private final PgPool pool;

    public BadgeRepository(PgPool pool) {
        this.pool = pool;
    }

    // ==================== Badge CRUD Operations ====================

    public Future<Badge> createBadge(Badge badge) {
        Promise<Badge> promise = Promise.promise();
        String sql = "INSERT INTO badges (id, name, description, icon_url, badge_type, criteria, " +
                "points_required, is_active, created_at, updated_at) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        badge.getId(),
                        badge.getName(),
                        badge.getDescription(),
                        badge.getIconUrl(),
                        badge.getBadgeType().name(),
                        badge.getCriteria(),
                        badge.getPointsRequired(),
                        badge.getIsActive(),
                        badge.getCreatedAt(),
                        badge.getUpdatedAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToBadge(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create badge");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Badge>> findBadgeById(UUID id) {
        Promise<Optional<Badge>> promise = Promise.promise();
        String sql = "SELECT * FROM badges WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToBadge(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Badge>> findAllBadges() {
        Promise<List<Badge>> promise = Promise.promise();
        String sql = "SELECT * FROM badges WHERE is_active = true ORDER BY badge_type, name";

        pool.preparedQuery(sql)
                .execute()
                .onSuccess(rows -> {
                    List<Badge> badges = new ArrayList<>();
                    rows.forEach(row -> badges.add(mapRowToBadge(row)));
                    promise.complete(badges);
                })
                .onFailure(err -> {
                    logger.error("Error finding all badges", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Badge>> findBadgesByType(BadgeType badgeType) {
        Promise<List<Badge>> promise = Promise.promise();
        String sql = "SELECT * FROM badges WHERE badge_type = $1 AND is_active = true ORDER BY name";

        pool.preparedQuery(sql)
                .execute(Tuple.of(badgeType.name()))
                .onSuccess(rows -> {
                    List<Badge> badges = new ArrayList<>();
                    rows.forEach(row -> badges.add(mapRowToBadge(row)));
                    promise.complete(badges);
                })
                .onFailure(err -> {
                    logger.error("Error finding badges by type", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Badge> updateBadge(Badge badge) {
        Promise<Badge> promise = Promise.promise();
        badge.setUpdatedAt(LocalDateTime.now());
        String sql = "UPDATE badges SET name = $1, description = $2, icon_url = $3, " +
                "badge_type = $4, criteria = $5, points_required = $6, is_active = $7, " +
                "updated_at = $8 WHERE id = $9 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        badge.getName(),
                        badge.getDescription(),
                        badge.getIconUrl(),
                        badge.getBadgeType().name(),
                        badge.getCriteria(),
                        badge.getPointsRequired(),
                        badge.getIsActive(),
                        badge.getUpdatedAt(),
                        badge.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToBadge(rows.iterator().next()));
                    } else {
                        promise.fail("Badge not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> deleteBadge(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM badges WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== UserBadge Operations ====================

    public Future<UserBadge> awardBadge(UserBadge userBadge) {
        Promise<UserBadge> promise = Promise.promise();
        String sql = "INSERT INTO user_badges (id, user_id, badge_id, earned_at, earned_for) " +
                "VALUES ($1, $2, $3, $4, $5) " +
                "ON CONFLICT (user_id, badge_id) DO NOTHING " +
                "RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        userBadge.getId(),
                        userBadge.getUserId(),
                        userBadge.getBadgeId(),
                        userBadge.getEarnedAt(),
                        userBadge.getEarnedFor()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToUserBadge(rows.iterator().next()));
                    } else {
                        // Badge already awarded, fetch existing
                        findUserBadge(userBadge.getUserId(), userBadge.getBadgeId())
                                .onSuccess(existing -> {
                                    if (existing.isPresent()) {
                                        promise.complete(existing.get());
                                    } else {
                                        promise.fail("Failed to award badge");
                                    }
                                })
                                .onFailure(promise::fail);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error awarding badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<UserBadge>> findUserBadge(UUID userId, UUID badgeId) {
        Promise<Optional<UserBadge>> promise = Promise.promise();
        String sql = "SELECT * FROM user_badges WHERE user_id = $1 AND badge_id = $2";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, badgeId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToUserBadge(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding user badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<UserBadge>> findUserBadges(UUID userId) {
        Promise<List<UserBadge>> promise = Promise.promise();
        String sql = "SELECT * FROM user_badges WHERE user_id = $1 ORDER BY earned_at DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    List<UserBadge> userBadges = new ArrayList<>();
                    rows.forEach(row -> userBadges.add(mapRowToUserBadge(row)));
                    promise.complete(userBadges);
                })
                .onFailure(err -> {
                    logger.error("Error finding user badges", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> countUserBadges(UUID userId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_badges WHERE user_id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting user badges", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Boolean> hasUserEarnedBadge(UUID userId, UUID badgeId) {
        Promise<Boolean> promise = Promise.promise();
        
        findUserBadge(userId, badgeId)
                .onSuccess(userBadge -> promise.complete(userBadge.isPresent()))
                .onFailure(promise::fail);

        return promise.future();
    }

    public Future<Void> revokeBadge(UUID userId, UUID badgeId) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM user_badges WHERE user_id = $1 AND badge_id = $2";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, badgeId))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error revoking badge", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> getBadgeStatistics() {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM badges WHERE is_active = true";

        pool.preparedQuery(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting badge statistics", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> countAllUserBadges() {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_badges";

        pool.preparedQuery(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting all user badges", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    // ==================== Mapping Methods ====================

    private Badge mapRowToBadge(Row row) {
        Badge badge = new Badge();
        badge.setId(row.getUUID("id"));
        badge.setName(row.getString("name"));
        badge.setDescription(row.getString("description"));
        badge.setIconUrl(row.getString("icon_url"));
        badge.setBadgeType(BadgeType.valueOf(row.getString("badge_type")));
        badge.setCriteria(row.getString("criteria"));
        badge.setPointsRequired(row.getInteger("points_required"));
        badge.setIsActive(row.getBoolean("is_active"));
        badge.setCreatedAt(row.getLocalDateTime("created_at"));
        badge.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return badge;
    }

    private UserBadge mapRowToUserBadge(Row row) {
        UserBadge userBadge = new UserBadge();
        userBadge.setId(row.getUUID("id"));
        userBadge.setUserId(row.getUUID("user_id"));
        userBadge.setBadgeId(row.getUUID("badge_id"));
        userBadge.setEarnedAt(row.getLocalDateTime("earned_at"));
        userBadge.setEarnedFor(row.getString("earned_for"));
        return userBadge;
    }
}

// Made with Bob
