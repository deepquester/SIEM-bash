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
        local rx_drp=$(echo "$interface" | jq '.meta.rx_drp')
        local tx_drp=$(echo "$interface" | jq '.meta.tx_drp')
        echo "$rx_err $tx_err $rx_drp $tx_drp"
    }
    # Function to check for errors and generate alerts
    check_for_errors() {
        declare -A interface="$1"
        local error_metrics=$(get_error_metrics "$interface")
        local rx_err=$(echo "$error_metrics" | awk '{print $1}')
        local tx_err=$(echo "$error_metrics" | awk '{print $2}')
        local rx_drp=$(echo "$error_metrics" | awk '{print $3}')
        local tx_drp=$(echo "$error_metrics" | awk '{print $4}')
        rx_err_result=$(echo "$rx_err > 0" | bc)
        tx_err_result=$(echo "$tx_err > 0" | bc)
        rx_drp_result=$(echo "$rx_drp > 0" | bc)
        tx_drp_result=$(echo "$tx_drp > 0" | bc)
        if [[ "$rx_err_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') interface has RX errors. RX-ERR: $rx_err"
        fi
        if [[ "$tx_err_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') interface has TX errors. RX-ERR: $rx_err"
        fi
        if [[ "$rx_drp_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') interface has RX drop. RX-DRP: $rx_drp"
        fi
        if [[ "$tx_drp_result" -eq 1 ]]; then
            alert_metrics "HIGH" "ALERT: $(echo "$interface" | jq '.meta.iface' | sed -E 's/^.//' | sed -E 's/.$//') interface has TX drop. RX-DRP: $tx_drp"
        fi
    }
    local total_interface="${#array_of_logs[*]}"
    for ((i=0;i<"$total_interface"; i++)); do
        check_for_errors "${array_of_logs[i]}"
    done
    notify_local_system "queue" "HIGH"
}

export -f monitor_network_usage