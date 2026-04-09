package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Question model representing a quiz question
 */
public class Question {
    private UUID id;
    private UUID quizId;
    private String questionText;
    private QuestionType questionType;
    private Integer points; // Points awarded for correct answer
    private Integer orderIndex; // Display order in quiz
    private String explanation; // Explanation shown after answering
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Question() {
        this.id = UUID.randomUUID();
        this.questionType = QuestionType.MULTIPLE_CHOICE;
        this.points = 1;
        this.orderIndex = 0;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Question(UUID quizId, String questionText, QuestionType questionType) {
        this();
        this.quizId = quizId;
        this.questionText = questionText;
        this.questionType = questionType;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getQuizId() {
        return quizId;
    }

    public void setQuizId(UUID quizId) {
        this.quizId = quizId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public QuestionType getQuestionType() {
        return questionType;
    }

    public void setQuestionType(QuestionType questionType) {
        this.questionType = questionType;
    }

    public Integer getPoints() {
        return points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
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
        return "Question{" +
                "id=" + id +
                ", quizId=" + quizId +
                ", questionText='" + questionText + '\'' +
                ", questionType=" + questionType +
                ", points=" + points +
                ", orderIndex=" + orderIndex +
                '}';
    }
}

// Made with Bob
