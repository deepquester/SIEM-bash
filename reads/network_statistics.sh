#!/bin/bash

function read_network_statistics() {
    total_network_array=()
    line_count=0
    IFS=$'\n'  # Set Internal Field Separator to newline

    for line in $(netstat -i); do
        ((line_count++))

        # Skip header lines
        if [ "$line_count" -le 2 ]; then
            continue
        fi
        # Extract relevant data from the line (modify these as needed)
        iface_network=$(echo "$line" | awk '{print $1}')
        mtu_network=$(echo "$line" | awk '{print $2}')
        rx_ok_network=$(echo "$line" | awk '{print $3}')
        rx_err_network=$(echo "$line" | awk '{print $4}')
        rx_drp_network=$(echo "$line" | awk '{print $5}')
        rx_ovr_network=$(echo "$line" | awk '{print $6}')
        tx_ok_network=$(echo "$line" | awk '{print $7}')
        tx_err_network=$(echo "$line" | awk '{print $8}')
        tx_drp_network=$(echo "$line" | awk '{print $9}')
        tx_ovr_network=$(echo "$line" | awk '{print $10}')
        flg_network=$(echo "$line" | awk '{print $11}')

        # Create a JSON-like structure for each network interface
        unit_network_object='{
            "id": '"$line_count"',
            "meta": {
                "iface": "'"$iface_network"'",
                "mtu": '"$mtu_network"',
                "rx_ok": '"$rx_ok_network"',
                "rx_err": '"$rx_err_network"',
                "rx_drp": '"$rx_drp_network"',
                "rx_ovr": '"$rx_ovr_network"',
                "tx_ok": '"$tx_ok_network"',
                "tx_err": '"$tx_err_network"',
                "tx_drp": '"$tx_drp_network"',
                "tx_ovr": '"$tx_ovr_network"',
                "flg": "'"$flg_network"'"
            }
        }'
        total_network_array+=("$unit_network_object")
        total_network_array+=(,)
    done
    total_network_array=("${total_network_array[@]:0:$((${#total_network_array[@]}-1))}")
    total_network_array=("[" "${total_network_array[@]}")
    total_network_array+=(])
    # Print the JSON array
    printf '%s\n' "${total_network_array[@]}" | jq
}

export -f read_network_statistics