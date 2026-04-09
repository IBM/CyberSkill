package com.cyberskill.repository;

import com.cyberskill.model.UserProgress;
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
 * Repository for UserProgress database operations
 */
public class ProgressRepository {
    private static final Logger logger = LoggerFactory.getLogger(ProgressRepository.class);
    private final PgPool pool;

    public ProgressRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Create or update user progress for a lesson
     */
    public Future<UserProgress> upsertProgress(UserProgress progress) {
        Promise<UserProgress> promise = Promise.promise();
        
        String sql = "INSERT INTO user_progress (id, user_id, lesson_id, completed, time_spent_seconds, " +
                "started_at, completed_at, last_accessed_at) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8) " +
                "ON CONFLICT (user_id, lesson_id) DO UPDATE SET " +
                "completed = EXCLUDED.completed, " +
                "time_spent_seconds = EXCLUDED.time_spent_seconds, " +
                "completed_at = EXCLUDED.completed_at, " +
                "last_accessed_at = EXCLUDED.last_accessed_at " +
                "RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        progress.getId(),
                        progress.getUserId(),
                        progress.getLessonId(),
                        progress.getCompleted(),
                        progress.getTimeSpentSeconds(),
                        progress.getStartedAt(),
                        progress.getCompletedAt(),
                        progress.getLastAccessedAt()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToProgress(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to upsert progress");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error upserting progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Find progress by user and lesson
     */
    public Future<Optional<UserProgress>> findByUserAndLesson(UUID userId, UUID lessonId) {
        Promise<Optional<UserProgress>> promise = Promise.promise();
        String sql = "SELECT * FROM user_progress WHERE user_id = $1 AND lesson_id = $2";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, lessonId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToProgress(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get all progress for a user
     */
    public Future<List<UserProgress>> findByUserId(UUID userId) {
        Promise<List<UserProgress>> promise = Promise.promise();
        String sql = "SELECT * FROM user_progress WHERE user_id = $1 ORDER BY last_accessed_at DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    List<UserProgress> progressList = new ArrayList<>();
                    rows.forEach(row -> progressList.add(mapRowToProgress(row)));
                    promise.complete(progressList);
                })
                .onFailure(err -> {
                    logger.error("Error finding user progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get completed lessons for a user
     */
    public Future<List<UserProgress>> findCompletedByUserId(UUID userId) {
        Promise<List<UserProgress>> promise = Promise.promise();
        String sql = "SELECT * FROM user_progress WHERE user_id = $1 AND completed = true " +
                "ORDER BY completed_at DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    List<UserProgress> progressList = new ArrayList<>();
                    rows.forEach(row -> progressList.add(mapRowToProgress(row)));
                    promise.complete(progressList);
                })
                .onFailure(err -> {
                    logger.error("Error finding completed progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get progress for lessons in a section
     */
    public Future<List<UserProgress>> findByUserAndSection(UUID userId, UUID sectionId) {
        Promise<List<UserProgress>> promise = Promise.promise();
        String sql = "SELECT up.* FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "WHERE up.user_id = $1 AND l.section_id = $2 " +
                "ORDER BY l.order_index";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, sectionId))
                .onSuccess(rows -> {
                    List<UserProgress> progressList = new ArrayList<>();
                    rows.forEach(row -> progressList.add(mapRowToProgress(row)));
                    promise.complete(progressList);
                })
                .onFailure(err -> {
                    logger.error("Error finding section progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get progress for lessons in a module
     */
    public Future<List<UserProgress>> findByUserAndModule(UUID userId, UUID moduleId) {
        Promise<List<UserProgress>> promise = Promise.promise();
        String sql = "SELECT up.* FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "JOIN sections s ON l.section_id = s.id " +
                "WHERE up.user_id = $1 AND s.module_id = $2 " +
                "ORDER BY s.order_index, l.order_index";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, moduleId))
                .onSuccess(rows -> {
                    List<UserProgress> progressList = new ArrayList<>();
                    rows.forEach(row -> progressList.add(mapRowToProgress(row)));
                    promise.complete(progressList);
                })
                .onFailure(err -> {
                    logger.error("Error finding module progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get progress for lessons in a learning path
     */
    public Future<List<UserProgress>> findByUserAndPath(UUID userId, UUID pathId) {
        Promise<List<UserProgress>> promise = Promise.promise();
        String sql = "SELECT up.* FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "JOIN sections s ON l.section_id = s.id " +
                "JOIN modules m ON s.module_id = m.id " +
                "WHERE up.user_id = $1 AND m.learning_path_id = $2 " +
                "ORDER BY m.order_index, s.order_index, l.order_index";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, pathId))
                .onSuccess(rows -> {
                    List<UserProgress> progressList = new ArrayList<>();
                    rows.forEach(row -> progressList.add(mapRowToProgress(row)));
                    promise.complete(progressList);
                })
                .onFailure(err -> {
                    logger.error("Error finding path progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count completed lessons in a section
     */
    public Future<Integer> countCompletedInSection(UUID userId, UUID sectionId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "WHERE up.user_id = $1 AND l.section_id = $2 AND up.completed = true";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, sectionId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting completed in section", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count total lessons in a section
     */
    public Future<Integer> countLessonsInSection(UUID sectionId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM lessons WHERE section_id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(sectionId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting lessons in section", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count completed lessons in a module
     */
    public Future<Integer> countCompletedInModule(UUID userId, UUID moduleId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "JOIN sections s ON l.section_id = s.id " +
                "WHERE up.user_id = $1 AND s.module_id = $2 AND up.completed = true";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, moduleId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting completed in module", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count total lessons in a module
     */
    public Future<Integer> countLessonsInModule(UUID moduleId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM lessons l " +
                "JOIN sections s ON l.section_id = s.id " +
                "WHERE s.module_id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(moduleId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting lessons in module", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count completed lessons in a learning path
     */
    public Future<Integer> countCompletedInPath(UUID userId, UUID pathId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_progress up " +
                "JOIN lessons l ON up.lesson_id = l.id " +
                "JOIN sections s ON l.section_id = s.id " +
                "JOIN modules m ON s.module_id = m.id " +
                "WHERE up.user_id = $1 AND m.learning_path_id = $2 AND up.completed = true";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, pathId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting completed in path", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count total lessons in a learning path
     */
    public Future<Integer> countLessonsInPath(UUID pathId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM lessons l " +
                "JOIN sections s ON l.section_id = s.id " +
                "JOIN modules m ON s.module_id = m.id " +
                "WHERE m.learning_path_id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(pathId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting lessons in path", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Delete progress record
     */
    public Future<Void> deleteProgress(UUID userId, UUID lessonId) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM user_progress WHERE user_id = $1 AND lesson_id = $2";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, lessonId))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting progress", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count active users (users with progress in last N days)
     */
    public Future<Integer> countActiveUsers(int days) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(DISTINCT user_id) as count FROM user_progress " +
                "WHERE last_accessed_at >= NOW() - INTERVAL '" + days + " days'";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting active users", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get average completion rate across all users
     */
    public Future<Double> getAverageCompletionRate() {
        Promise<Double> promise = Promise.promise();
        String sql = "SELECT AVG(CASE WHEN total > 0 THEN (completed::float / total::float) * 100 ELSE 0 END) as avg_rate " +
                "FROM (SELECT user_id, " +
                "COUNT(*) as total, " +
                "SUM(CASE WHEN completed THEN 1 ELSE 0 END) as completed " +
                "FROM user_progress GROUP BY user_id) as user_stats";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        Double rate = rows.iterator().next().getDouble("avg_rate");
                        promise.complete(rate != null ? rate : 0.0);
                    } else {
                        promise.complete(0.0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting average completion rate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Count all completed lessons across all users
     */
    public Future<Integer> countAllCompletedLessons() {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM user_progress WHERE completed = true";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting completed lessons", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Get total time spent across all users (in seconds)
     */
    public Future<Long> getTotalTimeSpent() {
        Promise<Long> promise = Promise.promise();
        String sql = "SELECT COALESCE(SUM(time_spent_seconds), 0) as total FROM user_progress";

        pool.query(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getLong("total"));
                    } else {
                        promise.complete(0L);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting total time spent", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    /**
     * Map database row to UserProgress object
     */
    private UserProgress mapRowToProgress(Row row) {
        UserProgress progress = new UserProgress();
        progress.setId(row.getUUID("id"));
        progress.setUserId(row.getUUID("user_id"));
        progress.setLessonId(row.getUUID("lesson_id"));
        progress.setCompleted(row.getBoolean("completed"));
        progress.setTimeSpentSeconds(row.getInteger("time_spent_seconds"));
        progress.setStartedAt(row.getLocalDateTime("started_at"));
        progress.setCompletedAt(row.getLocalDateTime("completed_at"));
        progress.setLastAccessedAt(row.getLocalDateTime("last_accessed_at"));
        return progress;
    }
}

// Made with Bob
