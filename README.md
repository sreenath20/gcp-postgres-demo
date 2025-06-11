Spring Boot + GCP Cloud SQL (PostgreSQL) Deployment Guide

Step 1: Create Cloud SQL PostgreSQL

In Cloud Shell[set environment variables]:

export INSTANCE_NAME=my-postgres
export REGION=us-central1
export DB_NAME=mydb
export DB_USER=postgres
export DB_PASS=MyPassword123

[if db not created in gcp cloud SQL create using gcloud cli]
gcloud sql instances create $INSTANCE_NAME \
--database-version=POSTGRES_14 \
--cpu=1 --memory=4GB \
--region=$REGION \
--root-password=$DB_PASS

gcloud sql databases create $DB_NAME --instance=$INSTANCE_NAME

Step 2: Configure application.properties

spring.datasource.url=jdbc:postgresql:///mydb?cloudSqlInstance=PROJECT_ID:us-central1:my-postgres&socketFactory=com.google.cloud.sql.postgres.SocketFactory
spring.datasource.username=postgres
spring.datasource.password=MyPassword123
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.hibernate.ddl-auto=update

Step 3: Add Dependencies

<dependency>
<groupId>org.postgresql</groupId>
<artifactId>postgresql</artifactId>
</dependency>
<dependency>
<groupId>com.google.cloud.sql</groupId>
<artifactId>postgres-socket-factory</artifactId>
<version>1.10.0</version>
</dependency>

Step 4: Dockerfile

FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

Step 5: Push Image to Artifact Registry

gcloud artifacts repositories create springboot-repo \
--repository-format=docker \
--location=us-central1
gcloud builds submit --tag us-central1-docker.pkg.dev/$PROJECT_ID/springboot-repo/myapp
Spring Boot + GCP Cloud SQL (PostgreSQL) Deployment Guide

Step 6: Create Service Account

gcloud iam service-accounts create springboot-cloudrun-sa \
--display-name "Spring Boot Cloud Run SA"
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:springboot-cloudrun-sa@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/cloudsql.client"

Step 7: Deploy to Cloud Run

gcloud run deploy springboot-api \
--image=us-central1-docker.pkg.dev/$PROJECT_ID/springboot-repo/myapp \
--platform=managed \
--region=us-central1 \
--allow-unauthenticated \
--add-cloudsql-instances=$PROJECT_ID:us-central1:my-postgres \
--service-account=springboot-cloudrun-sa@$PROJECT_ID.iam.gserviceaccount.com \
--set-env-vars=SPRING_PROFILES_ACTIVE=prod

Step 8: Verify & Logs

Use the deployed URL to access the app.
View logs:
gcloud logs read --limit=50

Optional: Clean Up
gcloud run services delete springboot-api --region=us-central1
gcloud sql instances delete my-postgres
