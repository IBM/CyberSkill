# PQC Domain Scanner - Features Documentation

## Overview
The PQC Domain Scanner is a comprehensive web application for monitoring and analyzing domain readiness for Post-Quantum Cryptography (PQC). This document describes all implemented features.

---

## 🎯 Core Features

### 1. Domain Management
**Description:** Add, scan, and manage domains for PQC readiness monitoring.

**Features:**
- Add domains via web interface
- Bulk domain scanning
- Individual domain scanning
- Domain deletion
- Scan history tracking
- Last scan timestamp display

**Usage:**
```
1. Enter domain name (e.g., example.com)
2. Click "Add Domain"
3. Click "Scan" to analyze the domain
4. View results in the dashboard
```

---

## 📊 Risk Scoring System

### Overview
Comprehensive risk assessment algorithm that evaluates domains based on multiple security factors.

### Risk Calculation Algorithm
**Weighted Scoring (0-100):**
- **Vulnerability Window (40%):** Days until quantum computers can break current encryption
- **Certificate Validity (20%):** Certificate expiration and validity period
- **Algorithm Strength (20%):** Cryptographic algorithm security level
- **TLS Version (10%):** TLS protocol version support
- **Chain Issues (10%):** Certificate chain validation problems

### Risk Levels
| Level | Score Range | Color | Description |
|-------|-------------|-------|-------------|
| **CRITICAL** | 80-100 | 🔴 Red | Immediate action required |
| **HIGH** | 60-79 | 🟠 Orange | High priority remediation |
| **MEDIUM** | 40-59 | 🟡 Yellow | Moderate risk, plan migration |
| **LOW** | 0-39 | 🟢 Green | Low risk, monitor regularly |

### Visual Components
- **Risk Distribution Cards:** Real-time breakdown by risk level
- **Risk Distribution Pie Chart:** Visual percentage distribution
- **Risk Score Badges:** Color-coded risk indicators in tables
- **Risk Percentage Display:** Percentage of domains in each category

### API Endpoint
```
GET /api/risk-distribution
Response: [
  { "risk_level": "CRITICAL", "count": 5 },
  { "risk_level": "HIGH", "count": 12 },
  { "risk_level": "MEDIUM", "count": 23 },
  { "risk_level": "LOW", "count": 45 }
]
```

---

## 📈 Trend Analysis

### Overview
Time-series analysis tracking PQC adoption and security metrics over configurable time periods.

### Tracked Metrics
1. **PQC Adoption Rate**
   - Number of PQC-ready domains over time
   - Adoption percentage trends
   - Growth rate visualization

2. **Average Risk Score**
   - Overall security posture trends
   - Risk score changes over time
   - Improvement/degradation tracking

3. **TLS 1.3 Adoption**
   - TLS 1.3 usage percentage
   - Protocol upgrade trends
   - Compliance tracking

4. **Critical/High Risk Domains**
   - Count of high-priority domains
   - Risk escalation tracking
   - Alert threshold monitoring

### Time Periods
- Last 7 Days
- Last 14 Days
- Last 30 Days (default)
- Last 60 Days
- Last 90 Days

### Visual Components
- **Line Charts:** Smooth trend visualization with filled areas
- **Interactive Period Selector:** Dropdown to change time range
- **Multi-metric Dashboard:** 4 separate trend charts
- **Responsive Design:** Adapts to screen size

### API Endpoint
```
GET /api/trends?days=30
Response: [
  {
    "scan_date": "2026-01-28",
    "pqc_ready_count": 45,
    "avg_risk_score": 42.5,
    "tls13_percentage": 78.3,
    "critical_count": 5,
    "high_count": 12
  },
  ...
]
```

### Database View
```sql
CREATE VIEW scan_trends AS
SELECT 
    DATE(scan_date) as scan_date,
    COUNT(*) as total_scans,
    SUM(CASE WHEN is_pqc_ready THEN 1 ELSE 0 END) as pqc_ready_count,
    AVG(risk_score) as avg_risk_score,
    AVG(CASE WHEN supports_tls_13 THEN 100 ELSE 0 END) as tls13_percentage,
    SUM(CASE WHEN risk_level = 'CRITICAL' THEN 1 ELSE 0 END) as critical_count,
    SUM(CASE WHEN risk_level = 'HIGH' THEN 1 ELSE 0 END) as high_count
FROM scan_results
WHERE scan_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY DATE(scan_date)
ORDER BY scan_date DESC;
```

---

## 🔗 Certificate Chain Analysis

### Overview
Deep inspection of complete certificate chains to identify quantum vulnerabilities at any level.

### Features
1. **Full Chain Extraction**
   - End entity certificate
   - Intermediate CA certificates
   - Root CA certificate
   - Chain validation status

2. **Per-Certificate Analysis**
   - Subject and Issuer information
   - Public key algorithm
   - Key size
   - Validity period
   - Quantum-safe status
   - PQC algorithm type (if applicable)

3. **Chain-Level Insights**
   - Chain length
   - Overall chain validity
   - Weak algorithm detection
   - Quantum-vulnerable intermediates
   - Chain integrity issues

### Visual Components
- **Chain Summary Card:** High-level chain statistics
- **Certificate Cards:** Individual certificate details with color coding
  - 🔐 Root CA (Purple border)
  - 🔗 Intermediate CA (Blue border)
  - 📄 End Entity (Green border)
- **Chain Flow Visualization:** Arrows showing certificate hierarchy
- **Issue Highlighting:** Warning badges for problems

### API Endpoint
```
GET /api/certificate-chain/:domain
Response: {
  "domain": "example.com",
  "chain_length": 3,
  "chain_valid": true,
  "has_issues": false,
  "weak_algorithms": [],
  "chain": [
    {
      "level": 0,
      "subject": "CN=example.com",
      "issuer": "CN=Intermediate CA",
      "public_key_algorithm": "RSA",
      "public_key_size": 2048,
      "is_quantum_safe": false,
      "not_before": "2024-01-01T00:00:00Z",
      "not_after": "2025-01-01T00:00:00Z"
    },
    ...
  ]
}
```

### Database Schema
```sql
CREATE TABLE certificate_chain (
    id SERIAL PRIMARY KEY,
    scan_result_id INTEGER REFERENCES scan_results(id),
    chain_level INTEGER NOT NULL,
    subject TEXT,
    issuer TEXT,
    serial_number TEXT,
    public_key_algorithm VARCHAR(100),
    public_key_size INTEGER,
    signature_algorithm VARCHAR(100),
    not_before TIMESTAMP,
    not_after TIMESTAMP,
    is_quantum_safe BOOLEAN,
    pqc_algorithm_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📊 Export & Reporting

### Overview
Comprehensive data export functionality supporting multiple formats for reporting and analysis.

### Export Formats

#### 1. JSON Export
**Use Case:** API integration, data processing, backup
**Features:**
- Complete data structure
- Nested objects preserved
- ISO 8601 timestamps
- Machine-readable format

**Example:**
```json
{
  "generated": "2026-01-28T16:00:00Z",
  "version": "1.0",
  "stats": { ... },
  "domains": [ ... ],
  "scans": [ ... ],
  "risks": [ ... ],
  "trends": [ ... ]
}
```

#### 2. CSV Export
**Use Case:** Excel analysis, spreadsheet import, data science
**Features:**
- Flat table structure
- Header row included
- Comma-separated values
- Compatible with Excel, Google Sheets

**Columns:**
```
Domain, PQC Ready, Risk Level, Risk Score, TLS 1.3, Algorithm, Key Size, Days Until Vulnerable, Scan Date
```

#### 3. HTML Report
**Use Case:** Stakeholder presentations, documentation, archival
**Features:**
- Styled HTML document
- Embedded statistics
- Formatted tables
- Color-coded risk levels
- Print-friendly layout
- Self-contained (no external dependencies)

### Customizable Options
Users can select which data to include:
- ✅ Statistics summary
- ✅ Domain list
- ✅ Scan results
- ✅ Risk analysis
- ✅ Trend data

### Export Modal
Interactive modal with:
- Format selection buttons
- Checkbox options for data inclusion
- Real-time data gathering
- Automatic file download
- Success notifications

### Usage
```
1. Click "📊 Export Report" button
2. Select export format (JSON/CSV/HTML)
3. Choose data to include (checkboxes)
4. Click format button to download
5. File downloads automatically
```

---

## 📱 User Interface Features

### Dashboard Components

#### 1. Statistics Cards
- Total Domains
- PQC Ready Domains
- Vulnerable Domains
- Average Response Time
- High Risk Domains

#### 2. Interactive Charts
- **Readiness Distribution:** Doughnut chart
- **Vulnerability Window:** Bar chart
- **Algorithm Distribution:** Horizontal bar chart
- **Risk Distribution:** Pie chart
- **Trend Charts:** Line charts (4 metrics)

#### 3. Data Tables
- **Recent Scans Table:** Sortable, filterable results
- **Search Functionality:** Real-time domain search
- **Risk Level Filter:** Filter by risk category
- **Responsive Design:** Mobile-friendly layout

#### 4. Modals
- **Certificate Details Modal:** Full certificate information
- **Certificate Chain Modal:** Complete chain analysis
- **Export Modal:** Report generation options

### User Experience Features
- **Auto-refresh:** Data updates every 30 seconds
- **Toast Notifications:** Success/error messages
- **Loading States:** Visual feedback during operations
- **Hover Effects:** Interactive element highlighting
- **Keyboard Support:** Enter key for domain input
- **Responsive Design:** Works on all screen sizes

---

## 🔧 Technical Implementation

### Frontend Stack
- **HTML5:** Semantic markup
- **CSS3:** Modern styling with CSS Grid and Flexbox
- **Vanilla JavaScript:** No framework dependencies
- **Chart.js 4.4.0:** Data visualization

### Backend Stack
- **Java 11+:** Core application
- **Vert.x:** Reactive web framework
- **PostgreSQL:** Database with advanced views
- **JDBC:** Database connectivity

### API Architecture
- **RESTful Design:** Standard HTTP methods
- **JSON Responses:** Consistent data format
- **Error Handling:** Proper HTTP status codes
- **CORS Support:** Cross-origin requests

### Database Design
- **Normalized Schema:** Efficient data storage
- **Materialized Views:** Fast query performance
- **Indexes:** Optimized lookups
- **Constraints:** Data integrity

---

## 🚀 Performance Optimizations

### Frontend
- **Chart Caching:** Reuse chart instances
- **Data Caching:** Store API responses
- **Lazy Loading:** Load data on demand
- **Debouncing:** Optimize search input
- **Batch Updates:** Minimize DOM operations

### Backend
- **Connection Pooling:** Efficient database connections
- **Prepared Statements:** SQL injection prevention and performance
- **Async Operations:** Non-blocking I/O
- **Result Caching:** Reduce database load

### Database
- **Indexed Columns:** Fast lookups
- **Materialized Views:** Pre-computed aggregations
- **Query Optimization:** Efficient SQL
- **Partitioning Ready:** Scalable design

---

## 📋 Feature Comparison

| Feature | Status | Backend | Frontend | Database |
|---------|--------|---------|----------|----------|
| Domain Management | ✅ Complete | ✅ | ✅ | ✅ |
| Risk Scoring | ✅ Complete | ✅ | ✅ | ✅ |
| Trend Analysis | ✅ Complete | ✅ | ✅ | ✅ |
| Certificate Chain | ✅ Complete | ✅ | ✅ | ✅ |
| Export/Reporting | ✅ Complete | ✅ | ✅ | N/A |
| Real-time Updates | ✅ Complete | N/A | ✅ | N/A |
| Search & Filter | ✅ Complete | N/A | ✅ | N/A |
| Responsive Design | ✅ Complete | N/A | ✅ | N/A |

---

## 🎓 Usage Examples

### Example 1: Monitor Critical Domains
```
1. Add high-priority domains
2. Run initial scan
3. Check Risk Distribution section
4. Filter table by "CRITICAL" risk level
5. Review certificate chains for critical domains
6. Export HTML report for stakeholders
```

### Example 2: Track PQC Migration Progress
```
1. Scan all domains weekly
2. View Trend Analysis section
3. Select "Last 90 Days" period
4. Monitor PQC Adoption chart
5. Track Average Risk Score trend
6. Export CSV for executive dashboard
```

### Example 3: Certificate Chain Audit
```
1. Select domain from list
2. Click "Chain" button
3. Review each certificate level
4. Identify weak algorithms
5. Plan upgrade path
6. Document findings in HTML report
```

---

## 🔮 Future Enhancements

See [TLS_HANDSHAKE_ANALYZER.md](TLS_HANDSHAKE_ANALYZER.md) for the next major feature:
- TLS Handshake Analyzer with PQC Mode
- Side-by-side Classical vs PQC comparison
- Performance impact estimation
- Interactive handshake visualization

---

## 📞 Support

For issues or questions:
1. Check [README.md](README.md) for setup instructions
2. Review [QUICK_START.md](QUICK_START.md) for getting started
3. See [IMPLEMENTATION_FIXES.md](IMPLEMENTATION_FIXES.md) for troubleshooting

---

**Version:** 1.0  
**Last Updated:** 2026-01-28  
**Author:** Bob (AI Assistant)