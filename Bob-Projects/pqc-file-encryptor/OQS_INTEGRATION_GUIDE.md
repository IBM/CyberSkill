# OQS Integration Guide - Complete Setup

## 🎯 Overview

This guide will help you integrate **real Kyber KEM** from Open Quantum Safe (liboqs) into the PQC File Encryptor application.

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] Java 11 or higher
- [ ] Maven 3.6+
- [ ] Git
- [ ] CMake 3.5+
- [ ] C/C++ compiler (GCC, Clang, or MSVC)
- [ ] PostgreSQL 12+

## 🔧 Step 1: Install liboqs Native Library

### Windows

```powershell
# Option 1: Using vcpkg (Recommended)
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg install liboqs:x64-windows

# Add to system PATH
$env:PATH += ";C:\path\to\vcpkg\installed\x64-windows\bin"

# Option 2: Build from source
git clone -b main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -G "Visual Studio 16 2019" -A x64 ..
cmake --build . --config Release
cmake --install . --prefix C:\liboqs
```

### Linux (Ubuntu/Debian)

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y cmake gcc ninja-build libssl-dev \
    python3-pytest python3-pytest-xdist unzip xsltproc \
    doxygen graphviz git

# Clone and build liboqs
git clone -b main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local ..
ninja
sudo ninja install
sudo ldconfig

# Verify installation
ls -l /usr/local/lib/liboqs.*
```

### macOS

```bash
# Using Homebrew
brew tap open-quantum-safe/liboqs
brew install liboqs

# Or build from source
git clone -b main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make
sudo make install
```

## 🔧 Step 2: Install liboqs-java

```bash
# Clone liboqs-java
git clone https://github.com/open-quantum-safe/liboqs-java.git
cd liboqs-java

# Build and install to local Maven repository
./gradlew build
./gradlew publishToMavenLocal

# Verify installation
ls ~/.m2/repository/org/openquantumsafe/liboqs-java/
```

## 🔧 Step 3: Verify Installation

Create a test file to verify liboqs-java works:

```java
// TestOQS.java
import org.openquantumsafe.KeyEncapsulation;

public class TestOQS {
    public static void main(String[] args) {
        try {
            System.out.println("Testing liboqs-java...");
            KeyEncapsulation kem = new KeyEncapsulation("Kyber512");
            byte[] publicKey = kem.generate_keypair();
            System.out.println("✅ Success! Public key size: " + publicKey.length);
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

Compile and run:
```bash
javac -cp ~/.m2/repository/org/openquantumsafe/liboqs-java/0.1.0-SNAPSHOT/liboqs-java-0.1.0-SNAPSHOT.jar TestOQS.java
java -cp .:~/.m2/repository/org/openquantumsafe/liboqs-java/0.1.0-SNAPSHOT/liboqs-java-0.1.0-SNAPSHOT.jar -Djava.library.path=/usr/local/lib TestOQS
```

Expected output:
```
Testing liboqs-java...
✅ Success! Public key size: 800
```

## 🔧 Step 4: Update PQC File Encryptor

The POM file is already configured with OQS dependency. Now update the code:

### 4.1: Update FileEncryptionService

Replace `PQCCryptoService` with `OQSCryptoService`:

```java
// In FileEncryptionService.java
private final OQSCryptoService cryptoService;  // Changed from PQCCryptoService

public FileEncryptionService(OQSCryptoService cryptoService, ...) {  // Changed parameter
    this.cryptoService = cryptoService;
    // ... rest of constructor
}
```

### 4.2: Update MainVerticle

```java
// In MainVerticle.java
private void initializeServices(JsonObject config) {
    logger.info("Initializing services...");
    
    databaseService = new DatabaseService(config.getJsonObject("database"));
    
    // Use OQS instead of simulated
    cryptoService = new OQSCryptoService();  // Changed from PQCCryptoService
    
    encryptionService = new FileEncryptionService(
            cryptoService, 
            databaseService, 
            config.getJsonObject("encryption")
    );
    
    // ... rest of method
}
```

### 4.3: Update FileEncryptionService Methods

Update the encryption method to use OQS key pair structure:

```java
// In FileEncryptionService.encryptFile()
OQSCryptoService.KyberKeyPair kyberKeyPair = cryptoService.generateKyberKeyPair(variant);

// Store keys
String publicKeyBase64 = Base64.getEncoder().encodeToString(kyberKeyPair.getPublicKey());
String privateKeyBase64 = Base64.getEncoder().encodeToString(kyberKeyPair.getPrivateKey());
metadata.put("notes", "Keys: " + publicKeyBase64 + "|" + privateKeyBase64 + "|AES:" + aesKeySize);
```

## 🔧 Step 5: Build and Run

```bash
cd pqc-file-encryptor

# Build with OQS
mvn clean package

# Run with library path
# Linux/macOS:
java -Djava.library.path=/usr/local/lib -jar target/pqc-file-encryptor-1.0.0-fat.jar

# Windows:
java -Djava.library.path=C:\liboqs\bin -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

## 🐛 Troubleshooting

### Error: "java.lang.UnsatisfiedLinkError: no oqs-jni in java.library.path"

**Solution**: Specify the library path when running:
```bash
# Linux/macOS
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
java -Djava.library.path=/usr/local/lib -jar target/pqc-file-encryptor-1.0.0-fat.jar

# Windows
set PATH=%PATH%;C:\liboqs\bin
java -Djava.library.path=C:\liboqs\bin -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

### Error: "Could not find artifact org.openquantumsafe:liboqs-java"

**Solution**: Ensure liboqs-java is installed to local Maven repository:
```bash
cd liboqs-java
./gradlew clean build publishToMavenLocal
```

### Error: "CMake Error: Could not find CMAKE_MAKE_PROGRAM"

**Solution**: Install build tools:
```bash
# Ubuntu/Debian
sudo apt-get install ninja-build

# macOS
brew install ninja

# Windows
# Install Visual Studio Build Tools or use vcpkg
```

### Error: "undefined reference to `OQS_KEM_kyber_512_new`"

**Solution**: Rebuild liboqs with proper flags:
```bash
cd liboqs/build
cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_SHARED_LIBS=ON ..
ninja clean
ninja
sudo ninja install
sudo ldconfig
```

## 🎯 Verification Steps

After setup, verify everything works:

1. **Check liboqs installation**:
```bash
# Linux/macOS
ls -l /usr/local/lib/liboqs.*

# Windows
dir C:\liboqs\bin\oqs.dll
```

2. **Check liboqs-java installation**:
```bash
ls ~/.m2/repository/org/openquantumsafe/liboqs-java/0.1.0-SNAPSHOT/
```

3. **Test the application**:
```bash
# Start the application
java -Djava.library.path=/usr/local/lib -jar target/pqc-file-encryptor-1.0.0-fat.jar

# In another terminal, test encryption
curl -X POST -F "file=@test.txt" http://localhost:8080/api/upload
curl -X POST http://localhost:8080/api/encrypt \
  -H "Content-Type: application/json" \
  -d '{"fileName":"test.txt","kemAlgorithm":"Kyber1024","aesKeySize":256}'
```

4. **Check logs**:
Look for:
```
Generating Kyber key pair using liboqs: KYBER1024
Kyber key pair generated - Public: 1568 bytes, Private: 3168 bytes
```

## 🚀 Production Deployment

### Docker Deployment

Create `Dockerfile`:
```dockerfile
FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    cmake gcc ninja-build libssl-dev git \
    openjdk-11-jdk maven

# Build and install liboqs
RUN git clone https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && mkdir build && cd build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    ninja && ninja install && ldconfig

# Build and install liboqs-java
RUN git clone https://github.com/open-quantum-safe/liboqs-java.git && \
    cd liboqs-java && ./gradlew build publishToMavenLocal

# Copy application
COPY . /app
WORKDIR /app

# Build application
RUN mvn clean package

# Run
ENV LD_LIBRARY_PATH=/usr/local/lib
CMD ["java", "-Djava.library.path=/usr/local/lib", "-jar", "target/pqc-file-encryptor-1.0.0-fat.jar"]
```

Build and run:
```bash
docker build -t pqc-file-encryptor .
docker run -p 8080:8080 pqc-file-encryptor
```

## 📚 Additional Resources

- [liboqs Documentation](https://github.com/open-quantum-safe/liboqs)
- [liboqs-java Documentation](https://github.com/open-quantum-safe/liboqs-java)
- [OQS Project Website](https://openquantumsafe.org/)
- [Kyber Specification](https://pq-crystals.org/kyber/)
- [NIST PQC Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)

## ✅ Success Checklist

- [ ] liboqs native library installed
- [ ] liboqs-java built and in Maven local repository
- [ ] Test program runs successfully
- [ ] PQC File Encryptor builds without errors
- [ ] Application starts with correct library path
- [ ] File encryption works with real Kyber
- [ ] Dashboard shows correct key sizes
- [ ] Decryption works correctly

---

**Congratulations! You now have a production-ready PQC application with real Kyber KEM!** 🎉