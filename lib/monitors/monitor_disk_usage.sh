#!/bin/bash

function monitor_disk_usage(){
    a="/var/log/symo/13:42:06::30:12:2023"
    array_of_partitions=$(cat "$a/disk.smlog")
    file_systems=($(echo "$array_of_partitions" | jq -c '.[]'))
    for element in "${file_systems[@]}"; do
        partition=$(echo "$element" | jq '.meta.file_system' | sed -E 's/"//g')
        used_with_signed=$(echo "$element" | jq '.meta.used' | sed -E 's/"//g')
        total_size_with_signed=$(echo "$element" | jq '.meta.size' | sed -E 's/"//g')
        used=$(convert_to_gb $used_with_signed)
        size=$(convert_to_gb "$total_size_with_signed")
        usage=$(echo "scale=2; ($used/$size) * 100" | bc)
        if [[ $(echo "$usage > 40" | bc -l) -eq 1 ]]; then
            alert_metrics "HIGH" "Disk usage is HIGH on '$partition'. Metrics=$usage"
        fi
    done
    alert_metrics "ECHO"
}

export -f monitor_disk_usage