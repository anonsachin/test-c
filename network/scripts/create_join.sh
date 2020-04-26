#!/bin/bash

export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/ordrer.track-covid.org/msp/tlscacerts/tlsca.ordrer.track-covid.org-cert.pem
export TLS_ENABLED=true
CHANNEL_NAME="covid-track"
DELAY="3"
function createChannel(){

    set -x
    # peer channel create -o orderer.track-covid.org:7050 --ordererTLSHostnameOverride orderer.track-covid.org -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx  --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls $TLS_ENABLED --cafile $ORDERER_CA
    peer channel create -o orderer.track-covid.org:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx  --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block
    res=$?
    set +x
    if [ $res -ne 0 ]; then
        echo "Failed !!!!!"
        exit 1
    fi

}

function setGlobals() {
    ORG=$1
    # PEER=$2
    if [ $ORG == "companies" ]; then
        CORE_PEER_LOCALMSPID=companiesMSP
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/companies.track-covid.org/users/Admin@companies.track-covid.org/msp
        CORE_PEER_ADDRESS=peer0.companies.track-covid.org:7051
    elif [ $ORG == "ncdc" ]; then
        CORE_PEER_LOCALMSPID=ncdcMSP
        CORE_PEER_ADDRESS=peer0.ncdc.track-covid.org:9051
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/ncdc.track-covid.org/users/Admin@ncdc.track-covid.org/msp
    elif [ $ORG == "test-centres" ]; then
        CORE_PEER_LOCALMSPID=test-centresMSP
        CORE_PEER_ADDRESS=peer0.test-centres.track-covid.org:11051
        CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/test-centres.track-covid.org/users/Admin@test-centres.track-covid.org/msp
    fi

}

function join() {
    ORGS="companies ncdc test-centres"

    for org in $ORGS; do
        setGlobals $org
        sleep $DELAY
        set -x
        peer channel join -b ./channel-artifacts/"$CHANNEL_NAME".block
        res=$?
        set +x
        if [ $res -ne 0 ]; then
            echo "failed"
            exit 1
        fi
    done
}

echo "########## CREATING CHANNEL ###########"
createChannel

sleep $DELAY

echo "######### JOINING CHANNEL #############"
join
