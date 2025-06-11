
# Stage 1: Build the application
FROM gradle:8.4-jdk17 AS builder

# Copy project files to container
COPY . /app

# Run Gradle build
RUN cd /app && gradle clean build -x test

# Stage 2: Run the application
FROM eclipse-temurin:17-jre

# Copy the JAR from the builder stage
COPY --from=builder /app/build/libs/*.jar /app/app.jar

# Expose application port (optional, e.g., 8080)
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
