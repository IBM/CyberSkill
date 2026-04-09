package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * UserProgress model representing a user's progress on a specific lesson
 */
public class UserProgress {
    private UUID id;
    private UUID userId;
    private UUID lessonId;
    private Boolean completed;
    private Integer timeSpentSeconds; // Time spent on lesson in seconds
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private LocalDateTime lastAccessedAt;

    // Constructors
    public UserProgress() {
        this.id = UUID.randomUUID();
        this.completed = false;
        this.timeSpentSeconds = 0;
        this.startedAt = LocalDateTime.now();
        this.lastAccessedAt = LocalDateTime.now();
    }

    public UserProgress(UUID userId, UUID lessonId) {
        this();
        this.userId = userId;
        this.lessonId = lessonId;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getLessonId() {
        return lessonId;
    }

    public void setLessonId(UUID lessonId) {
        this.lessonId = lessonId;
    }

    public Boolean getCompleted() {
        return completed;
    }

    public void setCompleted(Boolean completed) {
        this.completed = completed;
    }

    public Integer getTimeSpentSeconds() {
        return timeSpentSeconds;
    }

    public void setTimeSpentSeconds(Integer timeSpentSeconds) {
        this.timeSpentSeconds = timeSpentSeconds;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public LocalDateTime getLastAccessedAt() {
        return lastAccessedAt;
    }

    public void setLastAccessedAt(LocalDateTime lastAccessedAt) {
        this.lastAccessedAt = lastAccessedAt;
    }

    @Override
    public String toString() {
        return "UserProgress{" +
                "id=" + id +
                ", userId=" + userId +
                ", lessonId=" + lessonId +
                ", completed=" + completed +
                ", timeSpentSeconds=" + timeSpentSeconds +
                ", completedAt=" + completedAt +
                '}';
    }
}

// Made with Bob
