package com.cyberskill.service;

import com.cyberskill.model.Section;
import com.cyberskill.repository.SectionRepository;
import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Service for section management
 */
public class SectionService {
    private static final Logger logger = LoggerFactory.getLogger(SectionService.class);
    private final SectionRepository sectionRepository;

    public SectionService(SectionRepository sectionRepository) {
        this.sectionRepository = sectionRepository;
    }

    /**
     * Get all sections for a module
     */
    public Future<JsonArray> getSectionsByModuleId(Integer moduleId) {
        return sectionRepository.findByModuleId(moduleId)
            .map(sections -> {
                JsonArray result = new JsonArray();
                for (Section section : sections) {
                    result.add(sectionToJson(section));
                }
                return result;
            })
            .onSuccess(sections -> logger.debug("Retrieved {} sections for module {}", sections.size(), moduleId))
            .onFailure(err -> logger.error("Error retrieving sections for module: {}", moduleId, err));
    }

    /**
     * Get section by ID
     */
    public Future<JsonObject> getSectionById(Integer sectionId) {
        return sectionRepository.findById(sectionId)
            .compose(optSection -> {
                if (optSection.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Section not found"));
                }
                return Future.succeededFuture(sectionToJson(optSection.get()));
            })
            .onFailure(err -> logger.error("Error retrieving section: {}", sectionId, err));
    }

    /**
     * Get all sections (admin)
     */
    public Future<JsonArray> getAllSections() {
        return sectionRepository.findAll()
            .map(sections -> {
                JsonArray result = new JsonArray();
                for (Section section : sections) {
                    result.add(sectionToJson(section));
                }
                return result;
            })
            .onSuccess(sections -> logger.debug("Retrieved {} sections", sections.size()))
            .onFailure(err -> logger.error("Error retrieving all sections", err));
    }

    /**
     * Create new section (admin)
     */
    public Future<JsonObject> createSection(JsonObject sectionData) {
        Section section = new Section();
        section.setModuleId(sectionData.getInteger("moduleId"));
        section.setName(sectionData.getString("name"));
        section.setDescription(sectionData.getString("description"));
        section.setOrderIndex(sectionData.getInteger("orderIndex", 0));

        return sectionRepository.create(section)
            .map(this::sectionToJson)
            .onSuccess(s -> logger.info("Created section: {}", s.getString("name")))
            .onFailure(err -> logger.error("Error creating section", err));
    }

    /**
     * Update section (admin)
     */
    public Future<JsonObject> updateSection(Integer sectionId, JsonObject sectionData) {
        return sectionRepository.findById(sectionId)
            .compose(optSection -> {
                if (optSection.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Section not found"));
                }
                
                Section section = optSection.get();
                section.setName(sectionData.getString("name", section.getName()));
                section.setDescription(sectionData.getString("description", section.getDescription()));
                section.setOrderIndex(sectionData.getInteger("orderIndex", section.getOrderIndex()));
                
                return sectionRepository.update(section);
            })
            .map(this::sectionToJson)
            .onSuccess(s -> logger.info("Updated section: {}", sectionId))
            .onFailure(err -> logger.error("Error updating section: {}", sectionId, err));
    }

    /**
     * Delete section (admin)
     */
    public Future<Void> deleteSection(Integer sectionId) {
        return sectionRepository.delete(sectionId)
            .onSuccess(v -> logger.info("Deleted section: {}", sectionId))
            .onFailure(err -> logger.error("Error deleting section: {}", sectionId, err));
    }

    /**
     * Convert Section to JsonObject
     */
    private JsonObject sectionToJson(Section section) {
        return new JsonObject()
            .put("id", section.getId())
            .put("moduleId", section.getModuleId())
            .put("name", section.getName())
            .put("description", section.getDescription())
            .put("orderIndex", section.getOrderIndex())
            .put("createdAt", section.getCreatedAt() != null ? section.getCreatedAt().toString() : null)
            .put("updatedAt", section.getUpdatedAt() != null ? section.getUpdatedAt().toString() : null);
    }
}

// Made with Bob