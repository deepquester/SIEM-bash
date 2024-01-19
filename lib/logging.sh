#!/bin/bash

function logging(){
    declare -g parent_with_timestamp_dir="N"
    function make_parent_log_dir(){
        mkdir -p $LOG_DIR
        if [[ $? -eq 0 ]]; then
            return 0
        else
            return 1
        fi
    }
    
    function make_dir_log_timestamp(){
        mkdir -p "$1"
        if [[ $? -eq 0 ]]; then
            echo "$2::$3"
        else
            return 1
        fi
    }

    function return_timestamp_log_dir(){
        local timestamp=$(read_system_timestamp)
        local date=$(echo "$timestamp" | jq '.date' | sed -E 's/"*//g')
        local time=$(echo "$timestamp" | jq '.time' | sed -E 's/"*//g')
        timestamp_log_dir="$LOG_DIR/$time::$date"
        return_array=("$timestamp_log_dir" "$time" "$date")
        echo "${return_array[@]}"
    }

    function save_log(){
        if ! echo "$1" | grep -E '^[0-9]{2}:[0-9]{2}:[0-9]{2}::[0-9]{2}:[0-9]{2}:[0-9]{4}$' > /dev/null; then
            echo -e "${RED}${BOLD}Something went wrong!${NC}"
        else
            #system_info
            echo "$(read_system_info)" > "$LOG_DIR/$1/system.smlog"
            #network
            echo "$(read_network_statistics)" > "$LOG_DIR/$1/network.smlog"
            #disk
            echo "$(read_disk_storage)" > "$LOG_DIR/$1/disk.smlog"
            #memory
            echo "$(read_memory_usage)" > "$LOG_DIR/$1/memory.smlog"
            #cpu
            echo "$(read_cpu_usage)" > "$LOG_DIR/$1/cpu.smlog"
            #process
            echo "$(read_process_information)" > "$LOG_DIR/$1/process.smlog"
        fi
    }
    if [[ ! -e $LOG_DIR ]]; then
        make_parent_log_dir
    fi
    returned_timestamp_dir=$(return_timestamp_log_dir)
    timestamp_dir=$(echo "${returned_timestamp_dir[@]}" | awk '{print $1}')
    time=$(echo "${returned_timestamp_dir[@]}" | awk '{print $2}')
    date=$(echo "${returned_timestamp_dir[@]}" | awk '{print $3}')
    make_dir_log_timestamp "$timestamp_dir" "$time" "$date" 2>&1 >/dev/null
    save_log "$time::$date"
}

export -f logging