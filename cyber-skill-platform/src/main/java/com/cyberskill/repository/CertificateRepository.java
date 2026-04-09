package com.cyberskill.repository;

import com.cyberskill.model.Certificate;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository for Certificate database operations
 */
public class CertificateRepository {
    private static final Logger logger = LoggerFactory.getLogger(CertificateRepository.class);
    private final PgPool pool;

    public CertificateRepository(PgPool pool) {
        this.pool = pool;
    }

    public Future<Certificate> createCertificate(Certificate certificate) {
        Promise<Certificate> promise = Promise.promise();
        String sql = "INSERT INTO certificates (id, user_id, learning_path_id, certificate_number, " +
                "user_name, path_name, issued_at, expires_at, pdf_url, is_valid) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        certificate.getId(),
                        certificate.getUserId(),
                        certificate.getLearningPathId(),
                        certificate.getCertificateNumber(),
                        certificate.getUserName(),
                        certificate.getPathName(),
                        certificate.getIssuedAt(),
                        certificate.getExpiresAt(),
                        certificate.getPdfUrl(),
                        certificate.getIsValid()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToCertificate(rows.iterator().next()));
                    } else {
                        promise.fail("Failed to create certificate");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error creating certificate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Certificate>> findCertificateById(UUID id) {
        Promise<Optional<Certificate>> promise = Promise.promise();
        String sql = "SELECT * FROM certificates WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToCertificate(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding certificate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Certificate>> findCertificateByNumber(String certificateNumber) {
        Promise<Optional<Certificate>> promise = Promise.promise();
        String sql = "SELECT * FROM certificates WHERE certificate_number = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(certificateNumber))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToCertificate(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding certificate by number", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Certificate>> findCertificatesByUserId(UUID userId) {
        Promise<List<Certificate>> promise = Promise.promise();
        String sql = "SELECT * FROM certificates WHERE user_id = $1 ORDER BY issued_at DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    List<Certificate> certificates = new ArrayList<>();
                    rows.forEach(row -> certificates.add(mapRowToCertificate(row)));
                    promise.complete(certificates);
                })
                .onFailure(err -> {
                    logger.error("Error finding certificates by user", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Optional<Certificate>> findCertificateByUserAndPath(UUID userId, UUID pathId) {
        Promise<Optional<Certificate>> promise = Promise.promise();
        String sql = "SELECT * FROM certificates WHERE user_id = $1 AND learning_path_id = $2 " +
                "ORDER BY issued_at DESC LIMIT 1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId, pathId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(Optional.of(mapRowToCertificate(rows.iterator().next())));
                    } else {
                        promise.complete(Optional.empty());
                    }
                })
                .onFailure(err -> {
                    logger.error("Error finding certificate by user and path", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<List<Certificate>> findCertificatesByPathId(UUID pathId) {
        Promise<List<Certificate>> promise = Promise.promise();
        String sql = "SELECT * FROM certificates WHERE learning_path_id = $1 ORDER BY issued_at DESC";

        pool.preparedQuery(sql)
                .execute(Tuple.of(pathId))
                .onSuccess(rows -> {
                    List<Certificate> certificates = new ArrayList<>();
                    rows.forEach(row -> certificates.add(mapRowToCertificate(row)));
                    promise.complete(certificates);
                })
                .onFailure(err -> {
                    logger.error("Error finding certificates by path", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> countUserCertificates(UUID userId) {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM certificates WHERE user_id = $1 AND is_valid = true";

        pool.preparedQuery(sql)
                .execute(Tuple.of(userId))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error counting user certificates", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Certificate> updateCertificate(Certificate certificate) {
        Promise<Certificate> promise = Promise.promise();
        String sql = "UPDATE certificates SET pdf_url = $1, expires_at = $2, is_valid = $3 " +
                "WHERE id = $4 RETURNING *";

        pool.preparedQuery(sql)
                .execute(Tuple.of(
                        certificate.getPdfUrl(),
                        certificate.getExpiresAt(),
                        certificate.getIsValid(),
                        certificate.getId()
                ))
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(mapRowToCertificate(rows.iterator().next()));
                    } else {
                        promise.fail("Certificate not found");
                    }
                })
                .onFailure(err -> {
                    logger.error("Error updating certificate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> revokeCertificate(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "UPDATE certificates SET is_valid = false WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error revoking certificate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Void> deleteCertificate(UUID id) {
        Promise<Void> promise = Promise.promise();
        String sql = "DELETE FROM certificates WHERE id = $1";

        pool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> promise.complete())
                .onFailure(err -> {
                    logger.error("Error deleting certificate", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Boolean> hasUserEarnedCertificate(UUID userId, UUID pathId) {
        Promise<Boolean> promise = Promise.promise();
        
        findCertificateByUserAndPath(userId, pathId)
                .onSuccess(cert -> promise.complete(cert.isPresent() && cert.get().getIsValid()))
                .onFailure(promise::fail);

        return promise.future();
    }

    public Future<Integer> getCertificateStatistics() {
        Promise<Integer> promise = Promise.promise();
        String sql = "SELECT COUNT(*) as count FROM certificates WHERE is_valid = true";

        pool.preparedQuery(sql)
                .execute()
                .onSuccess(rows -> {
                    if (rows.iterator().hasNext()) {
                        promise.complete(rows.iterator().next().getInteger("count"));
                    } else {
                        promise.complete(0);
                    }
                })
                .onFailure(err -> {
                    logger.error("Error getting certificate statistics", err);
                    promise.fail(err);
                });

        return promise.future();
    }

    public Future<Integer> countAllCertificates() {
        return getCertificateStatistics();
    }

    private Certificate mapRowToCertificate(Row row) {
        Certificate certificate = new Certificate();
        certificate.setId(row.getUUID("id"));
        certificate.setUserId(row.getUUID("user_id"));
        certificate.setLearningPathId(row.getUUID("learning_path_id"));
        certificate.setCertificateNumber(row.getString("certificate_number"));
        certificate.setUserName(row.getString("user_name"));
        certificate.setPathName(row.getString("path_name"));
        certificate.setIssuedAt(row.getLocalDateTime("issued_at"));
        certificate.setExpiresAt(row.getLocalDateTime("expires_at"));
        certificate.setPdfUrl(row.getString("pdf_url"));
        certificate.setIsValid(row.getBoolean("is_valid"));
        return certificate;
    }
}

// Made with Bob
