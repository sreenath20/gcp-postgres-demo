# simple & Single stage docker definations

FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]


## 2 Stage docker keeps final image lean with out gradle
## -------------------------------
## Stage 1: Build with Gradle
## -------------------------------
#FROM gradle:8.5-jdk21 AS builder
#
## Copy source code
#WORKDIR /app
#COPY --chown=gradle:gradle . .
#
## Build the application (skip tests to speed up)
#RUN gradle build -x test
#
## -------------------------------
## Stage 2: Run with lightweight JRE
## -------------------------------
#FROM eclipse-temurin:21-jre
#
## Create a non-root user
#RUN useradd -ms /bin/bash appuser
#
## Set working directory
#WORKDIR /app
#
## Copy built JAR from builder stage
#COPY --from=builder /app/build/libs/*.jar app.jar
#
## Set permissions
#RUN chown -R appuser:appuser /app
#
## Use non-root user
#USER appuser
#
## Optional: Expose port 8080
#EXPOSE 8080
#
## Run the application
#ENTRYPOINT ["java", "-jar", "app.jar"]
