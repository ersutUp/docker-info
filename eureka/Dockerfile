
FROM maven:3.6-openjdk-17 as build

ADD eureka-server /tmp/eureka-server

RUN cd /tmp/eureka-server && mvn package -DskipTests

FROM eclipse-temurin:17-jdk

WORKDIR /opt

COPY --from=build /tmp/eureka-server/target/eureka-server.jar /opt/app.jar

EXPOSE 8761

CMD ["java","-jar","app.jar"]