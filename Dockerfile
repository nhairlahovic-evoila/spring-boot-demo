# Step 1: Build the application using Maven
FROM maven:3.8.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the pom.xml file separately to leverage Docker's build caching
COPY pom.xml .

# Download dependencies separately to leverage Docker's build caching
RUN mvn -B dependency:go-offline

# Copy the rest of the source code
COPY src/ ./src/

# Build the application
RUN mvn -B clean package -DskipTests=true


#
# Package stage
#
# Step 2: Create the final Docker image with the built application
FROM openjdk:17-jdk-slim-buster AS runtime

WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application's port
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "app.jar"]