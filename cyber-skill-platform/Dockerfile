# Multi-stage build for CyberSkill Platform

# Stage 1: Build
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /build

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 cyberskill && \
    adduser -D -u 1001 -G cyberskill cyberskill

# Copy the fat JAR from builder stage
COPY --from=builder /build/target/cyberskill-platform-*-fat.jar /app/cyberskill-platform.jar

# Copy resources
COPY --from=builder /build/src/main/resources /app/resources

# Create directories for logs, certificates, and content
RUN mkdir -p /app/logs /app/certificates /app/content && \
    chown -R cyberskill:cyberskill /app

# Switch to non-root user
USER cyberskill

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/health || exit 1

# Run the application
ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/cyberskill-platform.jar"]