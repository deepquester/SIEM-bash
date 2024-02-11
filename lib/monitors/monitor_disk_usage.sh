#!/bin/bash

function monitor_disk_usage(){
    a="$(dirname "${BASH_SOURCE[0]}")/../../logs/16:00:55::11:02:2024"
    array_of_partitions=$(cat "$a/disk.smlog")
    file_systems=($(echo "$array_of_partitions" | jq -c '.[]'))
    for element in "${file_systems[@]}"; do
        partition=$(echo "$element" | jq '.meta.file_system' | sed -E 's/"//g')
        used_with_signed=$(echo "$element" | jq '.meta.used' | sed -E 's/"//g')
        total_size_with_signed=$(echo "$element" | jq '.meta.size' | sed -E 's/"//g')
        used=$(convert_to_gb $used_with_signed)
        size=$(convert_to_gb "$total_size_with_signed")
        usage=$(echo "scale=2; ($used/$size) * 100" | bc)
        if [[ $(echo "$usage >= 90" | bc -l) -eq 1 ]]; then
            alert_metrics "HIGH" "Disk usage on '$partition'. Metrics=$usage%"
        elif [[ $(echo "$usage >= 70" | bc -l) -eq 1 ]]; then
            alert_metrics "MEDIUM" "Disk usage on '$partition'. Metrics=$usage%"
        elif [[ $(echo "$usage >= 50" | bc -l) -eq 1 ]]; then
            alert_metrics "LOW" "Disk usage on '$partition'. Metrics=$usage%"
        fi
    done
    notify_local_system "queue" "HIGH"
}

export -f monitor_disk_usage