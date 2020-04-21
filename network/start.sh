export PATH=${PATH}:${PWD}/bin
export FABRIC_CFG_PATH=${PWD}

function generate() {
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

generate