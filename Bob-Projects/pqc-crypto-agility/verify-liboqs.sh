#!/bin/bash

# Verification script for liboqs installation
# Run this to check if liboqs is properly installed and configured

echo "🔍 Verifying liboqs Installation"
echo "================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: liboqs library
echo "1️⃣  Checking liboqs library..."
if [ "$(uname)" == "Darwin" ]; then
    # macOS
    if [ -f "/usr/local/lib/liboqs.dylib" ]; then
        echo -e "${GREEN}✅ Found: /usr/local/lib/liboqs.dylib${NC}"
        ls -lh /usr/local/lib/liboqs.dylib
    else
        echo -e "${RED}❌ Not found: /usr/local/lib/liboqs.dylib${NC}"
        echo "   Install with: brew install liboqs"
        echo "   Or build from source: https://github.com/open-quantum-safe/liboqs"
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Linux
    if [ -f "/usr/local/lib/liboqs.so" ] || [ -f "/usr/lib/liboqs.so" ]; then
        echo -e "${GREEN}✅ Found liboqs.so${NC}"
        find /usr -name "liboqs.so*" 2>/dev/null | head -1 | xargs ls -lh
    else
        echo -e "${RED}❌ Not found: liboqs.so${NC}"
        echo "   Install with: sudo apt-get install liboqs-dev"
        echo "   Or build from source: https://github.com/open-quantum-safe/liboqs"
    fi
fi
echo ""

# Check 2: Library path
echo "2️⃣  Checking library path..."
if [ -n "$LD_LIBRARY_PATH" ]; then
    echo -e "${GREEN}✅ LD_LIBRARY_PATH is set${NC}"
    echo "   $LD_LIBRARY_PATH"
else
    echo -e "${YELLOW}⚠️  LD_LIBRARY_PATH not set${NC}"
    echo "   Add to ~/.bashrc or ~/.zshrc:"
    echo "   export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH"
fi
echo ""

# Check 3: Java
echo "3️⃣  Checking Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo -e "${GREEN}✅ Java found${NC}"
    echo "   $JAVA_VERSION"
    
    # Check Java version
    JAVA_MAJOR=$(java -version 2>&1 | grep -oP 'version "?(1\.)?\K\d+' | head -1)
    if [ "$JAVA_MAJOR" -ge 17 ]; then
        echo -e "${GREEN}✅ Java 17+ detected${NC}"
    else
        echo -e "${RED}❌ Java 17+ required (found Java $JAVA_MAJOR)${NC}"
    fi
else
    echo -e "${RED}❌ Java not found${NC}"
    echo "   Install Java 17+: https://adoptium.net/"
fi
echo ""

# Check 4: Maven
echo "4️⃣  Checking Maven..."
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -version | head -n 1)
    echo -e "${GREEN}✅ Maven found${NC}"
    echo "   $MVN_VERSION"
else
    echo -e "${RED}❌ Maven not found${NC}"
    echo "   Install: https://maven.apache.org/download.cgi"
fi
echo ""

# Check 5: liboqs-java dependency
echo "5️⃣  Checking liboqs-java Maven dependency..."
if [ -f "pom.xml" ]; then
    if grep -q "liboqs-java" pom.xml; then
        echo -e "${GREEN}✅ liboqs-java dependency found in pom.xml${NC}"
        grep -A 2 "liboqs-java" pom.xml | grep version | sed 's/^/   /'
    else
        echo -e "${RED}❌ liboqs-java dependency not found in pom.xml${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  pom.xml not found (run from project root)${NC}"
fi
echo ""

# Check 6: Try to load liboqs-java
echo "6️⃣  Testing liboqs-java loading..."
cat > /tmp/TestLiboqs.java << 'EOF'
public class TestLiboqs {
    public static void main(String[] args) {
        try {
            Class.forName("org.openquantumsafe.KeyEncapsulation");
            System.out.println("SUCCESS");
        } catch (ClassNotFoundException e) {
            System.out.println("FAILED: " + e.getMessage());
        }
    }
}
EOF

if command -v mvn &> /dev/null && [ -f "pom.xml" ]; then
    # Try to compile and run test
    mvn -q dependency:build-classpath -Dmdep.outputFile=/tmp/cp.txt &>/dev/null
    if [ -f /tmp/cp.txt ]; then
        CP=$(cat /tmp/cp.txt)
        javac -cp "$CP" /tmp/TestLiboqs.java 2>/dev/null
        RESULT=$(java -cp "/tmp:$CP" TestLiboqs 2>&1)
        if [ "$RESULT" == "SUCCESS" ]; then
            echo -e "${GREEN}✅ liboqs-java can be loaded${NC}"
        else
            echo -e "${RED}❌ Cannot load liboqs-java${NC}"
            echo "   $RESULT"
        fi
        rm -f /tmp/TestLiboqs.* /tmp/cp.txt
    fi
else
    echo -e "${YELLOW}⚠️  Skipping (Maven or pom.xml not available)${NC}"
fi
echo ""

# Summary
echo "================================"
echo "📋 Summary"
echo "================================"
echo ""
echo "Next steps:"
echo "1. If liboqs is missing, install it:"
echo "   Linux: sudo apt-get install liboqs-dev"
echo "   macOS: brew install liboqs"
echo "   Or build from source: https://github.com/open-quantum-safe/liboqs"
echo ""
echo "2. Set library path (add to ~/.bashrc or ~/.zshrc):"
echo "   export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH"
echo ""
echo "3. Build the project:"
echo "   mvn clean package"
echo ""
echo "4. Run the demo:"
echo "   java -jar target/pqc-crypto-agility-1.0.0-fat.jar"
echo ""
echo "For detailed setup instructions, see LIBOQS_SETUP.md"

# Made with Bob
