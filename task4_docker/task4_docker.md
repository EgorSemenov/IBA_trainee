  ---------
  1.1
  ---------
  [egS@loca
  lhost
  \~]\#
  docker ps
  -a
  CONTAINER
  ID IMAGE
  COMMAND
  CREATED
  STATUS
  PORTS
  NAMES
  510ad2266
  95a
  f
  "/docker-
  entrypoin
  t.…"
  About a
  minute
  ago Up
  About a
  minute
  80/tcp
  loving\_y
  onath
  0a0fdeb21
  2db
  f
  "/docker-
  entrypoin
  t.…"
  About a
  minute
  ago
  Exited
  (0) 3
  seconds
  ago
  pedantic\
  _tereshko
  va
  1e14c6c78
  99d
  f
  "/docker-
  entrypoin
  t.…"
  About a
  minute
  ago
  Exited
  (0) 12
  seconds
  ago
  peaceful\
  _mahavira
  ---------

1.2
---

[egS@localhost \~]\# docker images REPOSITORY TAG IMAGE ID CREATED SIZE
[egS@localhost \~]\# docker ps -a CONTAINER ID IMAGE COMMAND CREATED
STATUS PORTS NAMES --------- 1.3 --------- [egS@localhost \~]\# docker
run -d devopsdockeruh/exec\_bash\_exercise\
[egS@localhost \~]\# docker exec -it 3 tail -f ./logs.txt Secret message
is: "Docker is easy" /* 'run' try to find image locally, if no such
image, try to find on docker hub '-d' -detached '-it' - creating an
interactive bash shell in the container 'tail' - gives 10 row '-f' -
repeat if rows added */ --------- 1.4 --------- [egS@localhost \~]\#
docker run devopsdockeruh/overwrite\_cmd\_exercise Dockerfile: FROM
devopsdockeruh/overwrite\_cmd\_exercise CMD ["-c"] Comands:
[egS@localhost \~]\# docker build -t docker-sequence . [egS@localhost
\~]\# docker run docker-sequence result: 1 2 3 4 5 . . . --------- 1.5
--------- [egS@localhost \~]\$ docker run -d -v
/home/egS/Documents/logs.txt:/usr/app/logs.txt
devopsdockeruh/first\_volume\_exercise --------- 1.6 ---------
[egS@localhost \~]\$ docker run -d -p 127.0.0.1:4400:80
devopsdockeruh/ports\_exercise /*host port was choosen randomly in
browser: Ports configured correctly!!*/ --------- 1.7 ---------
Dockerfile: FROM node:10 WORKDIR /usr/src/app RUN git clone
https://github.com/docker-hy/frontend-example-docker.git WORKDIR
./frontend-example-docker EXPOSE 5000 RUN npm install &&\
 npm run build &&\
 npm install -g serve ENTRYPOINT serve -s -l 5000 dist CMD Comand:
[egS@localhost \~]\$ docker run -it -p 5000:5000 frontapp --------- 1.8
--------- Dockerfile: FROM openjdk:8 WORKDIR /usr/src/app RUN git clone
https://github.com/docker-hy/spring-example-project.git WORKDIR
./spring-example-project RUN ./mvnw package EXPOSE 8080 ENTRYPOINT
["java", "-jar", "./target/docker-example-1.1.3.jar"] Comand:
[egS@localhost \~]\$ docker run -it -p 8080:8080 springproject
