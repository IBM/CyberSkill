# Application Metrics Guide

## Overview
The ScenarioLaunchPlatform now includes comprehensive metrics collection and monitoring capabilities. This guide explains how to use and integrate with the metrics system.

## 📊 Available Metrics

### 1. HTTP Request Metrics
Tracks all HTTP requests to the application.

**Metrics Collected:**
- Total requests count
- Successful requests (2xx status codes)
- Failed requests (4xx, 5xx status codes)
- Active concurrent requests
- Average response time (ms)
- Success rate (%)
- Requests per second
- Top 10 most called endpoints
- HTTP status code distribution

### 2. Database Performance Metrics
Monitors database operations and connection pool health.

**Metrics Collected:**
- Total queries executed
- Successful queries
- Failed queries
- Active database connections
- Average query execution time (ms)
- Slow queries count (> 1 second)
- Query success rate (%)

### 3. Story Execution Metrics
Tracks the execution of stories/scenarios.

**Metrics Collected:**
- Total stories executed
- Successful story executions
- Failed story executions
- Active stories (currently running)
- Average story execution time (ms)
- Story success rate (%)

### 4. Error & Exception Metrics
Monitors application errors and exceptions.

**Metrics Collected:**
- Total errors count
- Errors by type (categorized)
- Recent errors (last 100, displayed last 10)
- Error timestamps and messages

## 🔌 API Endpoints

### Metrics Endpoints

```bash
# Get all metrics
GET /api/metrics/all

# Get HTTP request metrics only
GET /api/metrics/http

# Get database performance metrics only
GET /api/metrics/database

# Get story execution metrics only
GET /api/metrics/stories

# Get error and exception metrics only
GET /api/metrics/errors

# Reset all metrics (admin only)
POST /api/metrics/reset
```

### Health Check Endpoints

```bash
# Basic health check
GET /health

# Detailed health with system info
GET /health/detailed

# System metrics (memory, CPU, etc.)
GET /metrics

# Kubernetes readiness probe
GET /readiness

# Kubernetes liveness probe
GET /liveness
```

## 📈 Example API Responses

### All Metrics Response
```json
{
  "http": {
    "totalRequests": 1523,
    "successfulRequests": 1450,
    "failedRequests": 73,
    "activeRequests": 3,
    "averageResponseTimeMs": 45,
    "successRate": 95.21,
    "requestsPerSecond": 2.5,
    "topEndpoints": [
      {"endpoint": "/api/getAllStories", "count": 342},
      {"endpoint": "/api/getDatabaseConnections", "count": 256}
    ],
    "statusCodeDistribution": {
      "200": 1450,
      "404": 45,
      "500": 28
    }
  },
  "database": {
    "totalQueries": 3456,
    "successfulQueries": 3420,
    "failedQueries": 36,
    "activeConnections": 5,
    "averageQueryTimeMs": 23,
    "slowQueries": 12,
    "successRate": 98.96
  },
  "stories": {
    "totalStories": 234,
    "successfulStories": 220,
    "failedStories": 14,
    "activeStories": 2,
    "averageExecutionTimeMs": 1250,
    "successRate": 94.02
  },
  "errors": {
    "totalErrors": 42,
    "errorsByType": {
      "NullPointerException": 15,
      "SQLException": 12,
      "TimeoutException": 8,
      "ValidationException": 7
    },
    "recentErrors": [
      {
        "timestamp": 1706547123456,
        "type": "SQLException",
        "message": "Connection timeout"
      }
    ]
  },
  "collectionStartTime": 1706540000000,
  "uptimeMs": 7123456
}
```

## 🔧 Integration Guide

### Automatic HTTP Metrics Collection

HTTP metrics are automatically collected for all requests via the metrics interceptor. No additional code is required.

### Manual Database Metrics Recording

To record database operations in your code:

```java
import metrics.thejasonengine.com.MetricsCollector;

// Get the metrics collector instance
MetricsCollector metrics = MetricsCollector.getInstance();

// Before query execution
long startTime = System.currentTimeMillis();
metrics.incrementActiveConnections();

try {
    // Execute your database query
    // ...
    
    long queryTime = System.currentTimeMillis() - startTime;
    metrics.recordQuery(true, queryTime); // true = success
    
} catch (Exception e) {
    long queryTime = System.currentTimeMillis() - startTime;
    metrics.recordQuery(false, queryTime); // false = failed
    
} finally {
    metrics.decrementActiveConnections();
}
```

### Manual Story Metrics Recording

To record story executions:

```java
import metrics.thejasonengine.com.MetricsCollector;

MetricsCollector metrics = MetricsCollector.getInstance();

// Before story execution
long startTime = System.currentTimeMillis();
metrics.incrementActiveStories();

try {
    // Execute your story
    // ...
    
    long executionTime = System.currentTimeMillis() - startTime;
    metrics.recordStory(true, executionTime); // true = success
    
} catch (Exception e) {
    long executionTime = System.currentTimeMillis() - startTime;
    metrics.recordStory(false, executionTime); // false = failed
    
} finally {
    metrics.decrementActiveStories();
}
```

### Manual Error Recording

To record errors and exceptions:

```java
import metrics.thejasonengine.com.MetricsCollector;

MetricsCollector metrics = MetricsCollector.getInstance();

try {
    // Your code
    // ...
    
} catch (Exception e) {
    metrics.recordError(
        e.getClass().getSimpleName(),  // Error type
        e.getMessage(),                 // Error message
        getStackTraceAsString(e)        // Stack trace
    );
    throw e; // Re-throw if needed
}
```

## 📊 Dashboard Integration

The metrics are automatically displayed in the health dashboard at:
```
http://localhost:8888/health-dashboard.html
```

To add custom metrics cards to the dashboard, modify the `health-dashboard.html` file and add fetch calls to the new endpoints.

## 🔍 Monitoring Best Practices

### 1. Set Up Alerts

Monitor these key metrics and set up alerts:
- **HTTP Success Rate** < 95% → Alert
- **Database Success Rate** < 98% → Alert
- **Average Response Time** > 500ms → Warning
- **Slow Queries** > 10 per minute → Warning
- **Active Connections** > 80% of pool size → Alert
- **Error Rate** > 5 per minute → Alert

### 2. Regular Monitoring

Check these metrics regularly:
- Request rate trends
- Response time trends
- Database query performance
- Story success rates
- Error patterns

### 3. Capacity Planning

Use metrics for capacity planning:
- Peak request rates
- Database connection usage
- Memory consumption trends
- Story execution patterns

## 🚀 Performance Tips

### 1. Optimize Slow Queries
Monitor the `slowQueries` metric and optimize queries that take > 1 second.

### 2. Connection Pool Sizing
Use `activeConnections` to determine if your connection pool needs adjustment.

### 3. Error Pattern Analysis
Review `errorsByType` to identify and fix recurring issues.

### 4. Endpoint Performance
Use `topEndpoints` and response times to identify bottlenecks.

## 🔄 Metrics Reset

To reset all metrics (useful for testing or after maintenance):

```bash
curl -X POST http://localhost:8888/api/metrics/reset
```

**Response:**
```json
{
  "status": "success",
  "message": "All metrics have been reset"
}
```

## 📝 Logging

All metrics operations are logged at DEBUG level. To see detailed metrics logging, set your log level to DEBUG in `log4j.properties`:

```properties
log4j.logger.metrics.thejasonengine.com=DEBUG
```

## 🐛 Troubleshooting

### Metrics Not Updating

1. **Check if metrics interceptor is registered**
   - Look for log message: "Health check and metrics endpoints registered"

2. **Verify endpoints are accessible**
   ```bash
   curl http://localhost:8888/api/metrics/all
   ```

3. **Check for errors in logs**
   ```bash
   grep "MetricsCollector" application.log
   ```

### High Memory Usage

The metrics collector stores recent errors (last 100). If memory is a concern, you can reduce `MAX_RECENT_ERRORS` in `MetricsCollector.java`.

### Metrics Seem Inaccurate

1. **Reset metrics** to start fresh
2. **Check system time** - metrics use timestamps
3. **Verify interceptor is first** in the route chain

## 🎯 Future Enhancements

Planned improvements:
- Histogram support for response time distribution
- Percentile calculations (p50, p95, p99)
- Metrics persistence to database
- Grafana dashboard templates
- Prometheus exporter format
- Custom metric tags/labels
- Metric aggregation by time windows

## 📚 Additional Resources

- [Micrometer Documentation](https://micrometer.io/docs)
- [Prometheus Best Practices](https://prometheus.io/docs/practices/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)

## 🤝 Contributing

To add new metrics:

1. Add metric fields to `MetricsCollector.java`
2. Create recording methods
3. Add getter methods for JSON export
4. Update this documentation
5. Add to dashboard UI if needed

---

**Last Updated:** 2026-01-29
**Version:** 1.0.0