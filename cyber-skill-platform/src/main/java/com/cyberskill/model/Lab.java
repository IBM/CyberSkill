package com.cyberskill.model;

import io.vertx.core.json.JsonObject;
import java.time.LocalDateTime;

/**
 * Lab model representing hands-on exercises for sections
 */
public class Lab {
    private Integer id;
    private Integer sectionId;
    private String name;
    private String description;
    private Integer estimatedMinutes;
    private String contentSource; // 'text', 'json', or 'markdown'
    private JsonObject labJson; // JSONB lab structure
    private JsonObject metadata; // JSONB metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Lab() {
        this.contentSource = "json";
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Lab(Integer sectionId, String name, String description, Integer estimatedMinutes) {
        this();
        this.sectionId = sectionId;
        this.name = name;
        this.description = description;
        this.estimatedMinutes = estimatedMinutes;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getSectionId() {
        return sectionId;
    }

    public void setSectionId(Integer sectionId) {
        this.sectionId = sectionId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getEstimatedMinutes() {
        return estimatedMinutes;
    }

    public void setEstimatedMinutes(Integer estimatedMinutes) {
        this.estimatedMinutes = estimatedMinutes;
    }

    public String getContentSource() {
        return contentSource;
    }

    public void setContentSource(String contentSource) {
        this.contentSource = contentSource;
    }

    public JsonObject getLabJson() {
        return labJson;
    }

    public void setLabJson(JsonObject labJson) {
        this.labJson = labJson;
    }

    public JsonObject getMetadata() {
        return metadata;
    }

    public void setMetadata(JsonObject metadata) {
        this.metadata = metadata;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Lab{" +
                "id=" + id +
                ", sectionId=" + sectionId +
                ", name='" + name + '\'' +
                ", estimatedMinutes=" + estimatedMinutes +
                ", contentSource='" + contentSource + '\'' +
                '}';
    }
}

// Made with Bob