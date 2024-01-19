#!/bin/bash

function monitor_cpu_usage(){
    a="/var/log/symo/13:42:06::30:12:2023"
    idle=$(cat "$a/cpu.smlog" | jq '.idle')
    cpu_utilization=$(echo "100 - $idle" | bc -l)
    if [[ $cpu_utilization > 80 ]]; then   
        alert_metrics "MEDIUM" "CPU Utilization is High! Metrics=$cpu_utilization%"
        #return 0    
    fi
    alert_metrics "SAVE"
    return 1
}

export -f monitor_cpu_usage