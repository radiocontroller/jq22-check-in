#!/bin/bash
docker build -t jq22-check-in .
docker run -it -d --name jq22-check-in jq22-check-in /bin/bash
docker exec -it $(docker ps -aqf "name=jq22-check-in") service cron start
