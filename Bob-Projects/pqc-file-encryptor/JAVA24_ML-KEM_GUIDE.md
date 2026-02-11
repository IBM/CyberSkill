# PQC File Encryptor - Java 24 ML-KEM Guide

## 🎉 Real ML-KEM Encryption with Java 24

This application now uses **real ML-KEM (Kyber) encryption** via Java 24's native KEM API!

## Prerequisites

✅ **Java 24** installed (you have version 24.0.2)
✅ **PostgreSQL** running on localhost:5432
✅ **Maven 3.9+** for building

## Quick Start

### 1. Setup Database
```bash
# Create database and tables
psql -U postgres
CREATE DATABASE pqc_encryptor;
\c pqc_encryptor
\i database/schema.sql
```

### 2. Compile with Java 24
```bash
# Windows
compile-java24.bat

# Or manually
mvn clean compile
```

### 3. Run Application
```bash
# Windows
run-java24.bat

# Or manually
java --enable-preview -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

### 4. Access Web Interface
Open browser: **http://localhost:9999**

## How It Works

### ML-KEM (Kyber) Encryption Flow

1. **Key Generation**
   - Uses Java 24's `KeyPairGenerator.getInstance("ML-KEM-512/768/1024")`
   - Generates post-quantum secure key pairs
   - Public key: 800-1568 bytes (vs RSA-2048: 294 bytes)
   - Private key: 1632-3168 bytes (vs RSA-2048: 1704 bytes)

2. **File Encryption**
   ```
   User File → AES-256-GCM Encryption → Encrypted File
                     ↓
                 AES Key
                     ↓
   ML-KEM Encapsulation (KEM API)
                     ↓
   Encapsulated Key (768-1568 bytes) + Protected AES Key
   ```

3. **Key Encapsulation (Real ML-KEM)**
   ```java
   // Java 24 KEM API
   KEM kem = KEM.getInstance("ML-KEM-768");
   KEM.Encapsulator encapsulator = kem.newEncapsulator(publicKey);
   KEM.Encapsulated result = encapsulator.encapsulate();
   
   byte[] encapsulatedKey = result.encapsulation();  // Kyber ciphertext
   SecretKey sharedSecret = result.key();            // Shared secret
   ```

4. **Key Decapsulation (Real ML-KEM)**
   ```java
   // Java 24 KEM API
   KEM kem = KEM.getInstance("ML-KEM-768");
   KEM.Decapsulator decapsulator = kem.newDecapsulator(privateKey);
   SecretKey sharedSecret = decapsulator.decapsulate(encapsulatedKey);
   ```

## ML-KEM Variants

| Variant | Security Level | Public Key | Private Key | Ciphertext | Equivalent |
|---------|---------------|------------|-------------|------------|------------|
| ML-KEM-512 | Level 1 | 800 bytes | 1632 bytes | 768 bytes | AES-128 |
| ML-KEM-768 | Level 3 | 1184 bytes | 2400 bytes | 1088 bytes | AES-192 |
| ML-KEM-1024 | Level 5 | 1568 bytes | 3168 bytes | 1568 bytes | AES-256 |

**Recommended:** ML-KEM-768 (Level 3) - Best balance of security and performance

## Size Comparison Dashboard

The web interface shows real-time comparisons:

### Classical (RSA-2048)
- Public Key: 294 bytes
- Private Key: 1704 bytes
- Encrypted Key: 256 bytes

### Post-Quantum (ML-KEM-768)
- Public Key: 1184 bytes (+302%)
- Private Key: 2400 bytes (+41%)
- Encrypted Key: 1088 bytes (+325%)

**Why larger?** PQC algorithms use lattice-based mathematics requiring more data to achieve quantum resistance.

## Features

### ✅ Real ML-KEM Encryption
- Native Java 24 KEM API
- NIST-standardized ML-KEM (Kyber)
- No simulation or fallback

### ✅ Hybrid Cryptography
- AES-256-GCM for data encryption (fast, symmetric)
- ML-KEM for key encapsulation (quantum-safe)
- Best of both worlds

### ✅ Visual Dashboard
- Real-time size comparisons
- Algorithm metadata tracking
- Encryption/decryption history
- Interactive charts

### ✅ Database Storage
- PostgreSQL for metadata
- Tracks all encryption operations
- Stores key sizes and algorithms
- Audit trail

## API Endpoints

### Upload File
```http
POST /api/upload
Content-Type: multipart/form-data

file: <binary>
```

### Encrypt File
```http
POST /api/encrypt
Content-Type: application/json

{
  "file_path": "example.txt",
  "kem_algorithm": "kyber768",
  "aes_key_size": 256
}
```

### List Records
```http
GET /api/records
```

### Decrypt File
```http
POST /api/decrypt/:id
```

### Get Statistics
```http
GET /api/stats
```

## Technical Details

### Java 24 KEM API
```java
// Available algorithms
"ML-KEM-512"   // Kyber-512
"ML-KEM-768"   // Kyber-768 (recommended)
"ML-KEM-1024"  // Kyber-1024
```

### Preview Features
Java 24 requires `--enable-preview` flag for ML-KEM:
```bash
java --enable-preview -jar app.jar
```

### Maven Configuration
```xml
<properties>
    <maven.compiler.source>24</maven.compiler.source>
    <maven.compiler.target>24</maven.compiler.target>
</properties>

<plugin>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
        <compilerArgs>
            <arg>--enable-preview</arg>
        </compilerArgs>
    </configuration>
</plugin>
```

## Security Notes

### ✅ Quantum-Safe
- ML-KEM is NIST-standardized PQC
- Resistant to Shor's algorithm
- Protects against quantum computers

### ✅ Hybrid Approach
- AES for data (quantum-safe for symmetric)
- ML-KEM for key exchange (quantum-safe for asymmetric)
- Defense in depth

### ⚠️ Key Management
- Private keys stored in database (demo only)
- Production: Use HSM or key vault
- Implement key rotation

### ⚠️ Preview Features
- ML-KEM in Java 24 is preview
- May change in future releases
- Test thoroughly before production

## Troubleshooting

### "ML-KEM not available"
- Ensure Java 24 is installed
- Use `--enable-preview` flag
- Check JAVA_HOME points to JDK 24

### "Invalid target release: 24"
- Maven using wrong Java version
- Run `compile-java24.bat` to set JAVA_HOME
- Or set JAVA_HOME system variable

### Database Connection Error
- Start PostgreSQL service
- Check config.json for correct credentials
- Ensure database exists

### Port 9999 Already in Use
- Change port in `src/main/resources/config.json`
- Or stop other service using port 9999

## Performance

### Encryption Speed
- AES-256-GCM: ~500 MB/s
- ML-KEM-768 encapsulation: ~0.5ms
- Overall: Limited by disk I/O

### Key Generation
- ML-KEM-512: ~0.1ms
- ML-KEM-768: ~0.2ms
- ML-KEM-1024: ~0.3ms

### Size Overhead
- Ciphertext: +325% vs RSA
- Public key: +302% vs RSA
- Acceptable for quantum safety

## References

- [NIST PQC Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [ML-KEM Specification](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.203.pdf)
- [Java 24 KEM API](https://docs.oracle.com/en/java/javase/24/docs/api/java.base/javax/crypto/KEM.html)
- [Kyber Algorithm](https://pq-crystals.org/kyber/)

## License

MIT License - See LICENSE file

## Author

Built with ❤️ using Vert.x, Java 24, and ML-KEM

---

**Ready to encrypt with quantum-safe cryptography!** 🔐🚀