@echo off
set new=false
set command=false
set delete=false

if %1==c set command=true
if %1==n set new=true
if %1==d set delete=true

if %new% == true start /w docker build -t mynextcloud .
if %new% == true start /w docker-compose up -d

REM run as root 
REM    docker exec -it --user root nextcloud /bin/bash
if %command% == true start docker exec -it --user root nextcloud /bin/bash

REM run as www-data
REM    docker exec -it --user 33 nextcloud /bin/bash
if %command% == true start docker exec -it --user 33 nextcloud /bin/bash

if %delete% == true docker-compose down -v
if %delete% == true docker rm -f $(docker ps -a -q)
if %delete% == true docker volume prune -f
rem if %delete% == true docker image rm -f mynextcloud
if %delete% == true docker system prune
if %delete% == true docker image prune -a -f
