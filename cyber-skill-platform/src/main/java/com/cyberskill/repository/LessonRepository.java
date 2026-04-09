package com.cyberskill.repository;

import com.cyberskill.model.Lesson;
import com.cyberskill.model.Lesson.ContentType;
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
 * Repository for Lesson entity
 */
public class LessonRepository {
    private static final Logger logger = LoggerFactory.getLogger(LessonRepository.class);
    private final PgPool pool;

    public LessonRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Find all lessons for a section
     */
    public Future<List<Lesson>> findBySectionId(Integer sectionId) {
        String sql = "SELECT id, section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes, created_at, updated_at " +
                    "FROM lessons " +
                    "WHERE section_id = $1 " +
                    "ORDER BY order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(sectionId))
            .map(this::mapRows)
            .onSuccess(lessons -> logger.debug("Found {} lessons for section {}", lessons.size(), sectionId))
            .onFailure(err -> logger.error("Error finding lessons for section: {}", sectionId, err));
    }

    /**
     * Find lesson by ID
     */
    public Future<Optional<Lesson>> findById(Integer id) {
        String sql = "SELECT id, section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes, created_at, updated_at " +
                    "FROM lessons WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<Lesson>empty();
                }
                return Optional.of(mapRow(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding lesson by id: {}", id, err));
    }

    /**
     * Find all lessons
     */
    public Future<List<Lesson>> findAll() {
        String sql = "SELECT id, section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes, created_at, updated_at " +
                    "FROM lessons " +
                    "ORDER BY section_id, order_index ASC";

        return pool
            .preparedQuery(sql)
            .execute()
            .map(this::mapRows)
            .onSuccess(lessons -> logger.debug("Found {} lessons", lessons.size()))
            .onFailure(err -> logger.error("Error finding all lessons", err));
    }

    /**
     * Create new lesson
     */
    public Future<Lesson> create(Lesson lesson) {
        String sql = "INSERT INTO lessons (section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes) " +
                    "VALUES ($1, $2, $3, $4, $5, $6, $7) " +
                    "RETURNING id, section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes, created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                lesson.getSectionId(),
                lesson.getName(),
                lesson.getContent(),
                lesson.getContentType().getValue(),
                lesson.getVideoUrl(),
                lesson.getOrderIndex(),
                lesson.getEstimatedMinutes()
            ))
            .map(rows -> mapRow(rows.iterator().next()))
            .onSuccess(l -> logger.info("Created lesson: {} for section {}", l.getName(), l.getSectionId()))
            .onFailure(err -> logger.error("Error creating lesson", err));
    }

    /**
     * Update lesson
     */
    public Future<Lesson> update(Lesson lesson) {
        String sql = "UPDATE lessons SET " +
                    "name = $1, content = $2, content_type = $3, video_url = $4, " +
                    "order_index = $5, estimated_minutes = $6, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE id = $7 " +
                    "RETURNING id, section_id, name, content, content_type, video_url, " +
                    "order_index, estimated_minutes, created_at, updated_at";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(
                lesson.getName(),
                lesson.getContent(),
                lesson.getContentType().getValue(),
                lesson.getVideoUrl(),
                lesson.getOrderIndex(),
                lesson.getEstimatedMinutes(),
                lesson.getId()
            ))
            .map(rows -> {
                if (rows.size() == 0) {
                    throw new IllegalArgumentException("Lesson not found: " + lesson.getId());
                }
                return mapRow(rows.iterator().next());
            })
            .onSuccess(l -> logger.info("Updated lesson: {}", l.getId()))
            .onFailure(err -> logger.error("Error updating lesson: {}", lesson.getId(), err));
    }

    /**
     * Delete lesson
     */
    public Future<Void> delete(Integer id) {
        String sql = "DELETE FROM lessons WHERE id = $1";

        return pool
            .preparedQuery(sql)
            .execute(Tuple.of(id))
            .<Void>map(rows -> {
                if (rows.rowCount() == 0) {
                    throw new IllegalArgumentException("Lesson not found: " + id);
                }
                return null;
            })
            .onSuccess(v -> logger.info("Deleted lesson: {}", id))
            .onFailure(err -> logger.error("Error deleting lesson: {}", id, err));
    }

    /**
     * Map database rows to Lesson list
     */
    private List<Lesson> mapRows(RowSet<Row> rows) {
        List<Lesson> lessons = new ArrayList<>();
        for (Row row : rows) {
            lessons.add(mapRow(row));
        }
        return lessons;
    }

    /**
     * Map database row to Lesson
     */
    private Lesson mapRow(Row row) {
        Lesson lesson = new Lesson();
        lesson.setId(row.getInteger("id"));
        lesson.setSectionId(row.getInteger("section_id"));
        lesson.setName(row.getString("name"));
        lesson.setContent(row.getString("content"));
        lesson.setContentType(ContentType.fromString(row.getString("content_type")));
        lesson.setVideoUrl(row.getString("video_url"));
        lesson.setOrderIndex(row.getInteger("order_index"));
        lesson.setEstimatedMinutes(row.getInteger("estimated_minutes"));
        lesson.setCreatedAt(row.getLocalDateTime("created_at"));
        lesson.setUpdatedAt(row.getLocalDateTime("updated_at"));
        return lesson;
    }
}

// Made with Bob