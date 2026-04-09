package com.cyberskill.model;

import java.time.LocalDateTime;

/**
 * Module entity - represents a module within a learning path
 */
public class Module {
    private Integer id;
    private Integer learningPathId;
    private String name;
    private String description;
    private Integer orderIndex;
    private Integer estimatedHours;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Module() {
    }

    public Module(Integer learningPathId, String name, String description) {
        this.learningPathId = learningPathId;
        this.name = name;
        this.description = description;
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getLearningPathId() {
        return learningPathId;
    }

    public void setLearningPathId(Integer learningPathId) {
        this.learningPathId = learningPathId;
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

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public Integer getEstimatedHours() {
        return estimatedHours;
    }

    public void setEstimatedHours(Integer estimatedHours) {
        this.estimatedHours = estimatedHours;
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
        return "Module{" +
                "id=" + id +
                ", learningPathId=" + learningPathId +
                ", name='" + name + '\'' +
                ", orderIndex=" + orderIndex +
                '}';
    }
}

// Made with Bob
