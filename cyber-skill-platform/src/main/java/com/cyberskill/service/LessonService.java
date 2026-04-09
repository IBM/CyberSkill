package com.cyberskill.service;

import com.cyberskill.model.Lesson;
import com.cyberskill.model.Lesson.ContentType;
import com.cyberskill.repository.LessonRepository;
import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Service for lesson management
 */
public class LessonService {
    private static final Logger logger = LoggerFactory.getLogger(LessonService.class);
    private final LessonRepository lessonRepository;

    public LessonService(LessonRepository lessonRepository) {
        this.lessonRepository = lessonRepository;
    }

    /**
     * Get all lessons for a section
     */
    public Future<JsonArray> getLessonsBySectionId(Integer sectionId) {
        return lessonRepository.findBySectionId(sectionId)
            .map(lessons -> {
                JsonArray result = new JsonArray();
                for (Lesson lesson : lessons) {
                    result.add(lessonToJson(lesson));
                }
                return result;
            })
            .onSuccess(lessons -> logger.debug("Retrieved {} lessons for section {}", lessons.size(), sectionId))
            .onFailure(err -> logger.error("Error retrieving lessons for section: {}", sectionId, err));
    }

    /**
     * Get lesson by ID
     */
    public Future<JsonObject> getLessonById(Integer lessonId) {
        return lessonRepository.findById(lessonId)
            .compose(optLesson -> {
                if (optLesson.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Lesson not found"));
                }
                return Future.succeededFuture(lessonToJson(optLesson.get()));
            })
            .onFailure(err -> logger.error("Error retrieving lesson: {}", lessonId, err));
    }

    /**
     * Get all lessons (admin)
     */
    public Future<JsonArray> getAllLessons() {
        return lessonRepository.findAll()
            .map(lessons -> {
                JsonArray result = new JsonArray();
                for (Lesson lesson : lessons) {
                    result.add(lessonToJson(lesson));
                }
                return result;
            })
            .onSuccess(lessons -> logger.debug("Retrieved {} lessons", lessons.size()))
            .onFailure(err -> logger.error("Error retrieving all lessons", err));
    }

    /**
     * Create new lesson (admin)
     */
    public Future<JsonObject> createLesson(JsonObject lessonData) {
        Lesson lesson = new Lesson();
        lesson.setSectionId(lessonData.getInteger("sectionId"));
        lesson.setName(lessonData.getString("name"));
        lesson.setContent(lessonData.getString("content"));
        lesson.setContentType(ContentType.fromString(lessonData.getString("contentType", "text")));
        lesson.setVideoUrl(lessonData.getString("videoUrl"));
        lesson.setOrderIndex(lessonData.getInteger("orderIndex", 0));
        lesson.setEstimatedMinutes(lessonData.getInteger("estimatedMinutes"));

        return lessonRepository.create(lesson)
            .map(this::lessonToJson)
            .onSuccess(l -> logger.info("Created lesson: {}", l.getString("name")))
            .onFailure(err -> logger.error("Error creating lesson", err));
    }

    /**
     * Update lesson (admin)
     */
    public Future<JsonObject> updateLesson(Integer lessonId, JsonObject lessonData) {
        return lessonRepository.findById(lessonId)
            .compose(optLesson -> {
                if (optLesson.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Lesson not found"));
                }
                
                Lesson lesson = optLesson.get();
                lesson.setName(lessonData.getString("name", lesson.getName()));
                lesson.setContent(lessonData.getString("content", lesson.getContent()));
                
                if (lessonData.containsKey("contentType")) {
                    lesson.setContentType(ContentType.fromString(lessonData.getString("contentType")));
                }
                
                lesson.setVideoUrl(lessonData.getString("videoUrl", lesson.getVideoUrl()));
                lesson.setOrderIndex(lessonData.getInteger("orderIndex", lesson.getOrderIndex()));
                lesson.setEstimatedMinutes(lessonData.getInteger("estimatedMinutes", lesson.getEstimatedMinutes()));
                
                return lessonRepository.update(lesson);
            })
            .map(this::lessonToJson)
            .onSuccess(l -> logger.info("Updated lesson: {}", lessonId))
            .onFailure(err -> logger.error("Error updating lesson: {}", lessonId, err));
    }

    /**
     * Delete lesson (admin)
     */
    public Future<Void> deleteLesson(Integer lessonId) {
        return lessonRepository.delete(lessonId)
            .onSuccess(v -> logger.info("Deleted lesson: {}", lessonId))
            .onFailure(err -> logger.error("Error deleting lesson: {}", lessonId, err));
    }

    /**
     * Convert Lesson to JsonObject
     */
    private JsonObject lessonToJson(Lesson lesson) {
        return new JsonObject()
            .put("id", lesson.getId())
            .put("sectionId", lesson.getSectionId())
            .put("name", lesson.getName())
            .put("content", lesson.getContent())
            .put("contentType", lesson.getContentType().getValue())
            .put("videoUrl", lesson.getVideoUrl())
            .put("orderIndex", lesson.getOrderIndex())
            .put("estimatedMinutes", lesson.getEstimatedMinutes())
            .put("createdAt", lesson.getCreatedAt() != null ? lesson.getCreatedAt().toString() : null)
            .put("updatedAt", lesson.getUpdatedAt() != null ? lesson.getUpdatedAt().toString() : null);
    }
}

// Made with Bob