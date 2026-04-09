package com.cyberskill.service;

import com.cyberskill.model.Module;
import com.cyberskill.repository.ModuleRepository;
import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Service for module management
 */
public class ModuleService {
    private static final Logger logger = LoggerFactory.getLogger(ModuleService.class);
    private final ModuleRepository moduleRepository;

    public ModuleService(ModuleRepository moduleRepository) {
        this.moduleRepository = moduleRepository;
    }

    /**
     * Get all modules for a learning path
     */
    public Future<JsonArray> getModulesByPathId(Integer pathId) {
        return moduleRepository.findByLearningPathId(pathId)
            .map(modules -> {
                JsonArray result = new JsonArray();
                for (Module module : modules) {
                    result.add(moduleToJson(module));
                }
                return result;
            })
            .onSuccess(modules -> logger.debug("Retrieved {} modules for path {}", modules.size(), pathId))
            .onFailure(err -> logger.error("Error retrieving modules for path: {}", pathId, err));
    }

    /**
     * Get module by ID
     */
    public Future<JsonObject> getModuleById(Integer moduleId) {
        return moduleRepository.findById(moduleId)
            .compose(optModule -> {
                if (optModule.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Module not found"));
                }
                return Future.succeededFuture(moduleToJson(optModule.get()));
            })
            .onFailure(err -> logger.error("Error retrieving module: {}", moduleId, err));
    }

    /**
     * Get all modules (admin)
     */
    public Future<JsonArray> getAllModules() {
        return moduleRepository.findAll()
            .map(modules -> {
                JsonArray result = new JsonArray();
                for (Module module : modules) {
                    result.add(moduleToJson(module));
                }
                return result;
            })
            .onSuccess(modules -> logger.debug("Retrieved {} modules", modules.size()))
            .onFailure(err -> logger.error("Error retrieving all modules", err));
    }

    /**
     * Create new module (admin)
     */
    public Future<JsonObject> createModule(JsonObject moduleData) {
        Module module = new Module();
        module.setLearningPathId(moduleData.getInteger("learningPathId"));
        module.setName(moduleData.getString("name"));
        module.setDescription(moduleData.getString("description"));
        module.setOrderIndex(moduleData.getInteger("orderIndex", 0));
        module.setEstimatedHours(moduleData.getInteger("estimatedHours"));

        return moduleRepository.create(module)
            .map(this::moduleToJson)
            .onSuccess(m -> logger.info("Created module: {}", m.getString("name")))
            .onFailure(err -> logger.error("Error creating module", err));
    }

    /**
     * Update module (admin)
     */
    public Future<JsonObject> updateModule(Integer moduleId, JsonObject moduleData) {
        return moduleRepository.findById(moduleId)
            .compose(optModule -> {
                if (optModule.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Module not found"));
                }
                
                Module module = optModule.get();
                module.setName(moduleData.getString("name", module.getName()));
                module.setDescription(moduleData.getString("description", module.getDescription()));
                module.setOrderIndex(moduleData.getInteger("orderIndex", module.getOrderIndex()));
                module.setEstimatedHours(moduleData.getInteger("estimatedHours", module.getEstimatedHours()));
                
                return moduleRepository.update(module);
            })
            .map(this::moduleToJson)
            .onSuccess(m -> logger.info("Updated module: {}", moduleId))
            .onFailure(err -> logger.error("Error updating module: {}", moduleId, err));
    }

    /**
     * Delete module (admin)
     */
    public Future<Void> deleteModule(Integer moduleId) {
        return moduleRepository.delete(moduleId)
            .onSuccess(v -> logger.info("Deleted module: {}", moduleId))
            .onFailure(err -> logger.error("Error deleting module: {}", moduleId, err));
    }

    /**
     * Convert Module to JsonObject
     */
    private JsonObject moduleToJson(Module module) {
        return new JsonObject()
            .put("id", module.getId())
            .put("learningPathId", module.getLearningPathId())
            .put("name", module.getName())
            .put("description", module.getDescription())
            .put("orderIndex", module.getOrderIndex())
            .put("estimatedHours", module.getEstimatedHours())
            .put("createdAt", module.getCreatedAt() != null ? module.getCreatedAt().toString() : null)
            .put("updatedAt", module.getUpdatedAt() != null ? module.getUpdatedAt().toString() : null);
    }
}

// Made with Bob