#!/usr/bin/env bash

function updateRepo {
    if [ $# -ne 2 ]; then
        echo "Usage: updateRepo <home-dir> <repo-name>"
        exit 1
    fi
    local HOME=$1
    local REPO=$2
    echo "Updating repo $REPO at $HOME"
    cd $HOME
    if [ ! -d $REPO ]; then
        # clone repo, if it hasn't already been cloned
        git clone https://github.com/MCLDG/$REPO.git
    else
        # update repo, if it has already been cloned
        cd $REPO
        git pull
    fi
    cd $HOME
}

function genTemplates {
    if [ $# -ne 2 ]; then
        echo "Usage: genTemplates <home-dir> <repo-name>"
        exit 1
    fi
    local HOME=$1
    local REPO=$2
    echo "Generating K8s YAML deployment files"
    cd $HOME/$REPO
    ./gen-fabric.sh
}

function makeDirs {
    if [ $# -ne 1 ]; then
        echo "Usage: makeDirs <data-dir - probably something like /opt/share>"
        echo "input args are '$@'"
        exit 1
    fi
    local DATA=$1
    echo "Making directories at $DATA"
    cd $DATA
    mkdir -p rca-data
    mkdir -p rca-scripts
    mkdir -p orderer
}

function copyScripts {
    if [ $# -ne 3 ]; then
        echo "Usage: copyScripts <home-dir> <repo-name> <data-dir - probably something like /opt/share>"
        exit 1
    fi
    local HOME=$1
    local REPO=$2
    local DATA=$3
    echo "Copying scripts folder from $REPO to $DATA"
    cd $HOME
    sudo cp $HOME/$REPO/scripts/* $DATA/rca-scripts/
    sudo chmod 777 $DATA/rca-scripts/gen-channel-artifacts.sh
}
