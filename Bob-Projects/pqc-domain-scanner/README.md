# Post-Quantum Cryptography (PQC) Domain Scanner

A comprehensive web application built with Vert.x, PostgreSQL, and JavaScript that scans domains to check their readiness for Post-Quantum Cryptography (PQC). The application provides a real-time dashboard with visualizations showing which domains support quantum-safe cryptography, certificate details, and vulnerability time windows.

## 🚀 Features

- **Domain Scanning**: Scan multiple domains to check SSL/TLS certificate configurations
- **PQC Detection**: Identify quantum-safe cryptographic algorithms (KYBER, DILITHIUM, FALCON, etc.)
- **Real-time Dashboard**: Interactive dashboard with statistics, charts, and tables
- **Certificate Analysis**: Detailed certificate information including algorithms, key sizes, and expiry dates
- **Vulnerability Timeline**: Calculate time windows before domains become vulnerable to quantum attacks
- **Batch Scanning**: Scan multiple domains simultaneously
- **Data Visualization**: Charts showing PQC readiness distribution, algorithm usage, and vulnerability windows
- **PostgreSQL Storage**: Persistent storage of scan results and historical data

## 📋 Prerequisites

- Java 17 or higher
- Maven 3.6+
- PostgreSQL 12+
- Modern web browser (Chrome, Firefox, Edge, Safari)

## 🛠️ Installation

### 1. Clone or Navigate to Project Directory

```bash
cd pqc-domain-scanner
```

### 2. Set Up PostgreSQL Database

Create a PostgreSQL database:

```bash
createdb pqc_scanner
```

Or using psql:

```sql
CREATE DATABASE pqc_scanner;
```

### 3. Initialize Database Schema

```bash
psql -U postgres -d pqc_scanner -f database/schema.sql
```

### 4. Configure Database Connection

Edit `src/main/resources/config.json` and update the database credentials:

```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_scanner",
    "user": "postgres",
    "password": "your_password"
  }
}
```

### 5. Build the Application

```bash
mvn clean package
```

### 6. Run the Application

```bash
java -jar target/pqc-domain-scanner-1.0.0.jar
```

Or using Maven:

```bash
mvn exec:java -Dexec.mainClass="io.vertx.core.Launcher" -Dexec.args="run com.pqc.scanner.MainVerticle"
```

### 7. Access the Dashboard

Open your browser and navigate to:

```
http://localhost:8080
```

## 📊 Dashboard Features

### Statistics Cards
- **Total Domains**: Number of domains being monitored
- **PQC Ready**: Domains using quantum-safe cryptography
- **Vulnerable**: Domains using classical cryptography vulnerable to quantum attacks
- **Avg Response Time**: Average scan response time

### Charts and Visualizations
1. **PQC Readiness Distribution**: Doughnut chart showing the ratio of PQC-ready vs vulnerable domains
2. **Vulnerability Time Window**: Bar chart showing when domains will become vulnerable
3. **Algorithm Distribution**: Horizontal bar chart showing the most used cryptographic algorithms

### Domain Management
- Add new domains to monitor
- Scan individual domains or batch scan all domains
- View detailed certificate information
- Delete domains from monitoring

### Scan Results Table
- Real-time scan results with domain status
- TLS 1.3 support indicator
- Algorithm and key size information
- Days until vulnerability
- Scan timestamps

## 🔐 Quantum-Safe Algorithms Detected

The scanner identifies the following PQC algorithms:

- **KYBER**: Key encapsulation mechanism
- **DILITHIUM**: Digital signature algorithm
- **FALCON**: Fast Fourier lattice-based signature
- **SPHINCS+**: Stateless hash-based signature
- **NTRU**: Lattice-based encryption
- **SABER**: Module learning with rounding
- **CRYSTALS**: Cryptographic suite for algebraic lattices
- **ML-KEM**: Module-Lattice-Based Key-Encapsulation Mechanism
- **ML-DSA**: Module-Lattice-Based Digital Signature Algorithm
- **SLH-DSA**: Stateless Hash-Based Digital Signature Algorithm

## 🔌 API Endpoints

### Health Check
```
GET /api/health
```

### Statistics
```
GET /api/stats
```

### Domain Management
```
GET /api/domains              # List all domains
POST /api/domains             # Add new domain
DELETE /api/domains/:id       # Delete domain
```

### Scanning
```
POST /api/scan/:domain        # Scan single domain
POST /api/scan-batch          # Scan multiple domains
```

### Results
```
GET /api/results              # Get recent scan results
GET /api/results/:domain      # Get domain-specific results
GET /api/certificate/:domain  # Get certificate details
GET /api/timeline             # Get scan timeline data
GET /api/vulnerability-window # Get vulnerability window distribution
```

## 🗄️ Database Schema

### Tables

1. **domains**: Stores domain information
2. **scan_results**: Stores scan results for each domain
3. **certificate_details**: Stores detailed certificate information

### Views

1. **dashboard_stats**: Aggregated statistics for the dashboard
2. **recent_scans**: Most recent scan results with certificate details

## 🔧 Configuration

Edit `src/main/resources/config.json`:

```json
{
  "http": {
    "port": 8080,
    "host": "0.0.0.0"
  },
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_scanner",
    "user": "postgres",
    "password": "postgres",
    "maxPoolSize": 10
  },
  "scanner": {
    "timeout": 10000,
    "maxConcurrentScans": 5,
    "retryAttempts": 3,
    "quantumSafeAlgorithms": ["KYBER", "DILITHIUM", "FALCON", ...],
    "vulnerableAlgorithms": ["RSA", "ECDSA", "DSA", ...]
  },
  "security": {
    "quantumThreatYear": 2030,
    "certLifetimeYears": 1
  }
}
```

## 🔗 Integration with OQS Provider

This application can be integrated with the [Open Quantum Safe (OQS) Provider](https://github.com/open-quantum-safe/oqs-provider) for enhanced PQC detection and testing.

### Integration Steps:

1. **Install OQS Provider**:
   ```bash
   git clone https://github.com/open-quantum-safe/oqs-provider.git
   cd oqs-provider
   # Follow installation instructions in the OQS repository
   ```

2. **Configure Java Security**:
   Add OQS provider to Java security configuration:
   ```
   security.provider.N=org.openquantumsafe.Provider
   ```

3. **Test PQC Algorithms**:
   Use OQS tools to test domains with quantum-safe configurations:
   ```bash
   openssl s_client -connect example.com:443 -provider oqsprovider
   ```

4. **Enhanced Detection**:
   The scanner will automatically detect OQS-enabled certificates and algorithms.

## 📈 Use Cases

1. **Enterprise Security Audit**: Monitor corporate domains for quantum readiness
2. **Compliance Tracking**: Ensure domains meet future quantum-safe standards
3. **Migration Planning**: Identify which domains need PQC upgrades
4. **Research**: Analyze PQC adoption across different domains
5. **Security Monitoring**: Track certificate expiry and vulnerability windows

## 🐛 Troubleshooting

### Database Connection Issues
- Verify PostgreSQL is running: `pg_isready`
- Check credentials in config.json
- Ensure database exists: `psql -l`

### Port Already in Use
- Change port in config.json
- Kill process using port 8080: `netstat -ano | findstr :8080` (Windows) or `lsof -i :8080` (Linux/Mac)

### Scan Failures
- Check domain is accessible
- Verify firewall allows outbound HTTPS connections
- Increase timeout in config.json

### Chart Not Displaying
- Check browser console for JavaScript errors
- Ensure Chart.js CDN is accessible
- Clear browser cache

## 🔒 Security Considerations

- The scanner accepts all SSL certificates for analysis purposes
- Do not expose the application directly to the internet without authentication
- Use environment variables for sensitive configuration
- Regularly update dependencies for security patches

## 📝 Future Enhancements

- [ ] User authentication and authorization
- [ ] Email notifications for vulnerable domains
- [ ] Scheduled automatic scans
- [ ] Export reports (PDF, CSV)
- [ ] Integration with certificate transparency logs
- [ ] Support for custom PQC algorithm detection
- [ ] Multi-tenant support
- [ ] REST API authentication
- [ ] WebSocket for real-time updates
- [ ] Docker containerization

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## 📄 License

This project is provided as-is for educational and security research purposes.

## 🔗 Resources

- [NIST Post-Quantum Cryptography](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [Open Quantum Safe Project](https://openquantumsafe.org/)
- [Vert.x Documentation](https://vertx.io/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Chart.js Documentation](https://www.chartjs.org/docs/)

## 📧 Support

For questions or support, please open an issue in the project repository.

---

**Note**: This tool is designed for security research and monitoring. Always ensure you have permission to scan domains you don't own.