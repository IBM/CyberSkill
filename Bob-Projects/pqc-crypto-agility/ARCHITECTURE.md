# Architecture Documentation

## Overview

The Post-Quantum Crypto Agility Runtime is designed as a flexible, extensible framework for runtime cryptographic algorithm selection and switching. It addresses the critical need for "crypto agility" in the face of quantum computing threats.

## Design Principles

1. **Runtime Flexibility**: Switch algorithms without recompilation or restart
2. **Policy-Driven**: Automatic selection based on threat models and compliance
3. **Defense-in-Depth**: Hybrid mode combines classical and PQ for maximum security
4. **Resilience**: Automatic failover if providers fail
5. **Performance-Aware**: Metrics-driven selection for resource-constrained environments
6. **Standards-Compliant**: Support for NIST PQC standards and compliance frameworks

## Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                   Application Layer                      │
│              (Your Application Code)                     │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Crypto Agility Runtime                      │
│  ┌────────────────────────────────────────────────┐    │
│  │         CryptoAgilityRuntime                   │    │
│  │  - Provider Registry                           │    │
│  │  - Active Provider Management                  │    │
│  │  - Failover Logic                              │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                  Policy Engine                           │
│  ┌────────────────────────────────────────────────┐    │
│  │  - Threat Model Evaluation                     │    │
│  │  - Policy Generation                           │    │
│  │  - Compliance Mapping                          │    │
│  └────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│              Provider Abstraction Layer                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │CryptoProvider│  │CryptoProvider│  │CryptoProvider│ │
│  │  Interface   │  │  Interface   │  │  Interface   │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Classical   │  │Post-Quantum  │  │   Hybrid     │
│  Providers   │  │  Providers   │  │  Providers   │
│              │  │              │  │              │
│ - RSA        │  │ - Kyber      │  │ - RSA+Kyber  │
│ - ECDSA      │  │ - Dilithium  │  │ - ECDSA+Dil  │
│ - AES        │  │ - SPHINCS+   │  │ - Custom     │
└──────────────┘  └──────────────┘  └──────────────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│           Cryptographic Libraries                        │
│  - Bouncy Castle (Classical)                            │
│  - liboqs-java (Post-Quantum)                           │
└─────────────────────────────────────────────────────────┘
```

## Core Components

### 1. CryptoProvider Interface

**Purpose**: Abstract interface for all cryptographic providers

**Key Methods**:
- `generateKeyPair()`: Generate public/private key pair
- `encrypt()/decrypt()`: Data encryption operations
- `sign()/verify()`: Digital signature operations
- `encapsulate()/decapsulate()`: Key Encapsulation Mechanism (KEM)
- `isQuantumSafe()`: Query quantum resistance
- `getPerformanceMetrics()`: Performance characteristics

**Design Pattern**: Strategy Pattern - allows runtime algorithm switching

### 2. CryptoAgilityRuntime

**Purpose**: Central orchestrator for provider management and selection

**Responsibilities**:
- Provider registration and lifecycle management
- Policy-based provider selection
- Active provider tracking
- Automatic failover coordination
- Runtime statistics

**Thread Safety**: Uses `ConcurrentHashMap` and `CopyOnWriteArrayList` for thread-safe operations

**Key Features**:
```java
// Provider selection based on threat model
CryptoProvider selectProvider(ThreatModel threatModel)

// Manual provider switching
boolean switchProvider(String providerName)

// Automatic failover
CryptoProvider failover(Exception cause)
```

### 3. PolicyEngine

**Purpose**: Evaluate threat models and generate crypto policies

**Policy Evaluation Flow**:
```
ThreatModel → PolicyEngine → CryptoPolicy → Provider Selection
```

**Evaluation Criteria**:
1. Quantum threat assessment
2. Data lifetime requirements
3. Compliance requirements (FIPS, CNSA, PCI-DSS, etc.)
4. Performance constraints
5. Security level requirements

**Policy Generation**:
```java
public CryptoPolicy evaluatePolicy(ThreatModel threatModel) {
    // Analyze threat level
    // Check quantum threat
    // Apply compliance rules
    // Generate policy
}
```

### 4. Provider Implementations

#### RSAProvider (Classical)
- **Algorithm**: RSA with OAEP padding
- **Signatures**: RSA-PSS
- **Key Sizes**: 2048, 3072, 4096 bits
- **Security Level**: ~128-256 bits (classical)
- **Quantum Safe**: No
- **Performance**: Fast encryption, slower key generation

#### KyberProvider (Post-Quantum)
- **Algorithm**: Kyber KEM (NIST FIPS 203)
- **Variants**: Kyber512, Kyber768, Kyber1024
- **Security Level**: 128, 192, 256 bits (quantum)
- **Quantum Safe**: Yes
- **Performance**: Very fast operations, larger keys
- **Type**: Lattice-based cryptography

#### HybridProvider (Hybrid)
- **Combines**: Classical + Post-Quantum
- **Security Model**: Secure if EITHER algorithm is unbroken
- **Operations**: Parallel execution of both algorithms
- **Failover**: Automatic fallback to single algorithm if one fails
- **Key Combination**: XOR of shared secrets for KEM

## Data Flow

### Key Encapsulation (KEM) Flow

```
┌─────────────┐
│   Sender    │
└──────┬──────┘
       │
       │ 1. Generate shared secret
       ▼
┌─────────────────────┐
│ encapsulate(pubKey) │
└──────┬──────────────┘
       │
       │ 2. Encrypt shared secret
       ▼
┌─────────────────────┐
│   Ciphertext +      │
│   Shared Secret     │
└──────┬──────────────┘
       │
       │ 3. Send ciphertext
       ▼
┌─────────────┐
│  Receiver   │
└──────┬──────┘
       │
       │ 4. Decrypt with private key
       ▼
┌──────────────────────┐
│ decapsulate(privKey) │
└──────┬───────────────┘
       │
       │ 5. Recover shared secret
       ▼
┌─────────────────────┐
│   Shared Secret     │
└─────────────────────┘
```

### Hybrid Crypto Flow

```
┌──────────────────────────────────────────┐
│         Hybrid Encapsulation             │
└──────────────┬───────────────────────────┘
               │
       ┌───────┴────────┐
       ▼                ▼
┌─────────────┐  ┌─────────────┐
│  Classical  │  │     PQ      │
│ Encapsulate │  │ Encapsulate │
└──────┬──────┘  └──────┬──────┘
       │                │
       │ Secret₁        │ Secret₂
       │                │
       └────────┬───────┘
                ▼
         ┌─────────────┐
         │ XOR Secrets │
         └──────┬──────┘
                │
                ▼
         ┌─────────────┐
         │   Combined  │
         │   Secret    │
         └─────────────┘
```

## Failover Mechanism

### Failover Triggers
1. Provider initialization failure
2. Cryptographic operation exception
3. Performance threshold exceeded
4. Manual failover request

### Failover Strategy

```
Primary Provider Fails
        │
        ▼
┌───────────────────┐
│ Log Failure       │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│ Find Alternative  │
│ Provider          │
└────────┬──────────┘
         │
    ┌────┴────┐
    │ Found?  │
    └────┬────┘
         │
    Yes  │  No
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌────────┐
│Switch  │ │ Throw  │
│Provider│ │Exception│
└────────┘ └────────┘
```

### Hybrid Failover

In hybrid mode, if one component fails:
1. Log the failure
2. Continue with working component
3. Mark hybrid as degraded
4. Optionally switch to pure PQ or classical

## Performance Considerations

### Provider Selection Criteria

1. **Security First**: Meet minimum security requirements
2. **Quantum Safety**: Prefer quantum-safe when required
3. **Performance**: Consider operation time constraints
4. **Key Size**: Balance security vs. bandwidth
5. **Compliance**: Meet regulatory requirements

### Performance Metrics

Each provider exposes:
- Key generation time
- Encryption/decryption time
- Signature/verification time
- Key sizes (public, private)
- Ciphertext/signature sizes

### Optimization Strategies

1. **Lazy Initialization**: Providers initialized on first use
2. **Caching**: Reuse key pairs when appropriate
3. **Parallel Operations**: Hybrid mode can parallelize operations
4. **Provider Pooling**: Multiple instances for high-throughput scenarios

## Security Considerations

### Threat Model

1. **Classical Threats**: Traditional cryptanalysis
2. **Quantum Threats**: Shor's algorithm, Grover's algorithm
3. **Harvest Now, Decrypt Later**: Store encrypted data for future quantum decryption
4. **Side-Channel Attacks**: Timing, power analysis
5. **Implementation Vulnerabilities**: Buffer overflows, memory leaks

### Security Properties

#### Classical Providers
- **Confidentiality**: Based on computational hardness
- **Integrity**: Digital signatures
- **Authentication**: Public key infrastructure
- **Quantum Resistance**: None

#### Post-Quantum Providers
- **Confidentiality**: Quantum-resistant hardness assumptions
- **Integrity**: Quantum-resistant signatures
- **Authentication**: PQ public key infrastructure
- **Quantum Resistance**: Yes (against known quantum algorithms)

#### Hybrid Providers
- **Confidentiality**: Secure if EITHER algorithm is unbroken
- **Integrity**: Both signatures must verify
- **Authentication**: Dual verification
- **Quantum Resistance**: Yes (via PQ component)

### Key Management

- Keys stored in memory only (not persisted by default)
- Support for `Destroyable` interface for secure key erasure
- Separate key pairs for each provider
- Hybrid keys contain both classical and PQ components

## Extensibility

### Adding New Providers

1. Implement `CryptoProvider` interface
2. Register with runtime
3. Provide metadata and performance metrics
4. Handle initialization and availability checks

Example:
```java
public class DilithiumProvider implements CryptoProvider {
    @Override
    public String getAlgorithmName() {
        return "Dilithium3";
    }
    
    @Override
    public ProviderType getProviderType() {
        return ProviderType.POST_QUANTUM;
    }
    
    // Implement other methods...
}

// Register
runtime.registerProvider(new DilithiumProvider());
```

### Custom Threat Models

```java
ThreatModel custom = new ThreatModel.Builder()
    .name("custom-scenario")
    .threatLevel(ThreatModel.ThreatLevel.HIGH)
    .quantumThreat(true)
    .dataLifetimeYears(25)
    .build();
```

### Custom Policies

```java
CryptoPolicy custom = new CryptoPolicy.Builder()
    .requiresQuantumSafe(true)
    .minSecurityLevel(256)
    .maxKeyGenTimeMs(2000)
    .build();
```

## Future Enhancements

1. **Handshake Negotiation Protocol**: Client-server algorithm negotiation
2. **Configuration Files**: YAML/JSON-based provider configuration
3. **Additional Providers**: Dilithium, SPHINCS+, Falcon, NTRU
4. **Hardware Acceleration**: Support for crypto accelerators
5. **Key Persistence**: Secure key storage mechanisms
6. **Monitoring Dashboard**: Real-time provider statistics
7. **A/B Testing**: Gradual rollout of new algorithms
8. **Telemetry**: Usage analytics and performance tracking

## Testing Strategy

1. **Unit Tests**: Individual provider functionality
2. **Integration Tests**: Runtime provider switching
3. **Performance Tests**: Benchmark all providers
4. **Security Tests**: Verify cryptographic correctness
5. **Failover Tests**: Simulate provider failures
6. **Compliance Tests**: Verify regulatory requirements

## Deployment Considerations

### Production Checklist

- [ ] Configure appropriate threat models
- [ ] Register required providers
- [ ] Enable failover for resilience
- [ ] Set up monitoring and logging
- [ ] Test provider availability
- [ ] Verify compliance requirements
- [ ] Benchmark performance
- [ ] Plan migration strategy

### Migration Path

1. **Phase 1**: Deploy with classical providers only
2. **Phase 2**: Add hybrid providers alongside classical
3. **Phase 3**: Gradually shift traffic to hybrid
4. **Phase 4**: Deprecate pure classical for sensitive data
5. **Phase 5**: Full quantum-safe deployment

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-05