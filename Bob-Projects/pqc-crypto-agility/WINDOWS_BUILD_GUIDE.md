# Windows Build Guide

Quick guide for building the Crypto Agility Runtime on Windows.

## Prerequisites Check

Before building, ensure you have:
- ✅ Java 17+ installed
- ✅ Maven 3.6+ installed
- ✅ liboqs built and installed (oqs.dll)

## Common Issues and Solutions

### Issue 1: "The requested profile 'windows' could not be activated"

**Cause**: You're trying to use a Maven profile that doesn't exist in this project.

**Solution**: This project doesn't need a Windows-specific profile. Just use:
```cmd
mvn clean package
```

### Issue 2: "No POM in this directory"

**Cause**: You're running Maven from the wrong directory (e.g., liboqs/build).

**Solution**: Navigate to the pqc-crypto-agility directory:
```cmd
cd C:\Users\I74350754\Documents\Development\pqc-crypto-agility
mvn clean package
```

### Issue 3: "UnsatisfiedLinkError: no oqs-jni in java.library.path"

**Cause**: Java can't find oqs.dll.

**Solution**: Add liboqs to your PATH or specify it when running:
```cmd
REM Option 1: Add to PATH permanently
setx PATH "%PATH%;C:\Program Files\liboqs\bin"
REM Then restart terminal

REM Option 2: Specify when running
java -Djava.library.path="C:\Program Files\liboqs\bin" -jar target\pqc-crypto-agility-1.0.0-fat.jar
```

## Step-by-Step Build Instructions

### Step 1: Navigate to Project Directory
```cmd
cd C:\Users\I74350754\Documents\Development\pqc-crypto-agility
```

### Step 2: Verify You're in the Right Place
```cmd
dir pom.xml
REM Should show pom.xml file
```

### Step 3: Run Verification Script
```cmd
verify-liboqs.bat
```

This will check:
- Java installation
- Maven installation
- liboqs installation
- Dependencies

### Step 4: Build the Project
```cmd
mvn clean package
```

Expected output:
```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------< com.pqc:pqc-crypto-agility >-----------------
[INFO] Building PQC Crypto Agility Runtime 1.0.0
[INFO] --------------------------------[ jar ]---------------------------------
...
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

### Step 5: Run the Demo
```cmd
REM If liboqs is in PATH
java -jar target\pqc-crypto-agility-1.0.0-fat.jar

REM If liboqs is NOT in PATH
java -Djava.library.path="C:\Program Files\liboqs\bin" -jar target\pqc-crypto-agility-1.0.0-fat.jar
```

## Troubleshooting Build Errors

### Error: "Failed to execute goal... compilation failure"

**Check Java version**:
```cmd
java -version
REM Should show Java 17 or higher
```

**If Java version is wrong**:
1. Download Java 17+ from https://adoptium.net/
2. Set JAVA_HOME:
```cmd
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.x"
setx PATH "%PATH%;%JAVA_HOME%\bin"
```

### Error: "Could not resolve dependencies"

**Solution**:
```cmd
REM Force update dependencies
mvn clean install -U

REM Or clear Maven cache and retry
rmdir /s /q %USERPROFILE%\.m2\repository\org\openquantumsafe
mvn clean package
```

### Error: "Package org.openquantumsafe does not exist"

**Cause**: liboqs-java dependency not downloaded.

**Solution**:
```cmd
REM Check if dependency exists
dir %USERPROFILE%\.m2\repository\org\openquantumsafe\liboqs-java

REM If not, force download
mvn dependency:resolve -U
mvn clean package
```

## Running Tests

### Run All Tests
```cmd
mvn test
```

### Run Specific Test
```cmd
mvn test -Dtest=CryptoAgilityRuntimeTest
```

### Skip Tests (if liboqs not available)
```cmd
mvn clean package -DskipTests
```

## Building Without liboqs

If you want to build the project but don't have liboqs installed yet:

```cmd
REM Build without running tests
mvn clean package -DskipTests

REM The project will build successfully
REM RSA provider will work
REM Kyber provider will show as "not available"
```

## Directory Structure

Make sure you're in the right directory:

```
C:\Users\I74350754\Documents\Development\
├── liboqs\                          ← liboqs source (don't run Maven here!)
│   └── build\                       ← CMake build directory
│       └── bin\
│           └── oqs.dll              ← The DLL you built
│
└── pqc-crypto-agility\              ← Run Maven HERE!
    ├── pom.xml                      ← Maven project file
    ├── verify-liboqs.bat            ← Run this first
    ├── src\
    │   └── main\
    │       └── java\
    │           └── com\pqc\agility\
    └── target\                      ← Created after build
        └── pqc-crypto-agility-1.0.0-fat.jar
```

## Quick Commands Reference

```cmd
REM Navigate to project
cd C:\Users\I74350754\Documents\Development\pqc-crypto-agility

REM Verify setup
verify-liboqs.bat

REM Build
mvn clean package

REM Run demo
java -jar target\pqc-crypto-agility-1.0.0-fat.jar

REM Run with explicit library path
java -Djava.library.path="C:\Program Files\liboqs\bin" -jar target\pqc-crypto-agility-1.0.0-fat.jar

REM Run simple example
java -cp target\pqc-crypto-agility-1.0.0-fat.jar com.pqc.agility.examples.SimpleEncryptionApp

REM Run tests
mvn test

REM Clean build
mvn clean
```

## Environment Variables

Set these for easier usage:

```cmd
REM Java (if not already set)
setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-17.0.x"

REM Maven (if not already set)
setx MAVEN_HOME "C:\Program Files\Apache\maven"

REM liboqs
setx LIBOQS_HOME "C:\Program Files\liboqs"

REM Update PATH
setx PATH "%PATH%;%JAVA_HOME%\bin;%MAVEN_HOME%\bin;%LIBOQS_HOME%\bin"

REM Restart terminal after setting these
```

## Verification Checklist

Before building, verify:

- [ ] You're in `pqc-crypto-agility` directory (not `liboqs`)
- [ ] `pom.xml` exists in current directory
- [ ] Java 17+ is installed (`java -version`)
- [ ] Maven is installed (`mvn -version`)
- [ ] liboqs DLL exists (`dir "C:\Program Files\liboqs\bin\oqs.dll"`)
- [ ] PATH includes liboqs or you'll use `-Djava.library.path`

## Getting Help

If you're still having issues:

1. Run `verify-liboqs.bat` and check all items
2. Check the error message carefully
3. Verify you're in the correct directory
4. Check Java and Maven versions
5. See LIBOQS_SETUP.md for detailed troubleshooting

## Success Indicators

You'll know it's working when you see:

```
=== Post-Quantum Crypto Agility Runtime Demo ===

Registering cryptographic providers...
✅ Registered provider: RSA-2048 (type: CLASSICAL, quantum-safe: false)
✅ Registered provider: Kyber768 (type: POST_QUANTUM, quantum-safe: true)
✅ Registered provider: Hybrid-RSA-2048-Kyber768 (type: HYBRID, quantum-safe: true)
```

If Kyber shows as "not available", check liboqs installation and PATH.