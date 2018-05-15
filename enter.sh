#!/bin/bash
docker exec -it $(docker ps -aqf "name=jq22-crawler") /bin/bash
