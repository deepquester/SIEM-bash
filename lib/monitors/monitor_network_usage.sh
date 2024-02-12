#!/bin/bash

function monitor_network_usage(){
    a="$(dirname "${BASH_SOURCE[0]}")/../../logs/16:00:55::11:02:2024"
    local network_log=$(cat "$a/network.smlog")
    local array_of_logs=($(echo "$network_log" | jq -c '.[]'))

    #declare -a array_of_logs=$(convert_array_json_from_file "$network_log")
    get_error_metrics() {
        declare -a interface=$1
        local rx_err=$(echo "$interface" | jq '.meta.rx_err')
        local tx_err=$(echo "$interface" | jq '.meta.tx_err')
        echo "$rx_err $tx_err"
    }
    # Function to check for errors and generate alerts
    check_for_errors() {
        declare -A interface="$1"
        local error_metrics=$(get_error_metrics "$interface")
        local rx_err=$(echo "$error_metrics" | awk '{print $1}')
        local tx_err=$(echo "$error_metrics" | awk '{print $2}')
        rx_result=$(echo "$rx_err > 0" | bc)
        tx_result=$(echo "$tx_err > 0" | bc)
        if [[ "$rx_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') has RX errors. RX-ERR: $rx_err"
        fi
        if [[ "$tx_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') has TX errors. TX-ERR: $tx_err"
        fi
    }
    local total_interface="${#array_of_logs[*]}"
    for ((i=0;i<"$total_interface"; i++)); do
        check_for_errors "${array_of_logs[i]}"
    done
    notify_local_system "queue" "HIGH"
}

export -f monitor_network_usage