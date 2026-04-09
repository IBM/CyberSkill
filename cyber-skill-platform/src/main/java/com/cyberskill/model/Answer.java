package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Answer model representing a possible answer to a quiz question
 */
public class Answer {
    private UUID id;
    private UUID questionId;
    private String answerText;
    private Boolean isCorrect;
    private Integer orderIndex; // Display order in question
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Answer() {
        this.id = UUID.randomUUID();
        this.isCorrect = false;
        this.orderIndex = 0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Answer(UUID questionId, String answerText, Boolean isCorrect) {
        this();
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getQuestionId() {
        return questionId;
    }

    public void setQuestionId(UUID questionId) {
        this.questionId = questionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public Boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(Boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
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
        return "Answer{" +
                "id=" + id +
                ", questionId=" + questionId +
                ", answerText='" + answerText + '\'' +
                ", isCorrect=" + isCorrect +
                ", orderIndex=" + orderIndex +
                '}';
    }
}

// Made with Bob
