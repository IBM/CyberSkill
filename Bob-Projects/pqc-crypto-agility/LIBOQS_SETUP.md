# liboqs Integration Guide

This guide explains how the Crypto Agility Runtime integrates with liboqs (Open Quantum Safe) and how to set it up on your system.

## Table of Contents
1. [What is liboqs?](#what-is-liboqs)
2. [How This Project Uses liboqs](#how-this-project-uses-liboqs)
3. [Installation Guide](#installation-guide)
4. [Verification](#verification)
5. [Troubleshooting](#troubleshooting)

---

## What is liboqs?

**liboqs** is the Open Quantum Safe (OQS) project's C library for quantum-resistant cryptographic algorithms. It provides:

- **KEMs (Key Encapsulation Mechanisms)**: Kyber, NTRU, SABER, etc.
- **Signatures**: Dilithium, Falcon, SPHINCS+, etc.
- **NIST PQC Standards**: Implements NIST's standardized algorithms

**liboqs-java** is the Java wrapper that allows Java applications to use liboqs.

---

## How This Project Uses liboqs

### Architecture

```
┌─────────────────────────────────────────┐
│   Your Application                      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   Crypto Agility Runtime                │
│   (This Project)                        │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   KyberProvider.java                    │
│   (Post-Quantum Provider)               │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   liboqs-java                           │
│   (Java JNI Wrapper)                    │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│   liboqs (C Library)                    │
│   (Native Implementation)               │
└─────────────────────────────────────────┘
```

### Code Integration

The `KyberProvider` class uses liboqs-java's `KeyEncapsulation` class:

```java
// From KyberProvider.java
import org.openquantumsafe.KeyEncapsulation;

public class KyberProvider implements CryptoProvider {
    
    @Override
    public KeyPair generateKeyPair() throws CryptoException {
        try {
            // Create liboqs KeyEncapsulation object
            KeyEncapsulation kem = new KeyEncapsulation("Kyber768");
            
            // Export keys
            byte[] publicKey = kem.export_public_key();
            byte[] privateKey = kem.export_secret_key();
            
            // Clean up
            kem.dispose();
            
            return new KeyPair(
                new KyberPublicKey(publicKey),
                new KyberPrivateKey(privateKey)
            );
        } catch (Exception e) {
            throw new CryptoException("Failed to generate Kyber key pair", e);
        }
    }
    
    @Override
    public EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException {
        try {
            KyberPublicKey kyberPubKey = (KyberPublicKey) publicKey;
            
            // Create KEM with public key
            KeyEncapsulation kem = new KeyEncapsulation("Kyber768", kyberPubKey.getEncoded());
            
            // Encapsulate to generate shared secret
            KeyEncapsulation.Ciphertext ciphertext = kem.encap_secret();
            byte[] sharedSecret = ciphertext.getShared_secret();
            byte[] ciphertextBytes = ciphertext.getCiphertext();
            
            kem.dispose();
            
            return new EncapsulationResult(ciphertextBytes, sharedSecret);
        } catch (Exception e) {
            throw new CryptoException("Kyber encapsulation failed", e);
        }
    }
    
    @Override
    public byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException {
        try {
            KyberPrivateKey kyberPrivKey = (KyberPrivateKey) privateKey;
            
            // Create KEM with private key
            KeyEncapsulation kem = new KeyEncapsulation("Kyber768", kyberPrivKey.getEncoded());
            
            // Decapsulate to recover shared secret
            byte[] sharedSecret = kem.decap_secret(ciphertext);
            
            kem.dispose();
            
            return sharedSecret;
        } catch (Exception e) {
            throw new CryptoException("Kyber decapsulation failed", e);
        }
    }
}
```

### Supported Algorithms

The project currently supports these liboqs algorithms:

| Algorithm | Security Level | Key Size | Ciphertext Size | Status |
|-----------|----------------|----------|-----------------|--------|
| Kyber512 | 128-bit | 800 bytes | 768 bytes | ✅ Implemented |
| Kyber768 | 192-bit | 1184 bytes | 1088 bytes | ✅ Implemented |
| Kyber1024 | 256-bit | 1568 bytes | 1568 bytes | ✅ Implemented |
| Dilithium2 | 128-bit | - | - | 📝 Future |
| Dilithium3 | 192-bit | - | - | 📝 Future |
| Dilithium5 | 256-bit | - | - | 📝 Future |
| SPHINCS+ | Various | - | - | 📝 Future |

---

## Installation Guide

### Prerequisites

- **Java 17+**
- **Maven 3.6+**
- **CMake 3.5+** (for building liboqs)
- **C/C++ Compiler** (GCC, Clang, or MSVC)
- **Git**

### Option 1: Using Pre-built liboqs-java (Recommended)

The Maven dependency will automatically download liboqs-java:

```xml
<dependency>
    <groupId>org.openquantumsafe</groupId>
    <artifactId>liboqs-java</artifactId>
    <version>0.9.0</version>
</dependency>
```

However, you still need the native liboqs library:

#### Linux/macOS

```bash
# Install liboqs
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc)
sudo make install

# Update library path
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Make it permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
```

#### Windows

```powershell
# Install liboqs
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build
cd build
cmake -G "Visual Studio 17 2022" -A x64 ..
cmake --build . --config Release
cmake --install . --prefix "C:\Program Files\liboqs"

# Add to PATH
setx PATH "%PATH%;C:\Program Files\liboqs\bin"
```

### Option 2: Building Everything from Source

#### Step 1: Build liboqs

```bash
# Clone liboqs
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs

# Build with all algorithms enabled
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=$HOME/liboqs \
      -DBUILD_SHARED_LIBS=ON \
      -DOQS_USE_OPENSSL=ON \
      ..
make -j$(nproc)
make install
```

#### Step 2: Build liboqs-java

```bash
# Clone liboqs-java
git clone https://github.com/open-quantum-safe/liboqs-java.git
cd liboqs-java

# Set liboqs path
export LIBOQS_INSTALL_PATH=$HOME/liboqs

# Build
./gradlew build

# Install to local Maven repository
./gradlew publishToMavenLocal
```

#### Step 3: Configure Your Project

Update your `pom.xml` to use the local version:

```xml
<dependency>
    <groupId>org.openquantumsafe</groupId>
    <artifactId>liboqs-java</artifactId>
    <version>0.9.0-SNAPSHOT</version>
</dependency>
```

Set library path when running:

```bash
# Linux/macOS
export LD_LIBRARY_PATH=$HOME/liboqs/lib:$LD_LIBRARY_PATH
java -jar target/pqc-crypto-agility-1.0.0-fat.jar

# Or set in Java
java -Djava.library.path=$HOME/liboqs/lib \
     -jar target/pqc-crypto-agility-1.0.0-fat.jar
```

---

## Verification

### Test 1: Check liboqs Installation

```bash
# Linux/macOS
ls -la /usr/local/lib/liboqs*
# Should show: liboqs.so (Linux) or liboqs.dylib (macOS)

# Windows
dir "C:\Program Files\liboqs\bin\oqs.dll"
```

### Test 2: Run Simple Test

Create `TestLiboqs.java`:

```java
import org.openquantumsafe.KeyEncapsulation;

public class TestLiboqs {
    public static void main(String[] args) {
        try {
            System.out.println("Testing liboqs integration...");
            
            // List available algorithms
            String[] kems = KeyEncapsulation.get_enabled_KEMs();
            System.out.println("Available KEMs: " + kems.length);
            for (String kem : kems) {
                System.out.println("  - " + kem);
            }
            
            // Test Kyber768
            System.out.println("\nTesting Kyber768...");
            KeyEncapsulation kem = new KeyEncapsulation("Kyber768");
            
            byte[] publicKey = kem.export_public_key();
            byte[] secretKey = kem.export_secret_key();
            
            System.out.println("Public key size: " + publicKey.length + " bytes");
            System.out.println("Secret key size: " + secretKey.length + " bytes");
            
            // Test encapsulation
            KeyEncapsulation.Ciphertext ct = kem.encap_secret();
            System.out.println("Ciphertext size: " + ct.getCiphertext().length + " bytes");
            System.out.println("Shared secret size: " + ct.getShared_secret().length + " bytes");
            
            kem.dispose();
            
            System.out.println("\n✅ liboqs is working correctly!");
            
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

Compile and run:

```bash
# Compile
javac -cp ~/.m2/repository/org/openquantumsafe/liboqs-java/0.9.0/liboqs-java-0.9.0.jar TestLiboqs.java

# Run
java -cp .:~/.m2/repository/org/openquantumsafe/liboqs-java/0.9.0/liboqs-java-0.9.0.jar TestLiboqs
```

Expected output:
```
Testing liboqs integration...
Available KEMs: 20+
  - Kyber512
  - Kyber768
  - Kyber1024
  - ...

Testing Kyber768...
Public key size: 1184 bytes
Secret key size: 2400 bytes
Ciphertext size: 1088 bytes
Shared secret size: 32 bytes

✅ liboqs is working correctly!
```

### Test 3: Run Crypto Agility Runtime

```bash
cd pqc-crypto-agility
mvn clean package
java -jar target/pqc-crypto-agility-1.0.0-fat.jar
```

Look for these lines in the output:
```
✅ Registered provider: Kyber512 (type: POST_QUANTUM, quantum-safe: true)
✅ Registered provider: Kyber768 (type: POST_QUANTUM, quantum-safe: true)
✅ Registered provider: Kyber1024 (type: POST_QUANTUM, quantum-safe: true)
```

---

## Troubleshooting

### Issue 1: `UnsatisfiedLinkError: no oqs-jni in java.library.path`

**Cause**: Java can't find the native liboqs library.

**Solution**:

```bash
# Linux/macOS
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Or set when running Java
java -Djava.library.path=/usr/local/lib -jar your-app.jar

# Windows
set PATH=%PATH%;C:\Program Files\liboqs\bin
```

### Issue 2: `ClassNotFoundException: org.openquantumsafe.KeyEncapsulation`

**Cause**: liboqs-java not in classpath.

**Solution**:

```bash
# Check Maven dependency
mvn dependency:tree | grep liboqs

# Should show:
# [INFO] +- org.openquantumsafe:liboqs-java:jar:0.9.0:compile
```

### Issue 3: `Provider not available` for Kyber

**Cause**: liboqs not properly installed or not in library path.

**Solution**:

```java
// Check provider availability
KyberProvider kyber = new KyberProvider("Kyber768");
if (!kyber.isAvailable()) {
    System.err.println("Kyber not available - check liboqs installation");
    // The provider will log the specific error
}
```

### Issue 4: Segmentation Fault

**Cause**: Version mismatch between liboqs and liboqs-java.

**Solution**:

```bash
# Rebuild both with matching versions
cd liboqs
git checkout 0.9.0
# rebuild...

cd liboqs-java
git checkout 0.9.0
# rebuild...
```

### Issue 5: Performance Issues

**Cause**: Debug build of liboqs.

**Solution**:

```bash
# Rebuild liboqs with optimizations
cd liboqs/build
cmake -DCMAKE_BUILD_TYPE=Release ..
make clean
make -j$(nproc)
sudo make install
```

---

## Advanced Configuration

### Custom liboqs Build Options

```bash
cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DBUILD_SHARED_LIBS=ON \
      -DOQS_USE_OPENSSL=ON \
      -DOQS_DIST_BUILD=ON \
      -DOQS_USE_CPU_EXTENSIONS=ON \
      -DCMAKE_BUILD_TYPE=Release \
      ..
```

Options:
- `DOQS_USE_OPENSSL=ON`: Use OpenSSL for some operations (faster)
- `DOQS_DIST_BUILD=ON`: Build for distribution (portable)
- `DOQS_USE_CPU_EXTENSIONS=ON`: Use CPU-specific optimizations
- `CMAKE_BUILD_TYPE=Release`: Optimized build

### Docker Setup

```dockerfile
FROM maven:3.9-eclipse-temurin-17

# Install liboqs
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/open-quantum-safe/liboqs.git && \
    cd liboqs && \
    mkdir build && cd build && \
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    ninja && \
    ninja install && \
    cd ../.. && rm -rf liboqs

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Copy and build your application
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

CMD ["java", "-jar", "target/pqc-crypto-agility-1.0.0-fat.jar"]
```

---

## Performance Tuning

### Benchmark liboqs

```bash
cd liboqs/build
./tests/speed_kem
```

### Java Performance Tips

```java
// Reuse KeyEncapsulation objects when possible
private final KeyEncapsulation kem;

public KyberProvider(String variant) {
    this.kem = new KeyEncapsulation(variant);
}

// Remember to dispose when done
@Override
public void close() {
    if (kem != null) {
        kem.dispose();
    }
}
```

---

## Summary

✅ **liboqs provides**: Native C implementation of PQ algorithms  
✅ **liboqs-java provides**: Java JNI wrapper  
✅ **This project provides**: High-level crypto agility runtime  

**Integration Flow**:
1. Install liboqs (native library)
2. Add liboqs-java Maven dependency
3. Use KyberProvider in Crypto Agility Runtime
4. Runtime automatically uses liboqs for PQ operations

**Key Files**:
- `KyberProvider.java`: Integrates with liboqs-java
- `pom.xml`: Declares liboqs-java dependency
- Native library: `/usr/local/lib/liboqs.so` (or `.dylib`, `.dll`)

For more information:
- liboqs: https://github.com/open-quantum-safe/liboqs
- liboqs-java: https://github.com/open-quantum-safe/liboqs-java
- OQS Project: https://openquantumsafe.org/