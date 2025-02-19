
# Stage 1: build
FROM openjdk:17-jdk-slim AS build

WORKDIR /gradle_hello_world

COPY gradlew build.gradle.kts gradle.properties /gradle_hello_world/
COPY src ./src
COPY gradle ./gradle

RUN ls -al && ./gradlew build --no-daemon

RUN ls -al /gradle_hello_world/build/libs


# Stage 2: runtime stage:
FROM openjdk:17-jdk-slim

WORKDIR /gradle_hello_world
RUN ls -al
COPY --from=build build/libs/*-all.jar app.jar
# debug
RUN echo "only in runtime" && pwd

RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser








# ENTRYPOINT ["java","-jar","app.jar"]
CMD ["java","-jar","app.jar"]