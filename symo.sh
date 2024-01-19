#!/bin/bash
#Imports
source "$(dirname "${BASH_SOURCE[0]}")/scopes/sources.sh" 

logging
#alert_metrics "HIGH" "Having keep"
#drop_queue_emails

#tvbp pnna cxvd havf modify_app_config

function main(){
    echo -e "${GREEN}${BOLD}Welcome to Symo [mini-SIEM bash project] by ${RED}${BOLD}Deep=⍜⎊⎈${NC}"
    if [[ -e /usr/local/bin/symo.sh ]]; then
        main_read_system
    else
        init_config
    fi
}