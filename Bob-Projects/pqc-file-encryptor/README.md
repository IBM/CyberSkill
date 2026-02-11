# PQC File Encryptor

A production-ready Post-Quantum Cryptography (PQC) file encryption application built with **Java 24 native ML-KEM support**, Vert.x, and PostgreSQL. This application demonstrates hybrid cryptography by combining AES-256-GCM symmetric encryption with ML-KEM (Kyber) post-quantum key encapsulation.

## 🌟 Key Features

- **Native Java 24 ML-KEM (Kyber)**: Uses Java's built-in post-quantum cryptography support (no external libraries!)
- **Hybrid Encryption**: AES-256-GCM for data + ML-KEM for key encapsulation
- **Three Security Levels**: Kyber-512, Kyber-768, Kyber-1024
- **Visual Dashboard**: Real-time charts comparing classical vs PQC key sizes
- **PostgreSQL Storage**: Metadata tracking and statistics
- **RESTful API**: 9 endpoints for encryption, decryption, and analytics
- **Async/Reactive**: Built on Vert.x for high performance

## 📊 What Makes This Special

This application visually demonstrates the **size overhead** of post-quantum cryptography:

| Algorithm | Public Key | Private Key | Ciphertext | vs RSA-2048 |
|-----------|-----------|-------------|------------|-------------|
| **RSA-2048** | 294 bytes | 1,218 bytes | ~256 bytes | Baseline |
| **Kyber-512** | 800 bytes | 1,632 bytes | 768 bytes | +172% public |
| **Kyber-768** | 1,184 bytes | 2,400 bytes | 1,088 bytes | +303% public |
| **Kyber-1024** | 1,568 bytes | 3,168 bytes | 1,568 bytes | +433% public |

## 🚀 Quick Start

### Prerequisites

- **Java 24** (required for native ML-KEM support)
- **PostgreSQL 12+**
- **Maven 3.9+**

### 1. Setup Database

```bash
# Create database
createdb pqc_encryptor

# Run schema
psql -d pqc_encryptor -f database/schema.sql
```

### 2. Configure Application

Edit `src/main/resources/config.json`:

```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_encryptor",
    "user": "your_user",
    "password": "your_password"
  },
  "server": {
    "port": 8080
  },
  "encryption": {
    "uploadDirectory": "uploads",
    "encryptedDirectory": "uploads/encrypted"
  }
}
```

### 3. Build and Run

```bash
# Build
mvn clean package

# Run
java -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

### 4. Access Dashboard

Open browser: `http://localhost:8080`

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Web Dashboard (HTML/JS)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Encrypt  │  │ Records  │  │Dashboard │  │Comparison│   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │ REST API
┌────────────────────────┴────────────────────────────────────┐
│                    Vert.x HTTP Server                        │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              ApiHandler (9 endpoints)                 │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────┴────────────────────────────────────┐
│              FileEncryptionService (Orchestrator)            │
│  ┌──────────────────┐              ┌──────────────────┐    │
│  │ Encrypt Pipeline │              │ Decrypt Pipeline │    │
│  └──────────────────┘              └──────────────────┘    │
└────────┬────────────────────────────────────┬───────────────┘
         │                                    │
┌────────┴────────────────┐      ┌───────────┴──────────────┐
│ Java22PQCCryptoService  │      │   DatabaseService        │
│  • ML-KEM Key Gen       │      │  • Metadata Storage      │
│  • AES-256-GCM          │      │  • Statistics            │
│  • Encapsulation        │      │  • Analytics             │
│  • Decapsulation        │      └──────────────────────────┘
└─────────────────────────┘                   │
         │                                    │
┌────────┴────────────────┐      ┌───────────┴──────────────┐
│  Java 24 Native Crypto  │      │      PostgreSQL          │
│  • javax.crypto.KEM     │      │  • encryption_metadata   │
│  • ML-KEM-512/768/1024  │      │  • key_statistics        │
│  • AES/GCM/NoPadding    │      │  • Views & Analytics     │
└─────────────────────────┘      └──────────────────────────┘
```

## 🔐 How It Works

### Encryption Flow

1. **User uploads file** via web interface
2. **Generate ML-KEM key pair** (Kyber-512/768/1024)
3. **Generate AES-256 key** for symmetric encryption
4. **Encapsulate AES key** using ML-KEM public key
5. **Encrypt file data** with AES-256-GCM
6. **Store encrypted package** (encapsulated key + IV + ciphertext)
7. **Save metadata** to PostgreSQL (including private key for demo)
8. **Return statistics** and size comparisons

### Decryption Flow

1. **User selects encrypted record**
2. **Retrieve private key** from database
3. **Decapsulate AES key** using ML-KEM private key
4. **Decrypt file data** with recovered AES key
5. **Save decrypted file** and update timestamp

## 📡 API Endpoints

### Encryption & Decryption

```http
POST /api/encrypt
Content-Type: multipart/form-data

Parameters:
- file: File to encrypt
- kemAlgorithm: kyber_512 | kyber_768 | kyber_1024
- aesKeySize: 128 | 192 | 256
```

```http
POST /api/decrypt
Content-Type: application/json

{
  "recordId": 123
}
```

### Data Retrieval

```http
GET /api/records              # All encryption records
GET /api/record/:id           # Single record details
GET /api/summary              # Encryption summary stats
GET /api/key-statistics       # Key size statistics
GET /api/size-comparison      # Classical vs PQC comparison
```

### File Management

```http
GET /api/download/:filename   # Download encrypted file
POST /api/delete/:id          # Delete encryption record
```

## 🎨 Dashboard Features

### 1. Encrypt Tab
- Drag-and-drop file upload
- Algorithm selection (Kyber-512/768/1024)
- AES key size selection
- Real-time encryption progress
- Instant results with statistics

### 2. Records Tab
- Searchable table of all encryptions
- File details and timestamps
- Quick decrypt action
- Delete functionality

### 3. Dashboard Tab
- **Encryption Timeline**: Bar chart of encryptions over time
- **Algorithm Distribution**: Pie chart of KEM algorithm usage
- **Key Size Trends**: Line chart showing size evolution
- **Summary Cards**: Total files, average sizes, overhead stats

### 4. Comparison Tab
- **Side-by-side comparison**: Classical RSA vs ML-KEM
- **Visual bar charts**: Public/private key sizes
- **Overhead calculations**: Percentage increases
- **Security level indicators**: NIST security categories

## 🗄️ Database Schema

### encryption_metadata
Stores complete encryption details:
- File names (original & encrypted)
- Sizes (original, encrypted, overhead)
- Algorithms (KEM, AES)
- Key sizes (public, private, encapsulated)
- Timestamps (encryption, decryption)
- Private key (Base64, for demo purposes)

### key_statistics
Aggregated statistics:
- Algorithm type
- Key type (public/private/encapsulated)
- Size metrics (min, max, avg, total)
- Operation counts

### Views
- `encryption_summary`: Overall statistics
- `size_comparison_view`: Classical vs PQC comparison

## 🔧 Configuration

### Java 24 ML-KEM Support

The application uses Java 24's native ML-KEM implementation:

```java
// Generate ML-KEM key pair
KeyPairGenerator kpg = KeyPairGenerator.getInstance("ML-KEM");
kpg.initialize(KyberParameterSpec.kyber1024());
KeyPair keyPair = kpg.generateKeyPair();

// Encapsulate (wrap AES key)
Cipher cipher = Cipher.getInstance("ML-KEM");
cipher.init(Cipher.WRAP_MODE, publicKey);
byte[] encapsulatedKey = cipher.wrap(aesKey);

// Decapsulate (unwrap AES key)
cipher.init(Cipher.UNWRAP_MODE, privateKey);
SecretKey recoveredKey = (SecretKey) cipher.unwrap(
    encapsulatedKey, "AES", Cipher.SECRET_KEY
);
```

### Fallback Mode

If ML-KEM is not available (Java < 24), the application falls back to RSA-2048 simulation mode with accurate Kyber size reporting for demonstration purposes.

## 📈 Performance

- **Async/Non-blocking**: Vert.x event loop for high concurrency
- **Reactive Streams**: Future-based composition
- **Connection Pooling**: PostgreSQL client pool
- **Efficient I/O**: Streaming file operations

## 🔒 Security Notes

⚠️ **This is a demonstration application**:

1. **Private keys are stored in database** - In production, use HSM or secure key management
2. **No authentication** - Add OAuth2/JWT for production
3. **No rate limiting** - Implement for production use
4. **File size limits** - Configure appropriate limits
5. **Input validation** - Enhanced validation needed for production

## 🧪 Testing

```bash
# Run tests
mvn test

# Test encryption endpoint
curl -X POST http://localhost:8080/api/encrypt \
  -F "file=@test.txt" \
  -F "kemAlgorithm=kyber_768" \
  -F "aesKeySize=256"

# Test decryption
curl -X POST http://localhost:8080/api/decrypt \
  -H "Content-Type: application/json" \
  -d '{"recordId": 1}'
```

## 📚 Learn More

### Post-Quantum Cryptography
- [NIST PQC Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [ML-KEM (Kyber) Specification](https://csrc.nist.gov/pubs/fips/203/final)
- [Java 24 Security Features](https://openjdk.org/jeps/8301553)

### Technologies Used
- [Vert.x](https://vertx.io/) - Reactive toolkit
- [PostgreSQL](https://www.postgresql.org/) - Database
- [Chart.js](https://www.chartjs.org/) - Visualizations
- [Tailwind CSS](https://tailwindcss.com/) - Styling

## 🤝 Contributing

This is a demonstration project. Feel free to:
- Report issues
- Suggest improvements
- Fork and enhance
- Use as learning material

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

Built with ❤️ by Bob - Demonstrating the future of cryptography

---

**Note**: This application requires Java 24 for native ML-KEM support. Java 22 introduced early access, but Java 24 stabilized the implementation.