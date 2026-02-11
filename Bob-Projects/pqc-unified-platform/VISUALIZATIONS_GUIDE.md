# Advanced Visualizations Guide

## Overview
The PQC Unified Platform now includes comprehensive data visualizations to provide real-time insights into security metrics, performance, and system activity.

## New Visualizations Added

### 1. **Security Score Gauge** 🎯
**Location:** Dashboard Tab (Top)
**Purpose:** Displays overall platform security score (0-100)

**Features:**
- Animated SVG gauge with color-coded scoring
- Red (0-40): Critical security issues
- Orange (41-70): Warning level
- Green (71-100): Good security posture
- Calculates score based on:
  - High-risk scan percentage
  - Medium-risk scan percentage  
  - PQC adoption rate
  - Number of encrypted files

**Implementation:**
```javascript
updateSecurityGauge(score)
calculateSecurityScore(scannerData, filesData)
```

### 2. **Algorithm Usage Pie Chart** 🔐
**Location:** Dashboard Tab
**Purpose:** Shows distribution of ML-KEM algorithm variants

**Features:**
- Interactive pie chart with color-coded segments
- ML-KEM-512 (Blue)
- ML-KEM-768 (Green) - Default
- ML-KEM-1024 (Orange)
- Legend with counts
- Canvas-based rendering

**Implementation:**
```javascript
drawPieChart('algorithm-chart', data, colors)
updateAlgorithmChart(filesData)
```

### 3. **TLS Version Distribution Chart** 🔒
**Location:** Dashboard Tab
**Purpose:** Visualizes TLS protocol versions from scanned domains

**Features:**
- Donut-style pie chart
- TLS 1.3 (Green) - Most secure
- TLS 1.2 (Blue) - Secure
- TLS 1.1 (Orange) - Deprecated
- TLS 1.0 (Red) - Insecure
- Helps identify outdated protocols

**Implementation:**
```javascript
updateTLSChart(scannerData)
```

### 4. **Real-time Activity Timeline** ⚡
**Location:** Dashboard Tab
**Purpose:** Live feed of all platform activities

**Features:**
- Scrollable timeline (max 50 items)
- Color-coded by activity type:
  - 🔍 Scan (Blue border)
  - 🔒 Encrypt (Green border)
  - 🔓 Decrypt (Orange border)
  - 💬 Chat (Purple border)
- Timestamps for each activity
- Clear button to reset timeline
- Slide-in animation for new items

**Implementation:**
```javascript
addTimelineActivity(type, title, description)
updateActivityTimeline()
```

**Usage Example:**
```javascript
// Add activity when file is encrypted
addTimelineActivity('encrypt', 'File Encrypted', `${filename} encrypted with ML-KEM-768`);

// Add activity when domain is scanned
addTimelineActivity('scan', 'Domain Scanned', `${domain} - Risk: ${riskLevel}`);
```

### 5. **Encryption Performance Metrics** ⚡
**Location:** Dashboard Tab
**Purpose:** Displays real-time encryption performance data

**Metrics:**
- **Average Encryption Time** (ms)
  - Shows time taken to encrypt files
  - Progress bar visualization
  
- **Throughput** (MB/s)
  - Data processing speed
  - Helps identify performance bottlenecks
  
- **Key Exchange Speed** (ms)
  - ML-KEM key generation/encapsulation time
  - Critical for chat performance

**Features:**
- Animated progress bars
- Color-coded performance indicators
- Auto-updating metrics

**Implementation:**
```javascript
updatePerformanceMetrics(data)
```

### 6. **File Size Distribution Histogram** 📊
**Location:** Dashboard Tab
**Purpose:** Shows distribution of encrypted file sizes

**Categories:**
- < 1MB (Small files)
- 1-10MB (Medium files)
- 10-50MB (Large files)
- > 50MB (Extra large files)

**Features:**
- Horizontal bar chart
- Green gradient bars
- Count display for each category
- Helps understand storage patterns

**Implementation:**
```javascript
updateFileSizeDistribution(files)
```

## Integration Points

### Dashboard Data Loading
All visualizations are updated when `loadDashboardData()` is called:

```javascript
async function loadDashboardData() {
    // Fetch data from all services
    const scannerData = await fetch(`${API_BASE}/scanner/stats`);
    const filesData = await fetch(`${API_BASE}/file/list`);
    const chatData = await fetch(`${API_BASE}/chat/sessions`);
    
    // Update all visualizations
    updateSecurityGauge(calculateSecurityScore(scannerData, filesData));
    updateAlgorithmChart(filesData);
    updateTLSChart(scannerData);
    updatePerformanceMetrics(performanceData);
    updateFileSizeDistribution(filesData.files);
    updateActivityTimeline();
}
```

### Activity Tracking
Activities are automatically logged when users perform actions:

```javascript
// File encryption
async function encryptFile(file) {
    // ... encryption logic ...
    addTimelineActivity('encrypt', 'File Encrypted', 
        `${file.name} (${formatFileSize(file.size)})`);
}

// Domain scanning
async function scanDomain(domain) {
    // ... scanning logic ...
    addTimelineActivity('scan', 'Domain Scanned', 
        `${domain} - ${result.tlsVersion}`);
}

// Chat messages
async function sendMessage() {
    // ... send logic ...
    addTimelineActivity('chat', 'Message Sent', 
        `Encrypted message in session ${currentSession}`);
}
```

## Styling

### CSS Classes
All visualizations use consistent styling:

```css
/* Gauge */
.gauge-container { /* SVG gauge wrapper */ }
.gauge-fill { /* Animated arc */ }
.gauge-legend { /* Color legend */ }

/* Charts */
canvas { /* Pie/donut charts */ }
.chart-legend { /* Chart legends */ }
.legend-item { /* Individual legend entries */ }

/* Timeline */
.activity-timeline { /* Scrollable container */ }
.timeline-item { /* Individual activities */ }
.timeline-icon { /* Activity icons */ }

/* Metrics */
.metric-item { /* Performance metric */ }
.metric-bar { /* Progress bar */ }
.metric-fill { /* Animated fill */ }

/* Histogram */
.histogram { /* Bar chart container */ }
.histogram-bar { /* Individual bars */ }
.histogram-fill { /* Animated bars */ }
```

## Performance Considerations

1. **Timeline Limit:** Maximum 50 items to prevent memory issues
2. **Auto-refresh:** Dashboard updates every 30 seconds
3. **Canvas Rendering:** Efficient for pie charts
4. **CSS Animations:** Hardware-accelerated transitions
5. **Lazy Loading:** Charts only render when dashboard is active

## Browser Compatibility

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

**Requirements:**
- Canvas API support
- CSS3 animations
- ES6+ JavaScript

## Future Enhancements

Potential additions:
- Line charts for historical trends
- Heatmaps for activity patterns
- 3D visualizations for complex data
- Export functionality (PNG/PDF)
- Real-time WebSocket updates
- Customizable dashboard layouts
- Dark mode support

## Troubleshooting

### Charts Not Displaying
- Check browser console for errors
- Verify API endpoints are responding
- Ensure canvas elements exist in DOM

### Performance Issues
- Reduce timeline item limit
- Increase refresh interval
- Disable animations in CSS

### Data Not Updating
- Check network tab for failed requests
- Verify backend services are running
- Clear browser cache

## API Data Format

### Scanner Stats
```json
{
  "totalScans": 10,
  "pqcEnabled": 5,
  "highRisk": 2,
  "mediumRisk": 3,
  "lowRisk": 5,
  "tls13": 6,
  "tls12": 3,
  "tls11": 1,
  "tls10": 0
}
```

### File List
```json
{
  "total": 15,
  "files": [
    {
      "filename": "enc_123.pdf",
      "originalFilename": "document.pdf",
      "size": 1048576,
      "algorithm": "ML-KEM-768",
      "lastModified": "2026-02-04T12:00:00Z"
    }
  ],
  "mlkem768": 10,
  "mlkem512": 3,
  "mlkem1024": 2
}
```

### Chat Sessions
```json
{
  "total": 5,
  "active": 2
}
```

## Summary

The advanced visualizations provide:
- **Real-time insights** into platform security
- **Performance monitoring** for encryption operations
- **Activity tracking** across all features
- **Data distribution** analysis
- **User-friendly** visual representations

All visualizations are:
- ✅ Responsive
- ✅ Animated
- ✅ Color-coded
- ✅ Interactive
- ✅ Auto-updating

**Result:** A comprehensive, professional dashboard that gives users complete visibility into their PQC security posture.