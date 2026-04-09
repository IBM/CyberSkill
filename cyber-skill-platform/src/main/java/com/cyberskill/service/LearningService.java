package com.cyberskill.service;

import com.cyberskill.model.LearningPath;
import com.cyberskill.repository.LearningPathRepository;
import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

/**
 * Service for learning content management
 */
public class LearningService {
    private static final Logger logger = LoggerFactory.getLogger(LearningService.class);
    private final LearningPathRepository pathRepository;

    public LearningService(LearningPathRepository pathRepository) {
        this.pathRepository = pathRepository;
    }

    /**
     * Get all active learning paths
     */
    public Future<JsonArray> getAllActivePaths() {
        return pathRepository.findAllActive()
            .map(paths -> {
                JsonArray result = new JsonArray();
                for (LearningPath path : paths) {
                    result.add(pathToJson(path));
                }
                return result;
            })
            .onSuccess(paths -> logger.debug("Retrieved {} active learning paths", paths.size()))
            .onFailure(err -> logger.error("Error retrieving active learning paths", err));
    }

    /**
     * Get all learning paths (admin)
     */
    public Future<JsonArray> getAllPaths() {
        return pathRepository.findAll()
            .map(paths -> {
                JsonArray result = new JsonArray();
                for (LearningPath path : paths) {
                    result.add(pathToJson(path));
                }
                return result;
            })
            .onSuccess(paths -> logger.debug("Retrieved {} learning paths", paths.size()))
            .onFailure(err -> logger.error("Error retrieving learning paths", err));
    }

    /**
     * Get learning path by ID
     */
    public Future<JsonObject> getPathById(Integer pathId) {
        return pathRepository.findById(pathId)
            .compose(optPath -> {
                if (optPath.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Learning path not found"));
                }
                return Future.succeededFuture(pathToJson(optPath.get()));
            })
            .onFailure(err -> logger.error("Error retrieving learning path: {}", pathId, err));
    }

    /**
     * Get learning path by slug
     */
    public Future<JsonObject> getPathBySlug(String slug) {
        return pathRepository.findBySlug(slug)
            .compose(optPath -> {
                if (optPath.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Learning path not found"));
                }
                return Future.succeededFuture(pathToJson(optPath.get()));
            })
            .onFailure(err -> logger.error("Error retrieving learning path by slug: {}", slug, err));
    }

    /**
     * Create new learning path (admin)
     */
    public Future<JsonObject> createPath(JsonObject pathData) {
        LearningPath path = new LearningPath();
        path.setName(pathData.getString("name"));
        path.setSlug(pathData.getString("slug"));
        path.setDescription(pathData.getString("description"));
        path.setIcon(pathData.getString("icon"));
        path.setOrderIndex(pathData.getInteger("orderIndex", 0));
        path.setActive(pathData.getBoolean("isActive", true));
        path.setEstimatedHours(pathData.getInteger("estimatedHours"));

        return pathRepository.create(path)
            .map(this::pathToJson)
            .onSuccess(p -> logger.info("Created learning path: {}", p.getString("name")))
            .onFailure(err -> logger.error("Error creating learning path", err));
    }

    /**
     * Update learning path (admin)
     */
    public Future<JsonObject> updatePath(Integer pathId, JsonObject pathData) {
        return pathRepository.findById(pathId)
            .compose(optPath -> {
                if (optPath.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Learning path not found"));
                }
                
                LearningPath path = optPath.get();
                path.setName(pathData.getString("name", path.getName()));
                path.setSlug(pathData.getString("slug", path.getSlug()));
                path.setDescription(pathData.getString("description", path.getDescription()));
                path.setIcon(pathData.getString("icon", path.getIcon()));
                path.setOrderIndex(pathData.getInteger("orderIndex", path.getOrderIndex()));
                path.setActive(pathData.getBoolean("isActive", path.isActive()));
                path.setEstimatedHours(pathData.getInteger("estimatedHours", path.getEstimatedHours()));
                
                return pathRepository.update(path);
            })
            .map(this::pathToJson)
            .onSuccess(p -> logger.info("Updated learning path: {}", pathId))
            .onFailure(err -> logger.error("Error updating learning path: {}", pathId, err));
    }

    /**
     * Delete learning path (admin)
     */
    public Future<Void> deletePath(Integer pathId) {
        return pathRepository.delete(pathId)
            .onSuccess(v -> logger.info("Deleted learning path: {}", pathId))
            .onFailure(err -> logger.error("Error deleting learning path: {}", pathId, err));
    }

    /**
     * Convert LearningPath to JsonObject
     */
    private JsonObject pathToJson(LearningPath path) {
        return new JsonObject()
            .put("id", path.getId())
            .put("name", path.getName())
            .put("slug", path.getSlug())
            .put("description", path.getDescription())
            .put("icon", path.getIcon())
            .put("orderIndex", path.getOrderIndex())
            .put("isActive", path.isActive())
            .put("estimatedHours", path.getEstimatedHours())
            .put("createdAt", path.getCreatedAt() != null ? path.getCreatedAt().toString() : null)
            .put("updatedAt", path.getUpdatedAt() != null ? path.getUpdatedAt().toString() : null);
    }
}

// Made with Bob
