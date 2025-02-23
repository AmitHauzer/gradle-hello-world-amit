# Stage 1: Build the application using a Gradle image
FROM openjdk:17-jdk-slim AS builder

WORKDIR /gradle-hello-world-amit

ARG VERSION
ENV VERSION=${VERSION}

COPY . .

RUN ./gradlew build \ 
    && ls -al \ 
    && ls -la build/ \ 
    && ls -la build/libs \ 
    && pwd \
    && java -jar build/libs/gradle-hello-world-amit-${VERSION}-all.jar



# Stage 2: Create a minimal runtime image
FROM openjdk:17-jdk-alpine

WORKDIR /gradle-hello-world-amit

ARG VERSION
ENV VERSION=${VERSION}

COPY --from=builder /gradle-hello-world-amit/build/libs/gradle-hello-world-amit-${VERSION}-all.jar gradle-hello-world-amit.jar

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser


ENTRYPOINT ["java", "-jar", "gradle-hello-world-amit.jar"]