#!/bin/bash

function monitor_memory_usage(){
    a="$(dirname "${BASH_SOURCE[0]}")/../../logs/16:00:55::11:02:2024"
    
    memory_log="$(cat "$a/memory.smlog")"

    local total_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.total')
    total_memory=$(convert_to_gb "$total_memory_without_conversion")
    local used_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.used')
    used_memory=$(convert_to_gb "$used_memory_without_conversion")
    local free_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.free')
    free_memory=$(convert_to_gb "$free_memory_without_conversion")
    local shared_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.shared')
    shared_memory=$(convert_to_gb "$shared_memory_without_conversion")
    local buff_cache_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.buff_cache')
    buff_cache_memory=$(convert_to_gb "$buff_cache_memory_without_conversion")
    local available_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.memory.available')
    available_memory=$(convert_to_gb "$available_memory_without_conversion")

    local low_total_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.low.total')
    low_total_memory=$(convert_to_gb "$low_total_memory_without_conversion")
    local low_used_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.low.used')
    low_used_memory=$(convert_to_gb "$low_used_memory_without_conversion")
    local low_free_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.low.free')
    low_free_memory=$(convert_to_gb "$low_free_memory_without_conversion")

    local high_total_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.high.total')
    high_total_memory=$(convert_to_gb "$high_total_memory_without_conversion")
    local high_used_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.high.used')
    high_used_memory=$(convert_to_gb "$high_used_memory_without_conversion")
    local high_free_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.low.free')
    high_free_memory=$(convert_to_gb "$high_free_memory_without_conversion")
    
    local swap_total_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.swap.total')
    swap_total_memory=$(convert_to_gb "$swap_total_memory_without_conversion")
    local swap_used_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.swap.used')
    swap_used_memory=$(convert_to_gb "$swap_used_memory_without_conversion")
    local swap_free_memory_without_conversion=$(echo "$memory_log" | jq -r '.meta.swap.free')
    swap_free_memory=$(convert_to_gb "$swap_free_memory_without_conversion")

    #metrics
    memory_utilization=$(echo "scale=2; ($used_memory / $total_memory) * 100" | bc -l)
    buff_cache_utilization=$(echo "scale=2; ($buff_cache_memory / $total_memory) * 100" | bc -l)
    swap_utilization=$(echo "scale=2; ($swap_used_memory / $swap_total_memory) * 100" | bc -l)
    if [[ "$(echo "$memory_utilization > 90" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory Utilization $memory_utilization is High!" 
    elif [[ "$(echo "$buff_cache_utilization > 90" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory buff_cache utilization $buff_cache_utilization is High!"
    elif [[ "$(echo "$swap_utilization > 90" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory swap Utilization $swap_utilization is High!"
    fi
    notify_local_system "queue" "HIGH"
}

export -f monitor_memory_usage