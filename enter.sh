#!/bin/bash
docker exec -it $(docker ps -aqf "name=jq22-check-in") /bin/bash
