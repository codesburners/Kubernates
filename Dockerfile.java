# Java Addition Microservice using locally cached Eclipse Temurin 21 JDK
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY JavaAdditionServer.java Addition.java ./
RUN javac JavaAdditionServer.java Addition.java
EXPOSE 8080
CMD ["java", "-cp", ".", "JavaAdditionServer"]
