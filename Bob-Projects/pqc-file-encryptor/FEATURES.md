# PQC File Encryptor - Features Documentation

## 🎯 Core Features

### 1. Hybrid Post-Quantum Cryptography

#### Kyber KEM (Key Encapsulation Mechanism)
- **Kyber512**: NIST Security Level 1 (equivalent to AES-128)
  - Public Key: 800 bytes
  - Private Key: 1,632 bytes
  - Ciphertext: 768 bytes
  
- **Kyber768**: NIST Security Level 3 (equivalent to AES-192)
  - Public Key: 1,184 bytes
  - Private Key: 2,400 bytes
  - Ciphertext: 1,088 bytes
  
- **Kyber1024**: NIST Security Level 5 (equivalent to AES-256)
  - Public Key: 1,568 bytes
  - Private Key: 3,168 bytes
  - Ciphertext: 1,568 bytes

#### AES Encryption
- **AES-128-GCM**: 128-bit key, authenticated encryption
- **AES-192-GCM**: 192-bit key, authenticated encryption
- **AES-256-GCM**: 256-bit key, authenticated encryption (default)

### 2. File Encryption Workflow

```
┌─────────────┐
│ Upload File │
└──────┬──────┘
       │
       ▼
┌─────────────────────┐
│ Generate Kyber Keys │
│  (Public/Private)   │
└──────┬──────────────┘
       │
       ▼
┌─────────────────┐
│ Generate AES Key│
└──────┬──────────┘
       │
       ▼
┌──────────────────────┐
│ Encapsulate AES Key  │
│ with Kyber Public Key│
└──────┬───────────────┘
       │
       ▼
┌─────────────────────┐
│ Encrypt File with   │
│ AES-GCM             │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Store Metadata in   │
│ PostgreSQL          │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│ Package & Save      │
│ Encrypted File      │
└─────────────────────┘
```

### 3. Visual Dashboard

#### Summary Statistics
- Total files encrypted
- Total data processed
- Average PQC overhead
- Algorithm distribution

#### Key Size Charts
- **Bar Chart**: Comparison of key sizes across algorithms
- **Horizontal Bar Chart**: Classical vs PQC visualization
- **Interactive**: Hover for detailed information

#### Size Comparison Grid
- Side-by-side comparison cards
- Classical (RSA-2048) baseline
- All three Kyber variants
- Percentage overhead calculations

### 4. Database Schema

#### encryption_metadata Table
Stores comprehensive information about each encryption operation:
- File details (name, sizes)
- Algorithm choices
- Key sizes
- Overhead metrics
- Timestamps
- Status tracking

#### key_statistics Table
Aggregates cryptographic key statistics:
- Algorithm type (Classical/PQC)
- Key type (Public/Private/Ciphertext)
- Size metrics (average, min, max)
- Operation counts

#### Views
- **encryption_summary**: Aggregated encryption statistics
- **size_comparison**: Pre-calculated size comparisons

### 5. RESTful API

#### File Operations
- `POST /api/upload` - Upload file for encryption
- `POST /api/encrypt` - Encrypt uploaded file
- `POST /api/decrypt` - Decrypt encrypted file

#### Data Retrieval
- `GET /api/records` - List all encryption records
- `GET /api/records/:id` - Get specific record
- `GET /api/dashboard` - Dashboard statistics
- `GET /api/key-stats` - Key size statistics
- `GET /api/size-comparison` - Size comparison data

#### Health Check
- `GET /api/health` - Service health status

### 6. Web Interface

#### Encrypt Files Tab
- File upload with drag-and-drop support
- Algorithm selection (Kyber variant)
- Key size selection (AES)
- Real-time encryption progress
- Detailed result display with metrics

#### Encryption Records Tab
- Searchable list of all encryptions
- Status badges (encrypted/decrypted)
- Detailed metadata view
- One-click decryption
- Timestamp tracking

#### Dashboard Tab
- Summary statistics cards
- Interactive charts
- Real-time data updates
- Visual key size comparisons

#### Size Comparison Tab
- Educational comparison cards
- Classical vs PQC overhead
- Detailed breakdown by algorithm
- Interactive bar charts
- Information boxes explaining differences

## 🔍 Technical Details

### Encryption Package Format

```
┌─────────────────────────────────────┐
│ Encapsulated Key Length (4 bytes)   │
├─────────────────────────────────────┤
│ Encapsulated Key (variable)         │
├─────────────────────────────────────┤
│ IV Length (4 bytes)                 │
├─────────────────────────────────────┤
│ IV (12 bytes for GCM)               │
├─────────────────────────────────────┤
│ Ciphertext (variable)               │
└─────────────────────────────────────┘
```

### Security Features

1. **Authenticated Encryption**: AES-GCM provides both confidentiality and authenticity
2. **Random IV**: Each encryption uses a unique initialization vector
3. **Secure Random**: Cryptographically secure random number generation
4. **Key Encapsulation**: Modern KEM approach instead of traditional key exchange
5. **Quantum Resistance**: Kyber provides protection against quantum attacks

### Performance Characteristics

#### Kyber512
- **Speed**: Fastest variant
- **Key Size**: Smallest overhead
- **Security**: NIST Level 1
- **Use Case**: High-performance applications

#### Kyber768
- **Speed**: Balanced
- **Key Size**: Moderate overhead
- **Security**: NIST Level 3 (recommended)
- **Use Case**: General purpose

#### Kyber1024
- **Speed**: Slower
- **Key Size**: Largest overhead
- **Security**: NIST Level 5
- **Use Case**: Maximum security requirements

## 📊 Metrics and Analytics

### Calculated Metrics

1. **Original File Size**: Size before encryption
2. **Encrypted File Size**: Size after encryption (includes overhead)
3. **PQC Key Overhead**: Additional bytes required for PQC keys
4. **Percentage Overhead**: Relative increase compared to classical
5. **Total Key Size**: Sum of all cryptographic material

### Comparison Baselines

- **Classical**: RSA-2048 (1,998 bytes total)
- **PQC Kyber512**: 3,200 bytes (+60% overhead)
- **PQC Kyber768**: 4,672 bytes (+134% overhead)
- **PQC Kyber1024**: 6,304 bytes (+216% overhead)

## 🎨 User Experience Features

### Visual Design
- **Dark Theme**: Modern, eye-friendly interface
- **Color Coding**: Classical (orange) vs PQC (teal)
- **Responsive**: Works on desktop, tablet, and mobile
- **Animations**: Smooth transitions and loading states

### Interactivity
- **Real-time Updates**: Live data refresh
- **Interactive Charts**: Hover for details
- **Status Indicators**: Visual feedback for operations
- **Error Handling**: Clear error messages

### Accessibility
- **Semantic HTML**: Proper structure
- **Keyboard Navigation**: Full keyboard support
- **Color Contrast**: WCAG compliant
- **Screen Reader**: Descriptive labels

## 🔧 Configuration Options

### Application Settings
- HTTP port and host
- Database connection parameters
- Upload directory paths
- Maximum file size limits

### Encryption Defaults
- Default Kyber variant
- Default AES key size
- File storage locations

### Database Settings
- Connection pool size
- Query timeouts
- Retry policies

## 📈 Future Enhancements

### Potential Features
1. **Multiple File Encryption**: Batch processing
2. **Key Management**: Secure key storage and rotation
3. **User Authentication**: Multi-user support
4. **File Sharing**: Secure file sharing capabilities
5. **Compression**: Pre-encryption compression
6. **Streaming**: Large file streaming support
7. **CLI Tool**: Command-line interface
8. **Docker Support**: Containerized deployment
9. **Cloud Storage**: Integration with cloud providers
10. **Audit Logs**: Comprehensive audit trail

### Performance Optimizations
1. **Parallel Processing**: Multi-threaded encryption
2. **Caching**: Key and metadata caching
3. **Connection Pooling**: Optimized database connections
4. **Lazy Loading**: Progressive data loading

## 🎓 Educational Value

This application serves as a practical demonstration of:

1. **Post-Quantum Cryptography**: Real-world PQC implementation
2. **Hybrid Encryption**: Combining symmetric and asymmetric crypto
3. **Key Encapsulation**: Modern alternative to key exchange
4. **Size Trade-offs**: Visual understanding of PQC overhead
5. **Reactive Programming**: Asynchronous, non-blocking operations
6. **Full-Stack Development**: Complete application architecture

## 📚 Learning Resources

### Concepts Demonstrated
- Lattice-based cryptography (Kyber)
- Authenticated encryption (AES-GCM)
- Key encapsulation mechanisms
- Database design for crypto metadata
- RESTful API design
- Reactive programming patterns
- Modern web development

### Best Practices
- Secure random number generation
- Proper IV handling
- Key lifecycle management
- Error handling and logging
- API design principles
- Database normalization
- Frontend state management

---

**This application demonstrates the practical implementation of NIST-standardized post-quantum cryptography in a real-world scenario.**