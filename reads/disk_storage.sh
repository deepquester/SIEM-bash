#!/bin/bash

function read_disk_storage(){
    : 'Filesystem      Size  Used Avail Use% Mounted on
    tmpfs           1.2G  4.3M  1.2G   1% /run
    /dev/nvme0n1p7  249G  120G  117G  51% /
    tmpfs           5.8G   15M  5.8G   1% /dev/shm
    tmpfs           5.0M   12K  5.0M   1% /run/lock
    efivarfs        184K  122K   58K  68% /sys/firmware/efi/efivars
    /dev/nvme0n1p1   96M   33M   64M  34% /boot/efi
    tmpfs           1.2G  2.5M  1.2G   1% /run/user/1000'
    total_disk_array=()
    line_count=0

    IFS=$'\n'
    for line in $(df -h); do
        if [[ $line_count -eq 0 ]]; then
            ((line_count++))
            continue
        else
            # Extracting values using awk
            file_system_disk=$(echo "$line" | awk '{print $1}')
            size_disk=$(echo "$line" | awk '{print $2}')
            used_disk=$(echo "$line" | awk '{print $3}')
            avail_disk=$(echo "$line" | awk '{print $4}')
            use_disk=$(echo "$line" | awk '{print $5}')
            mounted_on_disk=$(echo "$line" | awk '{print $6}')

            # Creating a JSON-like structure for each disk
            unit_disk_object='{
                "id": "'"$line_count"'",
                "meta": {
                    "file_system": "'"$file_system_disk"'",
                    "size": "'"$size_disk"'",
                    "used": "'"$used_disk"'",
                    "avail": "'"$avail_disk"'",
                    "use": "'"$use_disk"'",
                    "mounted_on": "'"$mounted_on_disk"'"
                }
            }'

            total_disk_array+=("$unit_disk_object")
            total_disk_array+=(,)
        fi
    done

    total_disk_array=("${total_disk_array[@]:0:$((${#total_disk_array[@]} - 1))}")
    total_disk_array=("[" "${total_disk_array[@]}")
    total_disk_array+=(])
    echo "${total_disk_array[@]}" | jq 
}

export -f read_disk_storage