FROM centos:latest
ARG path_to_jar=./target
RUN yum install java-1.8.0-openjdk.x86_64 -y
ADD ${path_to_jar}/demo-0.0.1-SNAPSHOT.jar /usr/lib/
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1
WORKDIR /usr/lib
EXPOSE 8080
ENTRYPOINT java -jar demo-0.0.1-SNAPSHOT.jar
