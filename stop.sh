#!/bin/bash
docker rm -f $(docker ps -aqf "name=jq22-crawler")
