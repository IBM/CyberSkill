package com.cyberskill.repository;

import com.cyberskill.model.Module;
import io.vertx.core.Future;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Repository for Module entity
 */
public class ModuleRepository {
    private static final Logger logger = LoggerFactory.getLogger(ModuleRepository.class);
    private final PgPool pool;

    public ModuleRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Find all modules for a learning path
     */
    public Future<List<Module>> findByLearningPathId(Integer pathId) {
        String sql = "SELECT id, learning_path_id, name, description, order_index, " +
                    "estimated_hours, created_at, updated_at " +
                    "FROM modules " +
                    "WHERE learning_path_id = $1 " +
                    "ORDER BY order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(pathId))
            .map(this::mapRows)
            .onSuccess(modules -> logger.debug("Found {} modules for path {}", modules.size(), pathId))
            .onFailure(err -> logger.error("Error finding modules for path: {}", pathId, err));
    }

    /**
     * Find module by ID
     */
    public Future<Optional<Module>> findById(Integer id) {
        String sql = "SELECT id, learning_path_id, name, description, order_index, " +
                    "estimated_hours, created_at, updated_at " +
                    "FROM modules WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<Module>empty();
                }
                return Optional.of(mapRow(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding module by id: {}", id, err));
    }

    /**
     * Find all modules
     */
    public Future<List<Module>> findAll() {
        String sql = "SELECT id, learning_path_id, name, description, order_index, " +
                    "estimated_hours, created_at, updated_at " +
                    "FROM modules " +
                    "ORDER BY learning_path_id, order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute()
            .map(this::mapRows)
            .onSuccess(modules -> logger.debug("Found {} modules", modules.size()))
            .onFailure(err -> logger.error("Error finding all modules", err));
    }

    /**
     * Create new module
     */
    public Future<Module> create(Module module) {
        String sql = "INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours) " +
                    "VALUES ($1, $2, $3, $4, $5) " +
                    "RETURNING id, learning_path_id, name, description, order_index, " +
                    "estimated_hours, created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                module.getLearningPathId(),
                module.getName(),
                module.getDescription(),
                module.getOrderIndex(),
                module.getEstimatedHours()
            ))
            .map(rows -> mapRow(rows.iterator().next()))
            .onSuccess(m -> logger.info("Created module: {} for path {}", m.getName(), m.getLearningPathId()))
            .onFailure(err -> logger.error("Error creating module", err));
    }

    /**
     * Update module
     */
    public Future<Module> update(Module module) {
        String sql = "UPDATE modules SET " +
                    "name = $1, description = $2, order_index = $3, " +
                    "estimated_hours = $4, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = $5 " +
                    "RETURNING id, learning_path_id, name, description, order_index, " +
                    "estimated_hours, created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                module.getName(),
                module.getDescription(),
                module.getOrderIndex(),
                module.getEstimatedHours(),
                module.getId()
            ))
            .map(rows -> {
                if (rows.size() == 0) {
                    throw new IllegalArgumentException("Module not found: " + module.getId());
                }
                return mapRow(rows.iterator().next());
            })
            .onSuccess(m -> logger.info("Updated module: {}", m.getId()))
            .onFailure(err -> logger.error("Error updating module: {}", module.getId(), err));
    }

    /**
     * Delete module
     */
    public Future<Void> delete(Integer id) {
        String sql = "DELETE FROM modules WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .<Void>map(rows -> {
                if (rows.rowCount() == 0) {
                    throw new IllegalArgumentException("Module not found: " + id);
                }
                return null;
            })
            .onSuccess(v -> logger.info("Deleted module: {}", id))
            .onFailure(err -> logger.error("Error deleting module: {}", id, err));
    }

    /**
     * Map database rows to Module list
     */
    private List<Module> mapRows(RowSet<Row> rows) {
        List<Module> modules = new ArrayList<>();
        for (Row row : rows) {
            modules.add(mapRow(row));
        }
        return modules;
    }

    /**
     * Map database row to Module
     */
    private Module mapRow(Row row) {
        Module module = new Module();
        module.setId(row.getInteger("id"));
        module.setLearningPathId(row.getInteger("learning_path_id"));
        module.setName(row.getString("name"));
        module.setDescription(row.getString("description"));
        module.setOrderIndex(row.getInteger("order_index"));
        module.setEstimatedHours(row.getInteger("estimated_hours"));
        module.setCreatedAt(row.getLocalDateTime("created_at"));
        module.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return module;
    }
}

// Made with Bob