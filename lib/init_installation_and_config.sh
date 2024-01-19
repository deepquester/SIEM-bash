#!/bin/bash

function init_installation_and_config(){
    apt-get update && apt-get upgrade
    #Config mail
    sudo apt-get install msmtp
    #END Config mail
    #Commands
    apt install sysstat -y
    apt install jq -y
    sudo apt-get install libnotify-bin
}

export -f init_installation_and_config