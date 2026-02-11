# Project Structure

## Directory Layout

```
pqc-domain-scanner/
├── src/
│   └── main/
│       ├── java/com/pqc/scanner/
│       │   ├── MainVerticle.java       # Main application entry point
│       │   ├── DomainScanner.java      # SSL/TLS scanning logic
│       │   └── ApiHandler.java         # REST API endpoints
│       ├── resources/
│       │   └── config.json             # Application configuration
│       └── webapp/
│           ├── index.html              # Dashboard UI
│           ├── styles.css              # Styling
│           └── app.js                  # Frontend logic & charts
├── database/
│   └── schema.sql                      # PostgreSQL database schema
├── pom.xml                             # Maven dependencies
├── Dockerfile                          # Docker container config
├── docker-compose.yml                  # Multi-container setup
├── .gitignore                          # Git ignore rules
├── README.md                           # Main documentation
├── QUICK_START.md                      # Quick setup guide
├── OQS_INTEGRATION.md                  # OQS Provider integration
└── PROJECT_STRUCTURE.md                # This file
```

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        Web Browser                          │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Dashboard (HTML/CSS/JavaScript)              │  │
│  │  • Statistics Cards  • Charts (Chart.js)             │  │
│  │  • Domain Management • Scan Results Table            │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP/REST API
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Vert.x Application                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              MainVerticle (Entry Point)              │  │
│  │  • HTTP Server  • Router  • Static File Handler      │  │
│  └────────────────────┬─────────────────────────────────┘  │
│                       │                                     │
│  ┌────────────────────┴─────────────────────────────────┐  │
│  │              ApiHandler (REST Endpoints)             │  │
│  │  • /api/stats      • /api/scan/:domain               │  │
│  │  • /api/domains    • /api/results                    │  │
│  │  • /api/certificate/:domain                          │  │
│  └────────────────────┬─────────────────────────────────┘  │
│                       │                                     │
│  ┌────────────────────┴─────────────────────────────────┐  │
│  │         DomainScanner (Scanning Logic)               │  │
│  │  • SSL/TLS Connection  • Certificate Analysis        │  │
│  │  • PQC Detection       • Vulnerability Calculation   │  │
│  └────────────────────┬─────────────────────────────────┘  │
└───────────────────────┼─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                   PostgreSQL Database                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Tables:                                             │  │
│  │  • domains            - Domain list                  │  │
│  │  • scan_results       - Scan history                 │  │
│  │  • certificate_details - Certificate info            │  │
│  │                                                       │  │
│  │  Views:                                              │  │
│  │  • dashboard_stats    - Aggregated statistics        │  │
│  │  • recent_scans       - Latest scan results          │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              External Domains (HTTPS/443)                   │
│  • Target domains being scanned for PQC readiness           │
│  • SSL/TLS certificate analysis                             │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### Frontend (webapp/)

**index.html**
- Dashboard layout with statistics cards
- Domain management interface
- Results table with sorting/filtering
- Certificate details modal
- Responsive design

**styles.css**
- Modern, clean UI design
- Card-based layout
- Color-coded status indicators
- Mobile-responsive styles
- Dark/light theme support

**app.js**
- REST API client
- Chart.js visualizations
- Real-time data updates
- Domain CRUD operations
- Scan triggering and monitoring

### Backend (Java)

**MainVerticle.java**
- Application bootstrap
- HTTP server setup
- Route configuration
- Database connection pooling
- Static file serving

**DomainScanner.java**
- SSL/TLS socket connections
- Certificate chain analysis
- Algorithm detection (RSA, ECDSA, PQC)
- Key size extraction
- Vulnerability window calculation
- Database persistence

**ApiHandler.java**
- RESTful endpoint handlers
- Request validation
- Response formatting
- Error handling
- Database queries

### Database (PostgreSQL)

**Tables:**
- `domains`: Domain registry
- `scan_results`: Historical scan data
- `certificate_details`: Certificate metadata

**Views:**
- `dashboard_stats`: Real-time statistics
- `recent_scans`: Latest results with joins

**Indexes:**
- Optimized for common queries
- Fast lookups by domain name
- Efficient date-based filtering

## Data Flow

### Scanning Process

```
1. User adds domain → POST /api/domains
   ↓
2. Domain stored in database
   ↓
3. User triggers scan → POST /api/scan/:domain
   ↓
4. DomainScanner connects to domain:443
   ↓
5. SSL/TLS handshake performed
   ↓
6. Certificate chain retrieved
   ↓
7. Certificate analyzed:
   - Public key algorithm
   - Signature algorithm
   - Key size
   - Expiry date
   - SAN entries
   ↓
8. PQC detection:
   - Check against quantum-safe algorithms
   - Identify algorithm type
   - Calculate vulnerability window
   ↓
9. Results saved to database:
   - scan_results table
   - certificate_details table
   ↓
10. Response returned to frontend
   ↓
11. Dashboard updated with new data
```

### Dashboard Update Flow

```
1. Page loads → Initialize charts
   ↓
2. Fetch data from API:
   - GET /api/stats
   - GET /api/domains
   - GET /api/results
   - GET /api/vulnerability-window
   ↓
3. Update UI components:
   - Statistics cards
   - Charts (readiness, vulnerability, algorithms)
   - Domain list
   - Results table
   ↓
4. Auto-refresh every 30 seconds
```

## Key Technologies

### Backend
- **Vert.x 4.5.1**: Reactive application framework
- **PostgreSQL**: Relational database
- **Bouncy Castle**: Cryptography library
- **SLF4J/Logback**: Logging

### Frontend
- **Vanilla JavaScript**: No framework dependencies
- **Chart.js 4.4.0**: Data visualization
- **CSS3**: Modern styling with flexbox/grid
- **HTML5**: Semantic markup

### DevOps
- **Maven**: Build automation
- **Docker**: Containerization
- **Docker Compose**: Multi-container orchestration

## Configuration

### config.json Structure

```json
{
  "http": {
    "port": 8080,              // Server port
    "host": "0.0.0.0"          // Bind address
  },
  "database": {
    "host": "localhost",       // PostgreSQL host
    "port": 5432,              // PostgreSQL port
    "database": "pqc_scanner", // Database name
    "user": "postgres",        // DB user
    "password": "postgres",    // DB password
    "maxPoolSize": 10          // Connection pool size
  },
  "scanner": {
    "timeout": 10000,          // Scan timeout (ms)
    "maxConcurrentScans": 5,   // Parallel scans
    "retryAttempts": 3,        // Retry on failure
    "quantumSafeAlgorithms": [...], // PQC algorithms
    "vulnerableAlgorithms": [...]   // Classical algorithms
  },
  "security": {
    "quantumThreatYear": 2030, // Quantum threat timeline
    "certLifetimeYears": 1     // Certificate validity
  }
}
```

## API Reference

### Endpoints Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/health | Health check |
| GET | /api/stats | Dashboard statistics |
| GET | /api/domains | List all domains |
| POST | /api/domains | Add new domain |
| DELETE | /api/domains/:id | Delete domain |
| POST | /api/scan/:domain | Scan single domain |
| POST | /api/scan-batch | Scan multiple domains |
| GET | /api/results | Get scan results |
| GET | /api/results/:domain | Get domain results |
| GET | /api/certificate/:domain | Get certificate details |
| GET | /api/timeline | Get scan timeline |
| GET | /api/vulnerability-window | Get vulnerability distribution |

## Security Considerations

1. **Certificate Validation**: Scanner accepts all certificates for analysis
2. **Database Security**: Use strong passwords, limit network access
3. **API Security**: Consider adding authentication for production
4. **Input Validation**: Domain names are validated before scanning
5. **Rate Limiting**: Implement to prevent abuse
6. **HTTPS**: Use reverse proxy (nginx) for production deployment

## Performance Optimization

1. **Connection Pooling**: PostgreSQL connection pool (max 10)
2. **Concurrent Scanning**: Up to 5 parallel scans
3. **Database Indexes**: Optimized for common queries
4. **Caching**: Consider Redis for frequently accessed data
5. **Async Operations**: Vert.x event loop for non-blocking I/O

## Deployment Options

### Option 1: Local Development
```bash
mvn clean package
java -jar target/pqc-domain-scanner-1.0.0.jar
```

### Option 2: Docker Compose
```bash
docker-compose up -d
```

### Option 3: Kubernetes
- Create deployment manifests
- Use ConfigMaps for configuration
- Set up persistent volumes for PostgreSQL

## Monitoring & Logging

- **Application Logs**: Console output via Logback
- **Database Logs**: PostgreSQL logs
- **Metrics**: Consider Prometheus integration
- **Health Checks**: /api/health endpoint

## Future Enhancements

- [ ] User authentication (JWT)
- [ ] Scheduled scans (cron-like)
- [ ] Email notifications
- [ ] Export reports (PDF/CSV)
- [ ] WebSocket for real-time updates
- [ ] Multi-language support
- [ ] Advanced filtering and search
- [ ] Historical trend analysis
- [ ] Integration with CI/CD pipelines
- [ ] Mobile app (React Native)

---

For more information, see:
- [README.md](README.md) - Main documentation
- [QUICK_START.md](QUICK_START.md) - Setup guide
- [OQS_INTEGRATION.md](OQS_INTEGRATION.md) - OQS Provider integration