package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * QuizAttempt model representing a user's attempt at taking a quiz
 */
public class QuizAttempt {
    private UUID id;
    private UUID userId;
    private UUID quizId;
    private Integer score; // Percentage score (0-100)
    private Integer totalPoints; // Total points earned
    private Integer maxPoints; // Maximum possible points
    private Boolean passed; // Whether the attempt passed
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private Integer attemptNumber; // Which attempt this is (1, 2, 3, etc.)

    // Constructors
    public QuizAttempt() {
        this.id = UUID.randomUUID();
        this.startedAt = LocalDateTime.now();
        this.passed = false;
        this.attemptNumber = 1;
    }

    public QuizAttempt(UUID userId, UUID quizId, Integer attemptNumber) {
        this();
        this.userId = userId;
        this.quizId = quizId;
        this.attemptNumber = attemptNumber;
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

    public UUID getQuizId() {
        return quizId;
    }

    public void setQuizId(UUID quizId) {
        this.quizId = quizId;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public Integer getMaxPoints() {
        return maxPoints;
    }

    public void setMaxPoints(Integer maxPoints) {
        this.maxPoints = maxPoints;
    }

    public Boolean getPassed() {
        return passed;
    }

    public void setPassed(Boolean passed) {
        this.passed = passed;
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

    public Integer getAttemptNumber() {
        return attemptNumber;
    }

    public void setAttemptNumber(Integer attemptNumber) {
        this.attemptNumber = attemptNumber;
    }

    @Override
    public String toString() {
        return "QuizAttempt{" +
                "id=" + id +
                ", userId=" + userId +
                ", quizId=" + quizId +
                ", score=" + score +
                ", passed=" + passed +
                ", attemptNumber=" + attemptNumber +
                ", completedAt=" + completedAt +
                '}';
    }
}

// Made with Bob
