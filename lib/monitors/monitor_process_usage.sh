#!/bin/bash

# Function to extract process information
extract_process_info() {
    local log_line=$1
    pid=$(echo "$log_line" | grep -o '"pid": "[^"]*' | cut -d'"' -f4)
    cpu=$(echo "$log_line" | grep -o '"cpu": "[^"]*' | cut -d'"' -f4)
    mem=$(echo "$log_line" | grep -o '"mem": "[^"]*' | cut -d'"' -f4)
    vsz=$(echo "$log_line" | grep -o '"vsz": "[^"]*' | cut -d'"' -f4)
    rss=$(echo "$log_line" | grep -o '"rss": "[^"]*' | cut -d'"' -f4)
    tty=$(echo "$log_line" | grep -o '"tty": "[^"]*' | cut -d'"' -f4)
    stat=$(echo "$log_line" | grep -o '"stat": "[^"]*' | cut -d'"' -f4)
    start=$(echo "$log_line" | grep -o '"start": "[^"]*' | cut -d'"' -f4)
    process_time=$(echo "$log_line" | grep -o '"time": "[^"]*' | cut -d'"' -f4)
    command=$(echo "$log_line" | grep -o '"command": "[^"]*' | cut -d'"' -f4)
}

# Function to detect abnormalities
detect_abnormalities() {
    local log_line=$1
    local abnormal_detected=0

    extract_process_info "$log_line"

    # Check for abnormal conditions
    if [[ -n $cpu && -n $cpu_threshold && $(echo "$cpu > $cpu_threshold" | bc -l) -eq 1 ]]; then
        echo "Abnormal CPU usage detected: Process $command (PID: $pid), CPU usage: $cpu%"
        abnormal_detected=1
    fi

    if [[ -n $mem && -n $mem_threshold && $(echo "$mem > $mem_threshold" | bc -l) -eq 1 ]]; then
        echo "Abnormal memory usage detected: Process $command (PID: $pid), Memory usage: $mem%"
        abnormal_detected=1
    fi

    return $abnormal_detected
}

# Main script
log_file="$(dirname "${BASH_SOURCE[0]}")/../../logs/05:01:31::14:02:2024/process.smlog"
cpu_threshold=1.0  # Set your CPU threshold here
mem_threshold=1.0  # Set your memory threshold here

function monitor_process_usage(){
    # Read log file line by line
    while IFS= read -r line; do
        # Check for abnormalities
        detect_abnormalities "$line"
        if [[ $? -eq 1 ]]; then
            echo "Log line: $line"
            echo "--------------------------------------"
        fi
    done < "$log_file"
}

export -f monitor_process_usage