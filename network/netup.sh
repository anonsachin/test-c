#!/bin/bash

IMAGETAG="latest"

IMAGE_TAG=$IMAGETAG docker-compose -f docker-compose.yaml up -d

docker ps -a

sleep 1
echo "############# Waiting for all the containers to start up #################"
sleep 9

echo "##########################################"
echo "########### Creating channel #############"
echo "##########################################"

docker exec cli scripts/create_join.sh

