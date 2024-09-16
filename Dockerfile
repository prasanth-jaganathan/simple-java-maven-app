FROM maven:latest as maven-stage
WORKDIR /app
COPY pom.xml .
COPY ./src/ ./src/
RUN mvn clean install

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=maven-stage /app/target/my-app-1.0-SNAPSHOT.jar my-app-1.0-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "my-app-1.0-SNAPSHOT.jar"]


