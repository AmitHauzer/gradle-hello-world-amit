FROM openjdk:17-jdk-slim

WORKDIR /app

COPY build/libs/gradle-hello-world-amit-*-all.jar ./gradle-hello-world-amit.jar


RUN adduser --disabled-password --gecos "" appuser
USER appuser


ENTRYPOINT ["java", "-jar", "gradle-hello-world-amit.jar"]