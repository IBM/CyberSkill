package com.cyberskill.handler;

import com.cyberskill.model.Certificate;
import com.cyberskill.service.CertificateService;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Handler for Certificate HTTP requests
 */
public class CertificateHandler {
    private static final Logger logger = LoggerFactory.getLogger(CertificateHandler.class);
    private final CertificateService certificateService;

    public CertificateHandler(CertificateService certificateService) {
        this.certificateService = certificateService;
    }

    // ==================== Public Certificate Endpoints ====================

    /**
     * GET /api/certificates/verify/:certificateNumber - Verify certificate
     */
    public void verifyCertificate(RoutingContext ctx) {
        try {
            String certificateNumber = ctx.pathParam("certificateNumber");

            certificateService.verifyCertificate(certificateNumber)
                    .onSuccess(certOpt -> {
                        if (certOpt.isPresent()) {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(new JsonObject()
                                            .put("valid", true)
                                            .put("certificate", certificateToJson(certOpt.get()))
                                            .encode());
                        } else {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(new JsonObject()
                                            .put("valid", false)
                                            .put("message", "Certificate not found or invalid")
                                            .encode());
                        }
                    })
                    .onFailure(err -> {
                        logger.error("Error verifying certificate", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to verify certificate")
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid certificate number")
                    .encode());
        }
    }

    /**
     * GET /api/certificates/:id - Get certificate by ID
     */
    public void getCertificateById(RoutingContext ctx) {
        try {
            UUID certificateId = UUID.fromString(ctx.pathParam("id"));

            certificateService.getCertificateById(certificateId)
                    .onSuccess(certOpt -> {
                        if (certOpt.isPresent()) {
                            ctx.response()
                                    .putHeader("Content-Type", "application/json")
                                    .end(certificateToJson(certOpt.get()).encode());
                        } else {
                            ctx.response().setStatusCode(404).end(new JsonObject()
                                    .put("error", "Certificate not found")
                                    .encode());
                        }
                    })
                    .onFailure(err -> {
                        logger.error("Error getting certificate", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get certificate")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid certificate ID")
                    .encode());
        }
    }

    // ==================== User Certificate Endpoints ====================

    /**
     * GET /api/user/certificates - Get user's certificates
     */
    public void getUserCertificates(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            certificateService.getUserCertificates(userId)
                    .onSuccess(certificates -> {
                        JsonArray jsonArray = new JsonArray();
                        certificates.forEach(cert -> jsonArray.add(certificateToJson(cert)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("certificates", jsonArray)
                                        .put("count", certificates.size())
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting user certificates", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get certificates")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * GET /api/user/certificates/count - Get user's certificate count
     */
    public void getUserCertificateCount(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));

            certificateService.getUserCertificateCount(userId)
                    .onSuccess(count -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("count", count)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting certificate count", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get certificate count")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid user ID")
                    .encode());
        }
    }

    /**
     * POST /api/certificates/generate - Generate certificate for completed path
     */
    public void generateCertificate(RoutingContext ctx) {
        try {
            UUID userId = UUID.fromString(ctx.user().principal().getString("userId"));
            JsonObject body = ctx.body().asJsonObject();
            
            UUID pathId = UUID.fromString(body.getString("pathId"));
            String userName = body.getString("userName");
            String pathName = body.getString("pathName");

            certificateService.generateCertificate(userId, pathId, userName, pathName)
                    .onSuccess(certificate -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .setStatusCode(201)
                                .end(certificateToJson(certificate).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error generating certificate", err);
                        ctx.response().setStatusCode(400).end(new JsonObject()
                                .put("error", err.getMessage())
                                .encode());
                    });
        } catch (Exception e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid request data")
                    .encode());
        }
    }

    // ==================== Admin Certificate Endpoints ====================

    /**
     * GET /api/admin/certificates/path/:pathId - Get all certificates for a path
     */
    public void getPathCertificates(RoutingContext ctx) {
        try {
            UUID pathId = UUID.fromString(ctx.pathParam("pathId"));

            certificateService.getPathCertificates(pathId)
                    .onSuccess(certificates -> {
                        JsonArray jsonArray = new JsonArray();
                        certificates.forEach(cert -> jsonArray.add(certificateToJson(cert)));
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(jsonArray.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error getting path certificates", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to get certificates")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid path ID")
                    .encode());
        }
    }

    /**
     * POST /api/admin/certificates/revoke/:id - Revoke certificate
     */
    public void revokeCertificate(RoutingContext ctx) {
        try {
            UUID certificateId = UUID.fromString(ctx.pathParam("id"));

            certificateService.revokeCertificate(certificateId)
                    .onSuccess(v -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("message", "Certificate revoked successfully")
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error revoking certificate", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to revoke certificate")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid certificate ID")
                    .encode());
        }
    }

    /**
     * POST /api/admin/certificates/regenerate/:id - Regenerate certificate PDF
     */
    public void regenerateCertificatePdf(RoutingContext ctx) {
        try {
            UUID certificateId = UUID.fromString(ctx.pathParam("id"));

            certificateService.regenerateCertificatePdf(certificateId)
                    .onSuccess(certificate -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(certificateToJson(certificate).encode());
                    })
                    .onFailure(err -> {
                        logger.error("Error regenerating certificate PDF", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to regenerate certificate")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid certificate ID")
                    .encode());
        }
    }

    /**
     * DELETE /api/admin/certificates/:id - Delete certificate
     */
    public void deleteCertificate(RoutingContext ctx) {
        try {
            UUID certificateId = UUID.fromString(ctx.pathParam("id"));

            certificateService.deleteCertificate(certificateId)
                    .onSuccess(v -> {
                        ctx.response().setStatusCode(204).end();
                    })
                    .onFailure(err -> {
                        logger.error("Error deleting certificate", err);
                        ctx.response().setStatusCode(500).end(new JsonObject()
                                .put("error", "Failed to delete certificate")
                                .encode());
                    });
        } catch (IllegalArgumentException e) {
            ctx.response().setStatusCode(400).end(new JsonObject()
                    .put("error", "Invalid certificate ID")
                    .encode());
        }
    }

    /**
     * GET /api/admin/certificates/statistics - Get certificate statistics
     */
    public void getCertificateStatistics(RoutingContext ctx) {
        certificateService.getCertificateStatistics()
                .onSuccess(stats -> {
                    ctx.response()
                            .putHeader("Content-Type", "application/json")
                            .end(stats.encode());
                })
                .onFailure(err -> {
                    logger.error("Error getting certificate statistics", err);
                    ctx.response().setStatusCode(500).end(new JsonObject()
                            .put("error", "Failed to get statistics")
                            .encode());
                });
    }

    // ==================== JSON Conversion Methods ====================

    private JsonObject certificateToJson(Certificate certificate) {
        JsonObject json = new JsonObject()
                .put("id", certificate.getId().toString())
                .put("userId", certificate.getUserId().toString())
                .put("learningPathId", certificate.getLearningPathId().toString())
                .put("certificateNumber", certificate.getCertificateNumber())
                .put("userName", certificate.getUserName())
                .put("pathName", certificate.getPathName())
                .put("issuedAt", certificate.getIssuedAt().toString())
                .put("isValid", certificate.getIsValid());

        if (certificate.getExpiresAt() != null) {
            json.put("expiresAt", certificate.getExpiresAt().toString());
        }
        if (certificate.getPdfUrl() != null) {
            json.put("pdfUrl", certificate.getPdfUrl());
        }

        return json;
    }
}

// Made with Bob
