#!/bin/bash

#Imports
source "$(dirname "${BASH_SOURCE[0]}")/reads/system_info.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/reads/system_timestamp.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/reads/cpu_usage.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/reads/memory_usage.sh"
source "$(dirname "${BASH_SOURCE[0]}")/reads/disk_storage.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/reads/network_statistics.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/reads/process_information.sh" 

source "$(dirname "${BASH_SOURCE[0]}")/lib/convert_array_json_from_file.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/make_json_object.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/match_json.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/queue_mechanics.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/notify_local_system.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/alert_metrics.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/convert_to_gb.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/logging.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/init_installation_and_config.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/send_email.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/modify_app_config.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/init_app_config.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/prompt_email_config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib/configure_mail.sh"
source "$(dirname "${BASH_SOURCE[0]}")/lib/main_read_system.sh"

source "$(dirname "${BASH_SOURCE[0]}")/lib/monitors/monitor_disk_usage.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/monitors/monitor_cpu_usage.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/monitors/monitor_network_usage.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/lib/monitors/monitor_memory_usage.sh" 

source "$(dirname "${BASH_SOURCE[0]}")/scopes/variables.sh" 

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