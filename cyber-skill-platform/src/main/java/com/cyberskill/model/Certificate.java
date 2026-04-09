package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Certificate model representing a completion certificate
 */
public class Certificate {
    private UUID id;
    private UUID userId;
    private UUID learningPathId;
    private String certificateNumber; // Unique certificate identifier
    private String userName;
    private String pathName;
    private LocalDateTime issuedAt;
    private LocalDateTime expiresAt; // Optional expiration date
    private String pdfUrl; // URL to generated PDF certificate
    private Boolean isValid;

    // Constructors
    public Certificate() {
        this.id = UUID.randomUUID();
        this.issuedAt = LocalDateTime.now();
        this.isValid = true;
    }

    public Certificate(UUID userId, UUID learningPathId, String userName, String pathName) {
        this();
        this.userId = userId;
        this.learningPathId = learningPathId;
        this.userName = userName;
        this.pathName = pathName;
        this.certificateNumber = generateCertificateNumber();
    }

    // Generate unique certificate number
    private String generateCertificateNumber() {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String randomPart = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return "CERT-" + timestamp.substring(timestamp.length() - 8) + "-" + randomPart;
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

    public UUID getLearningPathId() {
        return learningPathId;
    }

    public void setLearningPathId(UUID learningPathId) {
        this.learningPathId = learningPathId;
    }

    public String getCertificateNumber() {
        return certificateNumber;
    }

    public void setCertificateNumber(String certificateNumber) {
        this.certificateNumber = certificateNumber;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPathName() {
        return pathName;
    }

    public void setPathName(String pathName) {
        this.pathName = pathName;
    }

    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public String getPdfUrl() {
        return pdfUrl;
    }

    public void setPdfUrl(String pdfUrl) {
        this.pdfUrl = pdfUrl;
    }

    public Boolean getIsValid() {
        return isValid;
    }

    public void setIsValid(Boolean isValid) {
        this.isValid = isValid;
    }

    @Override
    public String toString() {
        return "Certificate{" +
                "id=" + id +
                ", certificateNumber='" + certificateNumber + '\'' +
                ", userName='" + userName + '\'' +
                ", pathName='" + pathName + '\'' +
                ", issuedAt=" + issuedAt +
                ", isValid=" + isValid +
                '}';
    }
}

// Made with Bob
