# Open Quantum Safe (liboqs) Setup Guide

## Overview

This application can use **liboqs-java** for real Kyber KEM implementation. liboqs is the industry-standard library for post-quantum cryptography, developed by the Open Quantum Safe project.

## Prerequisites

### 1. Install liboqs Native Library

#### Windows
```powershell
# Using vcpkg (recommended)
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg install liboqs:x64-windows

# Add to PATH
$env:PATH += ";C:\path\to\vcpkg\installed\x64-windows\bin"
```

#### Linux (Ubuntu/Debian)
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install cmake gcc ninja-build libssl-dev python3-pytest python3-pytest-xdist unzip xsltproc doxygen graphviz

# Build and install liboqs
git clone -b main https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local ..
ninja
sudo ninja install
sudo ldconfig
```

#### macOS
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

### 2. Install liboqs-java

```bash
# Clone liboqs-java
git clone https://github.com/open-quantum-safe/liboqs-java.git
cd liboqs-java

# Build and install
./gradlew build
./gradlew publishToMavenLocal
```

## Maven Configuration

Add to your `pom.xml`:

```xml
<dependency>
    <groupId>org.openquantumsafe</groupId>
    <artifactId>liboqs-java</artifactId>
    <version>0.1.0-SNAPSHOT</version>
</dependency>
```

## Verification

Test that liboqs is properly installed:

```bash
# Check library
# Linux/macOS
ls -l /usr/local/lib/liboqs.*

# Windows
dir C:\path\to\vcpkg\installed\x64-windows\bin\oqs.dll
```

## Alternative: Docker Deployment

For easier deployment, use Docker with pre-built liboqs:

```dockerfile
FROM ubuntu:22.04

# Install liboqs
RUN apt-get update && apt-get install -y \
    cmake gcc ninja-build libssl-dev \
    && git clone https://github.com/open-quantum-safe/liboqs.git \
    && cd liboqs && mkdir build && cd build \
    && cmake -GNinja .. && ninja && ninja install \
    && ldconfig

# Install Java
RUN apt-get install -y openjdk-11-jdk maven

# Copy application
COPY . /app
WORKDIR /app

# Build and run
RUN mvn clean package
CMD ["java", "-jar", "target/pqc-file-encryptor-1.0.0-fat.jar"]
```

## Troubleshooting

### Library Not Found
```bash
# Linux: Add to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# macOS: Add to DYLD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH

# Windows: Add to PATH
set PATH=%PATH%;C:\path\to\liboqs\bin
```

### Java Native Library Error
```bash
# Specify library path when running
java -Djava.library.path=/usr/local/lib -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

## Supported Algorithms

liboqs supports multiple PQC algorithms:
- **Kyber512, Kyber768, Kyber1024** (KEM)
- Dilithium (Signatures)
- SPHINCS+ (Signatures)
- And many more...

## Performance

liboqs provides highly optimized implementations:
- Hardware acceleration (AVX2, AES-NI)
- Constant-time operations
- Production-ready security

## Resources

- [liboqs GitHub](https://github.com/open-quantum-safe/liboqs)
- [liboqs-java GitHub](https://github.com/open-quantum-safe/liboqs-java)
- [OQS Documentation](https://openquantumsafe.org/)