package com.pqc.scanner;

import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

public class ApiHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(ApiHandler.class);
    private final Vertx vertx;
    private final PgPool pgPool;
    private final DomainScanner domainScanner;
    
    public ApiHandler(Vertx vertx, PgPool pgPool, DomainScanner domainScanner) {
        this.vertx = vertx;
        this.pgPool = pgPool;
        this.domainScanner = domainScanner;
    }
    
    public void health(RoutingContext ctx) {
        JsonObject response = new JsonObject()
            .put("status", "healthy")
            .put("timestamp", System.currentTimeMillis());
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(response.encode());
    }
    
    public void getStats(RoutingContext ctx) {
        String sql = "SELECT * FROM dashboard_stats";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                if (rows.size() > 0) {
                    Row row = rows.iterator().next();
                    JsonObject stats = new JsonObject()
                        .put("total_domains", row.getInteger("total_domains"))
                        .put("pqc_ready_domains", row.getInteger("pqc_ready_domains"))
                        .put("vulnerable_domains", row.getInteger("vulnerable_domains"))
                        .put("avg_response_time", row.getDouble("avg_response_time"))
                        .put("total_scans", row.getInteger("total_scans"))
                        .put("avg_risk_score", row.getDouble("avg_risk_score"))
                        .put("critical_domains", row.getInteger("critical_domains"))
                        .put("high_risk_domains", row.getInteger("high_risk_domains"))
                        .put("domains_with_chain_issues", row.getInteger("domains_with_chain_issues"));
                    
                    ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(stats.encode());
                } else {
                    ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject().encode());
                }
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getDomains(RoutingContext ctx) {
        String sql = "SELECT d.*, " +
            "(SELECT COUNT(*) FROM scan_results WHERE domain_id = d.id) as scan_count, " +
            "(SELECT is_pqc_ready FROM scan_results WHERE domain_id = d.id ORDER BY scan_date DESC LIMIT 1) as is_pqc_ready " +
            "FROM domains d ORDER BY d.domain_name";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray domains = new JsonArray();
                rows.forEach(row -> {
                    JsonObject domain = new JsonObject()
                        .put("id", row.getInteger("id"))
                        .put("domain_name", row.getString("domain_name"))
                        .put("created_at", row.getLocalDateTime("created_at").toString())
                        .put("last_scanned", row.getLocalDateTime("last_scanned") != null ? 
                            row.getLocalDateTime("last_scanned").toString() : null)
                        .put("scan_count", row.getInteger("scan_count"))
                        .put("is_pqc_ready", row.getBoolean("is_pqc_ready"));
                    domains.add(domain);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(domains.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void addDomain(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String domain = body.getString("domain");
        
        if (domain == null || domain.trim().isEmpty()) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject().put("error", "Domain name is required").encode());
            return;
        }
        
        String sql = "INSERT INTO domains (domain_name) VALUES ($1) " +
            "ON CONFLICT (domain_name) DO NOTHING RETURNING id";
        
        pgPool.preparedQuery(sql)
            .execute(Tuple.of(domain.trim()))
            .onSuccess(rows -> {
                if (rows.size() > 0) {
                    JsonObject response = new JsonObject()
                        .put("success", true)
                        .put("id", rows.iterator().next().getInteger("id"))
                        .put("domain", domain);
                    
                    ctx.response()
                        .setStatusCode(201)
                        .putHeader("Content-Type", "application/json")
                        .end(response.encode());
                } else {
                    ctx.response()
                        .setStatusCode(409)
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject().put("error", "Domain already exists").encode());
                }
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void deleteDomain(RoutingContext ctx) {
        String idParam = ctx.pathParam("id");
        
        try {
            int id = Integer.parseInt(idParam);
            String sql = "DELETE FROM domains WHERE id = $1";
            
            pgPool.preparedQuery(sql)
                .execute(Tuple.of(id))
                .onSuccess(rows -> {
                    ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject().put("success", true).encode());
                })
                .onFailure(err -> handleError(ctx, err));
        } catch (NumberFormatException e) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject().put("error", "Invalid domain ID").encode());
        }
    }
    
    public void scanDomain(RoutingContext ctx) {
        String domain = ctx.pathParam("domain");
        
        domainScanner.scanDomain(domain)
            .onSuccess(result -> {
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(result.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void scanBatch(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        JsonArray domains = body.getJsonArray("domains");
        
        if (domains == null || domains.isEmpty()) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject().put("error", "Domains array is required").encode());
            return;
        }
        
        List<Future<JsonObject>> futures = new ArrayList<>();
        domains.forEach(domain -> {
            futures.add(domainScanner.scanDomain(domain.toString()));
        });
        
        Future.all(futures)
            .onSuccess(composite -> {
                JsonArray results = new JsonArray();
                composite.list().forEach(result -> results.add(result));
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("success", true)
                        .put("results", results)
                        .encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getResults(RoutingContext ctx) {
        String limit = ctx.request().getParam("limit");
        int limitValue = limit != null ? Integer.parseInt(limit) : 100;
        
        String sql = "SELECT * FROM recent_scans LIMIT $1";
        
        pgPool.preparedQuery(sql)
            .execute(Tuple.of(limitValue))
            .onSuccess(rows -> {
                JsonArray results = new JsonArray();
                rows.forEach(row -> {
                    JsonObject result = new JsonObject()
                        .put("domain_name", row.getString("domain_name"))
                        .put("scan_date", row.getLocalDateTime("scan_date").toString())
                        .put("is_pqc_ready", row.getBoolean("is_pqc_ready"))
                        .put("supports_tls_13", row.getBoolean("supports_tls_13"))
                        .put("certificate_valid", row.getBoolean("certificate_valid"))
                        .put("certificate_expiry", row.getLocalDateTime("certificate_expiry") != null ?
                            row.getLocalDateTime("certificate_expiry").toString() : null)
                        .put("days_until_vulnerable", row.getInteger("days_until_vulnerable"))
                        .put("key_exchange_algorithm", row.getString("key_exchange_algorithm"))
                        .put("signature_algorithm", row.getString("signature_algorithm"))
                        .put("public_key_algorithm", row.getString("public_key_algorithm"))
                        .put("public_key_size", row.getInteger("public_key_size"))
                        .put("is_quantum_safe", row.getBoolean("is_quantum_safe"))
                        .put("pqc_algorithm_type", row.getString("pqc_algorithm_type"))
                        .put("risk_score", row.getInteger("risk_score"))
                        .put("risk_level", row.getString("risk_level"));
                    results.add(result);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(results.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getDomainResults(RoutingContext ctx) {
        String domain = ctx.pathParam("domain");
        
        String sql = "SELECT sr.*, cd.* FROM scan_results sr " +
            "LEFT JOIN certificate_details cd ON sr.id = cd.scan_result_id " +
            "WHERE sr.domain_id = (SELECT id FROM domains WHERE domain_name = $1) " +
            "ORDER BY sr.scan_date DESC LIMIT 10";
        
        pgPool.preparedQuery(sql)
            .execute(Tuple.of(domain))
            .onSuccess(rows -> {
                JsonArray results = new JsonArray();
                rows.forEach(row -> {
                    JsonObject result = rowToJson(row);
                    results.add(result);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(results.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getCertificateDetails(RoutingContext ctx) {
        String domain = ctx.pathParam("domain");
        
        String sql = "SELECT cd.* FROM certificate_details cd " +
            "JOIN scan_results sr ON cd.scan_result_id = sr.id " +
            "WHERE sr.domain_id = (SELECT id FROM domains WHERE domain_name = $1) " +
            "ORDER BY sr.scan_date DESC LIMIT 1";
        
        pgPool.preparedQuery(sql)
            .execute(Tuple.of(domain))
            .onSuccess(rows -> {
                if (rows.size() > 0) {
                    JsonObject cert = rowToJson(rows.iterator().next());
                    ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(cert.encode());
                } else {
                    ctx.response()
                        .setStatusCode(404)
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject().put("error", "Certificate not found").encode());
                }
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getTimeline(RoutingContext ctx) {
        String sql = "SELECT DATE(scan_date) as date, " +
            "COUNT(*) as total_scans, " +
            "SUM(CASE WHEN is_pqc_ready THEN 1 ELSE 0 END) as pqc_ready, " +
            "SUM(CASE WHEN NOT is_pqc_ready THEN 1 ELSE 0 END) as vulnerable " +
            "FROM scan_results " +
            "WHERE scan_date >= CURRENT_DATE - INTERVAL '30 days' " +
            "GROUP BY DATE(scan_date) " +
            "ORDER BY date DESC";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray timeline = new JsonArray();
                rows.forEach(row -> {
                    JsonObject point = new JsonObject()
                        .put("date", row.getLocalDate("date").toString())
                        .put("total_scans", row.getInteger("total_scans"))
                        .put("pqc_ready", row.getLong("pqc_ready"))
                        .put("vulnerable", row.getLong("vulnerable"));
                    timeline.add(point);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(timeline.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    public void getVulnerabilityWindow(RoutingContext ctx) {
        String sql = "SELECT vulnerability_window, COUNT(*) as count FROM (" +
            "  SELECT " +
            "    CASE " +
            "      WHEN days_until_vulnerable < 0 THEN 'Not Vulnerable' " +
            "      WHEN days_until_vulnerable < 365 THEN '< 1 year' " +
            "      WHEN days_until_vulnerable < 730 THEN '1-2 years' " +
            "      WHEN days_until_vulnerable < 1095 THEN '2-3 years' " +
            "      ELSE '> 3 years' " +
            "    END as vulnerability_window, " +
            "    CASE " +
            "      WHEN days_until_vulnerable < 0 THEN 1 " +
            "      WHEN days_until_vulnerable > 1095 THEN 2 " +
            "      WHEN days_until_vulnerable >= 730 THEN 3 " +
            "      WHEN days_until_vulnerable >= 365 THEN 4 " +
            "      ELSE 5 " +
            "    END as sort_order " +
            "  FROM scan_results " +
            "  WHERE id IN (SELECT MAX(id) FROM scan_results GROUP BY domain_id) " +
            "  AND days_until_vulnerable IS NOT NULL" +
            ") subquery " +
            "GROUP BY vulnerability_window, sort_order " +
            "ORDER BY sort_order";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray windows = new JsonArray();
                if (rows.size() > 0) {
                    rows.forEach(row -> {
                        JsonObject window = new JsonObject()
                            .put("window", row.getString("vulnerability_window"))
                            .put("count", row.getLong("count"));
                        windows.add(window);
                    });
                }
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(windows.encode());
            })
            .onFailure(err -> {
                logger.error("Error in getVulnerabilityWindow: {}", err.getMessage(), err);
                // Return empty array on error instead of error object
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonArray().encode());
            });
    }
    
    /**
     * Get risk distribution across all domains
     */
    public void getRiskDistribution(RoutingContext ctx) {
        String sql = "SELECT * FROM risk_distribution";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray distribution = new JsonArray();
                rows.forEach(row -> {
                    JsonObject risk = new JsonObject()
                        .put("risk_level", row.getString("risk_level"))
                        .put("count", row.getLong("domain_count"))  // Frontend expects "count"
                        .put("domain_count", row.getLong("domain_count"))  // Keep for compatibility
                        .put("avg_score", row.getDouble("avg_score"))
                        .put("min_score", row.getInteger("min_score"))
                        .put("max_score", row.getInteger("max_score"))
                        .put("color", RiskCalculator.getRiskColor(row.getString("risk_level")));
                    distribution.add(risk);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(distribution.encode());
            })
            .onFailure(err -> {
                logger.error("Error getting risk distribution: {}", err.getMessage());
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonArray().encode());
            });
    }
    
    /**
     * Get trend data for the last 30 days
     */
    public void getTrends(RoutingContext ctx) {
        String days = ctx.request().getParam("days");
        int daysValue = days != null ? Integer.parseInt(days) : 30;
        
        String sql = "SELECT " +
            "DATE_TRUNC('day', sr.scan_date) as scan_day, " +
            "COUNT(DISTINCT sr.domain_id) as domains_scanned, " +
            "COUNT(DISTINCT CASE WHEN sr.is_pqc_ready THEN sr.domain_id END) as pqc_ready_count, " +
            "AVG(sr.risk_score) as avg_risk_score, " +
            "COUNT(DISTINCT CASE WHEN sr.risk_level = 'CRITICAL' THEN sr.domain_id END) as critical_count, " +
            "COUNT(DISTINCT CASE WHEN sr.risk_level = 'HIGH' THEN sr.domain_id END) as high_risk_count, " +
            "AVG(sr.days_until_vulnerable) as avg_days_until_vulnerable, " +
            "COUNT(DISTINCT CASE WHEN sr.supports_tls_13 THEN sr.domain_id END) as tls13_count " +
            "FROM scan_results sr " +
            "WHERE sr.scan_date >= CURRENT_DATE - INTERVAL '" + daysValue + " days' " +
            "GROUP BY DATE_TRUNC('day', sr.scan_date) " +
            "ORDER BY scan_day ASC";
        
        pgPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray trends = new JsonArray();
                rows.forEach(row -> {
                    JsonObject trend = new JsonObject()
                        .put("date", row.getLocalDateTime("scan_day").toLocalDate().toString())
                        .put("domains_scanned", row.getLong("domains_scanned"))
                        .put("pqc_ready_count", row.getLong("pqc_ready_count"))
                        .put("avg_risk_score", row.getDouble("avg_risk_score"))
                        .put("critical_count", row.getLong("critical_count"))
                        .put("high_risk_count", row.getLong("high_risk_count"))
                        .put("avg_days_until_vulnerable", row.getDouble("avg_days_until_vulnerable"))
                        .put("tls13_count", row.getLong("tls13_count"));
                    trends.add(trend);
                });
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(trends.encode());
            })
            .onFailure(err -> {
                logger.error("Error getting trends: {}", err.getMessage());
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonArray().encode());
            });
    }
    
    /**
     * Get certificate chain for a specific domain
     */
    public void getCertificateChain(RoutingContext ctx) {
        String domain = ctx.pathParam("domain");
        
        String sql = "SELECT cc.* FROM certificate_chain cc " +
            "JOIN scan_results sr ON cc.scan_result_id = sr.id " +
            "WHERE sr.domain_id = (SELECT id FROM domains WHERE domain_name = $1) " +
            "AND sr.id = (SELECT MAX(id) FROM scan_results WHERE domain_id = sr.domain_id) " +
            "ORDER BY cc.chain_position ASC";
        
        pgPool.preparedQuery(sql)
            .execute(Tuple.of(domain))
            .onSuccess(rows -> {
                JsonArray chain = new JsonArray();
                rows.forEach(row -> {
                    JsonObject cert = new JsonObject()
                        .put("chain_position", row.getInteger("chain_position"))
                        .put("subject", row.getString("subject"))
                        .put("issuer", row.getString("issuer"))
                        .put("serial_number", row.getString("serial_number"))
                        .put("not_before", row.getLocalDateTime("not_before") != null ?
                            row.getLocalDateTime("not_before").toString() : null)
                        .put("not_after", row.getLocalDateTime("not_after") != null ?
                            row.getLocalDateTime("not_after").toString() : null)
                        .put("public_key_algorithm", row.getString("public_key_algorithm"))
                        .put("public_key_size", row.getInteger("public_key_size"))
                        .put("signature_algorithm", row.getString("signature_algorithm"))
                        .put("is_root", row.getBoolean("is_root"))
                        .put("is_quantum_safe", row.getBoolean("is_quantum_safe"))
                        .put("pqc_algorithm_type", row.getString("pqc_algorithm_type"))
                        .put("is_valid", row.getBoolean("is_valid"))
                        .put("validation_error", row.getString("validation_error"));
                    chain.add(cert);
                });
                
                JsonObject response = new JsonObject()
                    .put("domain", domain)
                    .put("chain", chain)
                    .put("chain_length", chain.size());
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(response.encode());
            })
            .onFailure(err -> handleError(ctx, err));
    }
    
    private JsonObject rowToJson(Row row) {
        JsonObject json = new JsonObject();
        for (int i = 0; i < row.size(); i++) {
            String columnName = row.getColumnName(i);
            Object value = row.getValue(i);
            if (value != null) {
                if (value instanceof java.time.LocalDateTime) {
                    json.put(columnName, value.toString());
                } else if (value instanceof java.time.LocalDate) {
                    json.put(columnName, value.toString());
                } else {
                    json.put(columnName, value);
                }
            }
        }
        return json;
    }
    
    private void handleError(RoutingContext ctx, Throwable err) {
        logger.error("API error: {}", err.getMessage(), err);
        ctx.response()
            .setStatusCode(500)
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("error", err.getMessage())
                .encode());
    }
}

// Made with Bob
