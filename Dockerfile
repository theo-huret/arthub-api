FROM maven:3.8-eclipse-temurin-17-alpine as builder

WORKDIR /app

COPY . .

RUN mvn -Pdocker -DskipTests clean install

FROM openjdk:17-alpine

ARG JAR_FILE=arthub*.jar

WORKDIR /app
COPY --from=builder /app/target/${JAR_FILE} /app/arthub.jar

RUN addgroup --gid 1001 app && \
    adduser --home /app --shell /bin/sh --system --ingroup app -u 1001 app

USER app

WORKDIR /app

EXPOSE 8080

ENTRYPOINT java -jar arthub.jar