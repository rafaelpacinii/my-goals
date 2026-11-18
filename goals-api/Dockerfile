FROM eclipse-temurin:17-jdk-jammy AS source
WORKDIR /workspace
COPY .mvn/ .mvn/
COPY --chmod=755 mvnw .
COPY pom.xml .
COPY src/ src/

FROM source AS test
RUN --mount=type=cache,target=/root/.m2 ./mvnw -B -ntp test

FROM source AS build
RUN --mount=type=cache,target=/root/.m2 ./mvnw -B -ntp package -DskipTests

FROM eclipse-temurin:17-jre-jammy AS runtime
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --uid 10001 goals
WORKDIR /app
COPY --from=build --chown=10001:10001 /workspace/target/quarkus-app/ ./
USER 10001:10001
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "quarkus-run.jar"]
