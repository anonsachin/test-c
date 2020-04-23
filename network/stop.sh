#!/bin/bash

docker-compose down --volume --remove-orphans

if [ -d "channel-artifacts" ]; then
    echo "########## removing the artifacts ###########"
    rm -Rf channel-artifacts
fi

if [ -d "crypto-config" ]; then
    echo "########## removing crypto materials ###########"
    rm -Rf crypto-config
fi