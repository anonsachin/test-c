#!/bin/bash

export PATH=${PATH}:${PWD}/bin
export FABRIC_CFG_PATH=${PWD}

CHANNEL_NAME="covid-track"
DELAY="3"

function generateCerts() {
    which cryptogen
    if [ "$?" -ne 0 ]; then
        echo "cryptogen not present"
        exit 1
    fi

    echo "##########################################"
    echo "######### Generating Certs ###############"
    echo "##########################################"

    if [ -d "crypto-config" ]; then
        rm -Rf crypto-config
    fi

    cryptogen generate --config=./crypto-config.yaml

}

function generateArtifacts() {
    which configtxgen
    if [ "$?" -ne 0 ]; then
        echo "configtxgen not found"
        exit 1
    fi

    if [ ! -d "channel-artifacts" ]; then
        mkdir channel-artifacts
    fi
    echo "##########################################"
    echo "######### Generating Artifatcs ###########"
    echo "##########################################"

    echo "######### Generating genesis block ###########"
    echo
    set -x
    configtxgen -profile Genesis -outputBlock ./channel-artifacts/genesis.block -channelID sys-channel
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed !!!!!"
        exit 1
    fi

    echo "######### Generating channel tx ###########"
    echo
    set -x
    configtxgen -profile TestChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed !!!!!"
        exit 1
    fi
    
    echo "######### Generating anchor peer tx ###########"
    echo
    for org in companies ncdc test-centres; do

        echo "############### org = ${org} ###############"
        set -x
        configtxgen -profile TestChannel -outputAnchorPeersUpdate ./channel-artifacts/${org}anchors.tx -channelID $CHANNEL_NAME -asOrg ${org}
        res=$?
        set +x
        if [ $res -ne 0 ]; then
            echo "Failed !!!!!"
            exit 1
        fi
        echo
    done
}

generateCerts
generateArtifacts