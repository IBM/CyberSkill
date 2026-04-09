package com.cyberskill.service;

import com.cyberskill.model.Certificate;
import com.cyberskill.repository.CertificateRepository;
import com.cyberskill.repository.ProgressRepository;
import com.cyberskill.util.PdfCertificateGenerator;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Service layer for Certificate business logic
 */
public class CertificateService {
    private static final Logger logger = LoggerFactory.getLogger(CertificateService.class);
    private final CertificateRepository certificateRepository;
    private final ProgressRepository progressRepository;

    public CertificateService(CertificateRepository certificateRepository, ProgressRepository progressRepository) {
        this.certificateRepository = certificateRepository;
        this.progressRepository = progressRepository;
    }

    // ==================== Certificate CRUD Operations ====================

    public Future<Certificate> createCertificate(Certificate certificate) {
        return certificateRepository.createCertificate(certificate);
    }

    public Future<Optional<Certificate>> getCertificateById(UUID id) {
        return certificateRepository.findCertificateById(id);
    }

    public Future<Optional<Certificate>> getCertificateByNumber(String certificateNumber) {
        return certificateRepository.findCertificateByNumber(certificateNumber);
    }

    public Future<List<Certificate>> getUserCertificates(UUID userId) {
        return certificateRepository.findCertificatesByUserId(userId);
    }

    public Future<List<Certificate>> getPathCertificates(UUID pathId) {
        return certificateRepository.findCertificatesByPathId(pathId);
    }

    public Future<Integer> getUserCertificateCount(UUID userId) {
        return certificateRepository.countUserCertificates(userId);
    }

    public Future<Certificate> updateCertificate(Certificate certificate) {
        return certificateRepository.updateCertificate(certificate);
    }

    public Future<Void> revokeCertificate(UUID id) {
        return certificateRepository.revokeCertificate(id);
    }

    public Future<Void> deleteCertificate(UUID id) {
        return certificateRepository.deleteCertificate(id);
    }

    public Future<Boolean> hasUserEarnedCertificate(UUID userId, UUID pathId) {
        return certificateRepository.hasUserEarnedCertificate(userId, pathId);
    }

    // ==================== Certificate Generation ====================

    /**
     * Generate certificate for learning path completion
     */
    public Future<Certificate> generateCertificate(UUID userId, UUID pathId, String userName, String pathName) {
        Promise<Certificate> promise = Promise.promise();

        // Check if user has already earned certificate
        certificateRepository.findCertificateByUserAndPath(userId, pathId)
                .compose(existingCert -> {
                    if (existingCert.isPresent() && existingCert.get().getIsValid()) {
                        // Certificate already exists
                        return Future.succeededFuture(existingCert.get());
                    }

                    // Verify path completion
                    return verifyPathCompletion(userId, pathId)
                            .compose(isCompleted -> {
                                if (!isCompleted) {
                                    return Future.failedFuture("Learning path not completed");
                                }

                                // Create certificate
                                Certificate certificate = new Certificate(userId, pathId, userName, pathName);
                                
                                return certificateRepository.createCertificate(certificate)
                                        .compose(createdCert -> {
                                            // Generate PDF
                                            return generateCertificatePdf(createdCert)
                                                    .compose(pdfUrl -> {
                                                        createdCert.setPdfUrl(pdfUrl);
                                                        return certificateRepository.updateCertificate(createdCert);
                                                    });
                                        });
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Verify that user has completed all lessons in the learning path
     */
    private Future<Boolean> verifyPathCompletion(UUID userId, UUID pathId) {
        Promise<Boolean> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInPath(userId, pathId),
                progressRepository.countLessonsInPath(pathId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            promise.complete(total > 0 && completed == total);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Generate PDF certificate using iText library
     */
    private Future<String> generateCertificatePdf(Certificate certificate) {
        Promise<String> promise = Promise.promise();

        try {
            // Create certificates directory if it doesn't exist
            Path certificatesDir = Paths.get("certificates");
            if (!Files.exists(certificatesDir)) {
                Files.createDirectories(certificatesDir);
            }
            
            // Generate PDF file path
            String fileName = certificate.getCertificateNumber() + ".pdf";
            String filePath = certificatesDir.resolve(fileName).toString();
            
            // Generate PDF using PdfCertificateGenerator
            byte[] pdfBytes = PdfCertificateGenerator.generateCertificate(
                    certificate.getUserName(),
                    certificate.getPathName(),
                    certificate.getCertificateNumber(),
                    certificate.getIssuedAt()
            );
            
            // Save PDF to file
            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(pdfBytes);
            }
            
            // Return URL path
            String pdfUrl = "/certificates/" + fileName;
            logger.info("Certificate PDF generated and saved: {}", pdfUrl);
            promise.complete(pdfUrl);
            
        } catch (Exception e) {
            logger.error("Error generating certificate PDF", e);
            // Return placeholder URL on error
            promise.complete("/certificates/" + certificate.getCertificateNumber() + ".pdf");
        }

        return promise.future();
    }

    /**
     * Regenerate PDF for existing certificate
     */
    public Future<Certificate> regenerateCertificatePdf(UUID certificateId) {
        Promise<Certificate> promise = Promise.promise();

        getCertificateById(certificateId)
                .compose(certOpt -> {
                    if (certOpt.isEmpty()) {
                        return Future.failedFuture("Certificate not found");
                    }
                    
                    Certificate certificate = certOpt.get();
                    return generateCertificatePdf(certificate)
                            .compose(pdfUrl -> {
                                certificate.setPdfUrl(pdfUrl);
                                return certificateRepository.updateCertificate(certificate);
                            });
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get certificate statistics
     */
    public Future<JsonObject> getCertificateStatistics() {
        return certificateRepository.getCertificateStatistics()
                .map(count -> new JsonObject().put("totalCertificates", count));
    }

    /**
     * Verify certificate by certificate number
     */
    public Future<Optional<Certificate>> verifyCertificate(String certificateNumber) {
        return certificateRepository.findCertificateByNumber(certificateNumber)
                .compose(certOpt -> {
                    if (certOpt.isPresent() && certOpt.get().getIsValid()) {
                        return Future.succeededFuture(certOpt);
                    }
                    return Future.succeededFuture(Optional.empty());
                });
    }
}

// Made with Bob
