package com.cyberskill.model;

import java.time.LocalDateTime;

/**
 * Lesson entity - represents a lesson within a section
 */
public class Lesson {
    private Integer id;
    private Integer sectionId;
    private String name;
    private String content;
    private ContentType contentType;
    private String videoUrl;
    private Integer orderIndex;
    private Integer estimatedMinutes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Lesson() {
        this.contentType = ContentType.TEXT;
    }

    public Lesson(Integer sectionId, String name, String content) {
        this();
        this.sectionId = sectionId;
        this.name = name;
        this.content = content;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public ContentType getContentType() {
        return contentType;
    }

    public void setContentType(ContentType contentType) {
        this.contentType = contentType;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public Integer getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(Integer orderIndex) {
        this.orderIndex = orderIndex;
    }

    public Integer getEstimatedMinutes() {
        return estimatedMinutes;
    }

    public void setEstimatedMinutes(Integer estimatedMinutes) {
        this.estimatedMinutes = estimatedMinutes;
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
        return "Lesson{" +
                "id=" + id +
                ", sectionId=" + sectionId +
                ", name='" + name + '\'' +
                ", contentType=" + contentType +
                ", orderIndex=" + orderIndex +
                '}';
    }

    /**
     * Content type enumeration
     */
    public enum ContentType {
        TEXT("text"),
        VIDEO("video"),
        INTERACTIVE("interactive"),
        PDF("pdf");

        private final String value;

        ContentType(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }

        public static ContentType fromString(String value) {
            for (ContentType type : ContentType.values()) {
                if (type.value.equalsIgnoreCase(value)) {
                    return type;
                }
            }
            return TEXT;
        }

        @Override
        public String toString() {
            return value;
        }
    }
}

// Made with Bob
