#!/bin/bash

function monitor_cpu_usage(){
    a="$(dirname "${BASH_SOURCE[0]}")/../../logs/16:00:55::11:02:2024"
    idle=$(cat "$a/cpu.smlog" | jq '.idle')
    cpu_utilization=$(echo "100 - $idle" | bc -l)
    if [[ $cpu_utilization > 80 ]]; then   
        alert_metrics "HIGH" "CPU Utilization is High! Metrics=$cpu_utilization%"
        alert_metrics "HIGH" "CPU Utilization is High! Metrics=$cpu_utilization%"
        
    elif [[ $cpu_utilization > 50 ]]; then
        alert_metrics "MEDIUM" "CPU Utilization is Peaking! Metrics=$cpu_utilization%"
    fi
    notify_local_system "queue" "HIGH"
    return 0
}
#example notify local system
export -f monitor_cpu_usage