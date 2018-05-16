#!/bin/bash
docker build -t jq22-crawler .
docker run -it -d --name jq22-crawler jq22-crawler /bin/bash
docker exec -it $(docker ps -aqf "name=jq22-crawler") service cron start
