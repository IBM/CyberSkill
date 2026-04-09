package com.cyberskill.repository;

import com.cyberskill.model.Section;
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
 * Repository for Section entity
 */
public class SectionRepository {
    private static final Logger logger = LoggerFactory.getLogger(SectionRepository.class);
    private final PgPool pool;

    public SectionRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Find all sections for a module
     */
    public Future<List<Section>> findByModuleId(Integer moduleId) {
        String sql = "SELECT id, module_id, name, description, order_index, " +
                    "created_at, updated_at " +
                    "FROM sections " +
                    "WHERE module_id = $1 " +
                    "ORDER BY order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(moduleId))
            .map(this::mapRows)
            .onSuccess(sections -> logger.debug("Found {} sections for module {}", sections.size(), moduleId))
            .onFailure(err -> logger.error("Error finding sections for module: {}", moduleId, err));
    }

    /**
     * Find section by ID
     */
    public Future<Optional<Section>> findById(Integer id) {
        String sql = "SELECT id, module_id, name, description, order_index, " +
                    "created_at, updated_at " +
                    "FROM sections WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<Section>empty();
                }
                return Optional.of(mapRow(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding section by id: {}", id, err));
    }

    /**
     * Find all sections
     */
    public Future<List<Section>> findAll() {
        String sql = "SELECT id, module_id, name, description, order_index, " +
                    "created_at, updated_at " +
                    "FROM sections " +
                    "ORDER BY module_id, order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute()
            .map(this::mapRows)
            .onSuccess(sections -> logger.debug("Found {} sections", sections.size()))
            .onFailure(err -> logger.error("Error finding all sections", err));
    }

    /**
     * Create new section
     */
    public Future<Section> create(Section section) {
        String sql = "INSERT INTO sections (module_id, name, description, order_index) " +
                    "VALUES ($1, $2, $3, $4) " +
                    "RETURNING id, module_id, name, description, order_index, " +
                    "created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                section.getModuleId(),
                section.getName(),
                section.getDescription(),
                section.getOrderIndex()
            ))
            .map(rows -> mapRow(rows.iterator().next()))
            .onSuccess(s -> logger.info("Created section: {} for module {}", s.getName(), s.getModuleId()))
            .onFailure(err -> logger.error("Error creating section", err));
    }

    /**
     * Update section
     */
    public Future<Section> update(Section section) {
        String sql = "UPDATE sections SET " +
                    "name = $1, description = $2, order_index = $3, " +
                    "updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = $4 " +
                    "RETURNING id, module_id, name, description, order_index, " +
                    "created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                section.getName(),
                section.getDescription(),
                section.getOrderIndex(),
                section.getId()
            ))
            .map(rows -> {
                if (rows.size() == 0) {
                    throw new IllegalArgumentException("Section not found: " + section.getId());
                }
                return mapRow(rows.iterator().next());
            })
            .onSuccess(s -> logger.info("Updated section: {}", s.getId()))
            .onFailure(err -> logger.error("Error updating section: {}", section.getId(), err));
    }

    /**
     * Delete section
     */
    public Future<Void> delete(Integer id) {
        String sql = "DELETE FROM sections WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .<Void>map(rows -> {
                if (rows.rowCount() == 0) {
                    throw new IllegalArgumentException("Section not found: " + id);
                }
                return null;
            })
            .onSuccess(v -> logger.info("Deleted section: {}", id))
            .onFailure(err -> logger.error("Error deleting section: {}", id, err));
    }

    /**
     * Map database rows to Section list
     */
    private List<Section> mapRows(RowSet<Row> rows) {
        List<Section> sections = new ArrayList<>();
        for (Row row : rows) {
            sections.add(mapRow(row));
        }
        return sections;
    }

    /**
     * Map database row to Section
     */
    private Section mapRow(Row row) {
        Section section = new Section();
        section.setId(row.getInteger("id"));
        section.setModuleId(row.getInteger("module_id"));
        section.setName(row.getString("name"));
        section.setDescription(row.getString("description"));
        section.setOrderIndex(row.getInteger("order_index"));
        section.setCreatedAt(row.getLocalDateTime("created_at"));
        section.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return section;
    }
}

// Made with Bob