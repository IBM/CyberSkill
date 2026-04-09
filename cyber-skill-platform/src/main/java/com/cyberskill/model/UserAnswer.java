package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * UserAnswer model representing a user's answer to a specific question in a quiz attempt
 */
public class UserAnswer {
    private UUID id;
    private UUID attemptId;
    private UUID questionId;
    private UUID answerId; // For multiple choice/select questions
    private String answerText; // For short answer questions (future)
    private Boolean isCorrect;
    private Integer pointsEarned;
    private LocalDateTime answeredAt;

    // Constructors
    public UserAnswer() {
        this.id = UUID.randomUUID();
        this.isCorrect = false;
        this.pointsEarned = 0;
        this.answeredAt = LocalDateTime.now();
    }

    public UserAnswer(UUID attemptId, UUID questionId, UUID answerId) {
        this();
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.answerId = answerId;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(UUID attemptId) {
        this.attemptId = attemptId;
    }

    public UUID getQuestionId() {
        return questionId;
    }

    public void setQuestionId(UUID questionId) {
        this.questionId = questionId;
    }

    public UUID getAnswerId() {
        return answerId;
    }

    public void setAnswerId(UUID answerId) {
        this.answerId = answerId;
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

    public Integer getPointsEarned() {
        return pointsEarned;
    }

    public void setPointsEarned(Integer pointsEarned) {
        this.pointsEarned = pointsEarned;
    }

    public LocalDateTime getAnsweredAt() {
        return answeredAt;
    }

    public void setAnsweredAt(LocalDateTime answeredAt) {
        this.answeredAt = answeredAt;
    }

    @Override
    public String toString() {
        return "UserAnswer{" +
                "id=" + id +
                ", attemptId=" + attemptId +
                ", questionId=" + questionId +
                ", answerId=" + answerId +
                ", isCorrect=" + isCorrect +
                ", pointsEarned=" + pointsEarned +
                '}';
    }
}

// Made with Bob
