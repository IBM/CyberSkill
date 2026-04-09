package com.cyberskill.repository;

import com.cyberskill.model.LearningPath;
import io.vertx.core.Future;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Repository for LearningPath database operations
 */
public class LearningPathRepository {
    private static final Logger logger = LoggerFactory.getLogger(LearningPathRepository.class);
    private final PgPool pool;

    public LearningPathRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Find learning path by ID
     */
    public Future<Optional<LearningPath>> findById(Integer id) {
        String query = "SELECT * FROM learning_paths WHERE id = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(id))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<LearningPath>empty();
                }
                return Optional.of(mapRowToLearningPath(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding learning path by id: {}", id, err));
    }

    /**
     * Find learning path by slug
     */
    public Future<Optional<LearningPath>> findBySlug(String slug) {
        String query = "SELECT * FROM learning_paths WHERE slug = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(slug))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<LearningPath>empty();
                }
                return Optional.of(mapRowToLearningPath(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding learning path by slug: {}", slug, err));
    }

    /**
     * Find all learning paths
     */
    public Future<List<LearningPath>> findAll() {
        String query = "SELECT * FROM learning_paths ORDER BY order_index ASC";
        
        return pool.query(query)
            .execute()
            .map(rows -> {
                List<LearningPath> paths = new ArrayList<>();
                for (Row row : rows) {
                    paths.add(mapRowToLearningPath(row));
                }
                return paths;
            })
            .onFailure(err -> logger.error("Error finding all learning paths", err));
    }

    /**
     * Find all active learning paths
     */
    public Future<List<LearningPath>> findAllActive() {
        String query = "SELECT * FROM learning_paths WHERE is_active = true ORDER BY order_index ASC";
        
        return pool.query(query)
            .execute()
            .map(rows -> {
                List<LearningPath> paths = new ArrayList<>();
                for (Row row : rows) {
                    paths.add(mapRowToLearningPath(row));
                }
                return paths;
            })
            .onFailure(err -> logger.error("Error finding active learning paths", err));
    }

    /**
     * Create new learning path
     */
    public Future<LearningPath> create(LearningPath path) {
        String query = "INSERT INTO learning_paths (name, slug, description, icon, order_index, is_active, estimated_hours) " +
                      "VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(
                path.getName(),
                path.getSlug(),
                path.getDescription(),
                path.getIcon(),
                path.getOrderIndex(),
                path.isActive(),
                path.getEstimatedHours()
            ))
            .map(rows -> mapRowToLearningPath(rows.iterator().next()))
            .onSuccess(p -> logger.info("Created learning path: {}", p.getName()))
            .onFailure(err -> logger.error("Error creating learning path: {}", path.getName(), err));
    }

    /**
     * Update learning path
     */
    public Future<LearningPath> update(LearningPath path) {
        String query = "UPDATE learning_paths SET name = $1, slug = $2, description = $3, " +
                      "icon = $4, order_index = $5, is_active = $6, estimated_hours = $7, " +
                      "updated_at = CURRENT_TIMESTAMP WHERE id = $8 RETURNING *";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(
                path.getName(),
                path.getSlug(),
                path.getDescription(),
                path.getIcon(),
                path.getOrderIndex(),
                path.isActive(),
                path.getEstimatedHours(),
                path.getId()
            ))
            .map(rows -> mapRowToLearningPath(rows.iterator().next()))
            .onSuccess(p -> logger.info("Updated learning path: {}", p.getName()))
            .onFailure(err -> logger.error("Error updating learning path: {}", path.getId(), err));
    }

    /**
     * Alias for findAll() - used by AnalyticsService
     */
    public Future<List<LearningPath>> findAllPaths() {
        return findAll();
    }

    /**
     * Delete learning path
     */
    public Future<Void> delete(Integer pathId) {
        String query = "DELETE FROM learning_paths WHERE id = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(pathId))
            .map(rs -> (Void) null)
            .onSuccess(v -> logger.info("Deleted learning path: {}", pathId))
            .onFailure(err -> logger.error("Error deleting learning path: {}", pathId, err));
    }

    /**
     * Map database row to LearningPath object
     */
    private LearningPath mapRowToLearningPath(Row row) {
        LearningPath path = new LearningPath();
        path.setId(row.getInteger("id"));
        path.setName(row.getString("name"));
        path.setSlug(row.getString("slug"));
        path.setDescription(row.getString("description"));
        path.setIcon(row.getString("icon"));
        path.setOrderIndex(row.getInteger("order_index"));
        path.setActive(row.getBoolean("is_active"));
        path.setEstimatedHours(row.getInteger("estimated_hours"));
        path.setCreatedAt(row.getLocalDateTime("created_at"));
        path.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return path;
    }
}

// Made with Bob
