package com.cyberskill.model;

import io.vertx.core.json.JsonObject;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Quiz model representing an assessment at the end of a section
 * Supports both relational (quiz_questions + quiz_options) and JSONB formats
 */
public class Quiz {
    private UUID id;
    private UUID sectionId;
    private String title;
    private String description;
    private Integer passingScore; // Percentage required to pass (e.g., 70)
    private Integer timeLimit; // Time limit in minutes (null = no limit)
    private Integer maxAttempts; // Maximum attempts allowed (null = unlimited)
    private Boolean isActive;
    private String contentSource; // 'relational' or 'json'
    private JsonObject quizJson; // JSONB quiz structure
    private JsonObject metadata; // JSONB metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Quiz() {
        this.id = UUID.randomUUID();
        this.isActive = true;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Quiz(UUID sectionId, String title, String description, Integer passingScore) {
        this();
        this.sectionId = sectionId;
        this.title = title;
        this.description = description;
        this.passingScore = passingScore;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getSectionId() {
        return sectionId;
    }

    public void setSectionId(UUID sectionId) {
        this.sectionId = sectionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getPassingScore() {
        return passingScore;
    }

    public void setPassingScore(Integer passingScore) {
        this.passingScore = passingScore;
    }

    public Integer getTimeLimit() {
        return timeLimit;
    }

    public void setTimeLimit(Integer timeLimit) {
        this.timeLimit = timeLimit;
    }

    public Integer getMaxAttempts() {
        return maxAttempts;
    }

    public void setMaxAttempts(Integer maxAttempts) {
        this.maxAttempts = maxAttempts;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
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

    public String getContentSource() {
        return contentSource;
    }

    public void setContentSource(String contentSource) {
        this.contentSource = contentSource;
    }

    public JsonObject getQuizJson() {
        return quizJson;
    }

    public void setQuizJson(JsonObject quizJson) {
        this.quizJson = quizJson;
    }

    public JsonObject getMetadata() {
        return metadata;
    }

    public void setMetadata(JsonObject metadata) {
        this.metadata = metadata;
    }

    @Override
    public String toString() {
        return "Quiz{" +
                "id=" + id +
                ", sectionId=" + sectionId +
                ", title='" + title + '\'' +
                ", passingScore=" + passingScore +
                ", timeLimit=" + timeLimit +
                ", maxAttempts=" + maxAttempts +
                ", isActive=" + isActive +
                ", contentSource='" + contentSource + '\'' +
                '}';
    }
}

// Made with Bob
