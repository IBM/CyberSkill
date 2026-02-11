# OQS Provider Integration Guide

This guide explains how to integrate the Open Quantum Safe (OQS) Provider with the PQC Domain Scanner for enhanced quantum-safe cryptography detection and testing.

## What is OQS Provider?

The [OQS Provider](https://github.com/open-quantum-safe/oqs-provider) is an OpenSSL 3 provider that enables quantum-safe cryptographic algorithms. It's part of the Open Quantum Safe project, which aims to support the development and prototyping of quantum-resistant cryptography.

## Supported Algorithms

The OQS Provider supports NIST-standardized and candidate PQC algorithms:

### Key Encapsulation Mechanisms (KEMs)
- **ML-KEM** (Kyber) - NIST standardized
- NTRU
- SABER
- FrodoKEM
- BIKE
- HQC

### Digital Signatures
- **ML-DSA** (Dilithium) - NIST standardized
- **SLH-DSA** (SPHINCS+) - NIST standardized
- Falcon
- Rainbow
- Picnic

## Installation

### Prerequisites

```bash
# Install OpenSSL 3.0+
# Ubuntu/Debian
sudo apt-get install openssl libssl-dev

# macOS
brew install openssl@3

# Windows
# Download from https://slproweb.com/products/Win32OpenSSL.html
```

### Install liboqs

```bash
# Clone liboqs
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs

# Build and install
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc)
sudo make install
```

### Install OQS Provider

```bash
# Clone oqs-provider
git clone https://github.com/open-quantum-safe/oqs-provider.git
cd oqs-provider

# Build and install
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
make -j$(nproc)
sudo make install
```

### Configure OpenSSL

Edit OpenSSL configuration (usually `/etc/ssl/openssl.cnf` or `/usr/local/ssl/openssl.cnf`):

```ini
[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
oqsprovider = oqsprovider_sect

[default_sect]
activate = 1

[oqsprovider_sect]
activate = 1
```

## Testing OQS Provider

### Test Installation

```bash
# List available algorithms
openssl list -providers -provider oqsprovider

# Test connection with PQC
openssl s_client -connect pqc.example.com:443 -provider oqsprovider
```

### Create Test Server with PQC

```bash
# Generate PQC key pair (Dilithium3)
openssl genpkey -algorithm dilithium3 -out server_key.pem -provider oqsprovider

# Generate self-signed certificate
openssl req -new -x509 -key server_key.pem -out server_cert.pem -days 365 \
  -provider oqsprovider -subj "/CN=localhost"

# Start test server
openssl s_server -cert server_cert.pem -key server_key.pem \
  -accept 4433 -provider oqsprovider
```

## Integration with PQC Scanner

### Method 1: Enhanced Detection (Recommended)

The scanner already detects PQC algorithms by analyzing certificate properties. With OQS Provider installed, it will automatically recognize OQS-specific algorithm identifiers.

**No code changes needed** - the scanner's algorithm detection in `DomainScanner.java` will identify:
- ML-KEM (Kyber)
- ML-DSA (Dilithium)
- SLH-DSA (SPHINCS+)
- Falcon
- And other OQS algorithms

### Method 2: Java Integration

For deeper integration, add OQS support to Java:

#### Add Bouncy Castle PQC Provider

Update `pom.xml`:

```xml
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcpqc-jdk18on</artifactId>
    <version>1.77</version>
</dependency>
```

#### Register Provider in MainVerticle.java

```java
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;

public class MainVerticle extends AbstractVerticle {
    @Override
    public void start(Promise<Void> startPromise) {
        // Register PQC provider
        Security.addProvider(new BouncyCastlePQCProvider());
        
        // ... rest of initialization
    }
}
```

### Method 3: External OQS Scanner Integration

Create a wrapper script that uses OQS tools:

```bash
#!/bin/bash
# oqs-scan.sh - Scan domain with OQS provider

DOMAIN=$1
PORT=${2:-443}

echo "Scanning $DOMAIN:$PORT with OQS Provider..."

# Test connection
openssl s_client -connect $DOMAIN:$PORT \
  -provider oqsprovider \
  -showcerts \
  2>&1 | grep -E "(Protocol|Cipher|Signature Algorithm)"

# Check for PQC algorithms
if openssl s_client -connect $DOMAIN:$PORT -provider oqsprovider 2>&1 | \
   grep -qE "(kyber|dilithium|falcon|sphincs)"; then
    echo "✓ PQC algorithms detected"
else
    echo "✗ No PQC algorithms found"
fi
```

Make executable and use:

```bash
chmod +x oqs-scan.sh
./oqs-scan.sh example.com
```

## Testing PQC-Enabled Domains

### Public Test Servers

Test the scanner against these OQS-enabled test servers:

```
test.openquantumsafe.org
pqc.cloudflare.com (experimental)
```

### Local Test Setup

1. **Start OQS Test Server**:
```bash
# Terminal 1
openssl s_server -cert server_cert.pem -key server_key.pem \
  -accept 4433 -provider oqsprovider -www
```

2. **Add to Scanner**:
```bash
# Add localhost:4433 to scanner
curl -X POST http://localhost:8080/api/domains \
  -H "Content-Type: application/json" \
  -d '{"domain":"localhost:4433"}'
```

3. **Scan**:
```bash
curl -X POST http://localhost:8080/api/scan/localhost:4433
```

## Enhanced Configuration

Update `config.json` to include OQS-specific algorithms:

```json
{
  "scanner": {
    "quantumSafeAlgorithms": [
      "KYBER", "KYBER512", "KYBER768", "KYBER1024",
      "ML-KEM", "ML-KEM-512", "ML-KEM-768", "ML-KEM-1024",
      "DILITHIUM", "DILITHIUM2", "DILITHIUM3", "DILITHIUM5",
      "ML-DSA", "ML-DSA-44", "ML-DSA-65", "ML-DSA-87",
      "FALCON", "FALCON-512", "FALCON-1024",
      "SPHINCS", "SPHINCSPLUS", "SLH-DSA",
      "NTRU", "SABER", "FRODOKEM",
      "BIKE", "HQC", "RAINBOW", "PICNIC"
    ],
    "oqsEnabled": true,
    "oqsProviderPath": "/usr/local/lib/oqsprovider.so"
  }
}
```

## Verification

### Verify OQS Integration

```bash
# Check if OQS provider is available
openssl list -providers

# Should show:
# Providers:
#   default
#   oqsprovider

# Test PQC algorithm
openssl list -signature-algorithms -provider oqsprovider | grep -i dilithium
```

### Test Scanner Detection

1. Scan a PQC-enabled domain
2. Check the results show PQC algorithm types
3. Verify `is_pqc_ready` is `true`
4. Check `pqc_algorithm_type` shows the correct algorithm

## Troubleshooting

### OQS Provider Not Found

```bash
# Check provider location
find /usr -name "oqsprovider.so" 2>/dev/null

# Update OpenSSL config with correct path
[oqsprovider_sect]
module = /path/to/oqsprovider.so
activate = 1
```

### Algorithm Not Recognized

- Ensure OQS provider is activated in OpenSSL config
- Check algorithm name matches OQS naming convention
- Update `quantumSafeAlgorithms` in config.json

### Connection Failures

- Verify target server supports PQC
- Check firewall allows outbound connections
- Increase timeout in scanner config

## Advanced Features

### Custom Algorithm Detection

Extend `DomainScanner.java` to use OQS-specific detection:

```java
private boolean isOQSAlgorithm(String algorithm) {
    // Check against OQS algorithm registry
    return algorithm.matches("(?i).*(kyber|dilithium|falcon|sphincs|ml-kem|ml-dsa|slh-dsa).*");
}
```

### Performance Optimization

For scanning many domains with OQS:

```json
{
  "scanner": {
    "maxConcurrentScans": 10,
    "oqsCacheEnabled": true,
    "oqsCacheTTL": 3600
  }
}
```

## Resources

- [OQS Provider GitHub](https://github.com/open-quantum-safe/oqs-provider)
- [liboqs Documentation](https://github.com/open-quantum-safe/liboqs)
- [NIST PQC Standards](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [OpenSSL Provider Documentation](https://www.openssl.org/docs/man3.0/man7/provider.html)

## Contributing

To contribute OQS integration improvements:

1. Test with various OQS algorithms
2. Document detection accuracy
3. Submit pull requests with enhancements
4. Report issues with specific algorithm detection

---

**Note**: OQS Provider is for research and prototyping. Production use should follow NIST standardization guidance.