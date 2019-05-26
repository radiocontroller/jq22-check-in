#!/bin/bash
docker build -t jq22-check-in .
docker rm -f $(docker ps -aqf "name=jq22-check-in")
docker run -it -d -v /etc/localtime:/etc/localtime --name jq22-check-in jq22-check-in /bin/bash
docker exec -it $(docker ps -aqf "name=jq22-check-in") service cron start
docker rmi $(docker images -f "dangling=true" -q)
