#!/bin/bash

function read_memory_usage(){
    : 'total        used        free      shared  buff/cache   available
    Mem:            11Gi       8.9Gi       606Mi       1.0Gi       3.3Gi       2.5Gi
    Low:            11Gi        10Gi       606Mi
    High:             0B          0B          0B
    Swap:          4.0Gi       2.7Gi       1.3Gi'

    total_memory=$(free -hl | sed -n '2p' | awk '{print $2}')
    used_memory=$(free -hl | sed -n '2p' | awk '{print $3}')
    free_memory=$(free -hl | sed -n '2p' | awk '{print $4}')
    shared_memory=$(free -hl | sed -n '2p' | awk '{print $5}')
    buff_cache_memory=$(free -hl | sed -n '2p' | awk '{print $6}')
    available_memory=$(free -hl | sed -n '2p' | awk '{print $7}')

    total_low_memory=$(free -hl | sed -n '3p' | awk '{print $2}')
    used_low_memory=$(free -hl | sed -n '3p' | awk '{print $3}')
    free_low_memory=$(free -hl | sed -n '3p' | awk '{print $4}')

    total_high_memory=$(free -hl | sed -n '4p' | awk '{print $2}')
    used_high_memory=$(free -hl | sed -n '4p' | awk '{print $3}')
    free_high_memory=$(free -hl | sed -n '4p' | awk '{print $4}')

    total_swap_memory=$(free -hl | sed -n '5p' | awk '{print $2}')
    used_swap_memory=$(free -hl | sed -n '5p' | awk '{print $3}')
    free_swap_memory=$(free -hl | sed -n '5p' | awk '{print $4}')

    # Create a JSON structure
    memory_info='{
        "id": "'"NIL"'",
        "meta": {
            "memory": {
                "total": "'"$total_memory"'",
                "used": "'"$used_memory"'",
                "free": "'"$free_memory"'",
                "shared": "'"$shared_memory"'",
                "buff_cache": "'"$buff_cache_memory"'",
                "available": "'"$available_memory"'"
            },
            "low": {
                "total": "'"$total_low_memory"'",
                "used": "'"$used_low_memory"'",
                "free": "'"$free_low_memory"'"
            },
            "high": {
                "total": "'"$total_high_memory"'",
                "used": "'"$used_high_memory"'",
                "free": "'"$free_high_memory"'"
            },
            "swap": {
                "total": "'"$total_swap_memory"'",
                "used": "'"$used_swap_memory"'",
                "free": "'"$free_swap_memory"'"
            }
        }
    }'

    echo "$memory_info" | jq
}

export -f read_memory_usage