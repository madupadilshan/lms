# Backend Dockerfile - Multi-stage build
FROM eclipse-temurin:17-jdk-alpine AS build

WORKDIR /app

# Install dos2unix for line ending conversion
RUN apk add --no-cache dos2unix

# Copy maven wrapper and pom
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Fix line endings and make executable
RUN dos2unix mvnw && chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src src

# Build the application with Spring Boot plugin
RUN ./mvnw clean package spring-boot:repackage -DskipTests

# Production stage
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
