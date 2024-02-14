#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/system_timestamp.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/../scopes/variables.sh" 
source "$(dirname "${BASH_SOURCE[0]}")/../lib/craft_json.sh" 

function read_process_information(){
    : 'USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.1 172488 16280 ?        Ss   17:15   0:09 /sbin/init splash
    root           2  0.0  0.0      0     0 ?        S    17:15   0:00 [kthreadd]
    root           3  0.0  0.0      0     0 ?        S    17:15   0:00 [pool_workqueue_release]
    root           4  0.0  0.0      0     0 ?        I<   17:15   0:00 [kworker/R-rcu_g]
    root           5  0.0  0.0      0     0 ?        I<   17:15   0:00 [kworker/R-rcu_p]
    root           6  0.0  0.0      0     0 ?        I<   17:15   0:00 [kworker/R-slub_]
    USER: The user who owns the process.
    PID: Process ID.
    %CPU: CPU usage percentage.
    %MEM: Memory usage percentage.
    VSZ: Virtual memory size.
    RSS: Resident set size (actual memory usage).
    TTY: Terminal type associated with the process.
    STAT: Process status.
    START: Start time of the process.
    TIME: Total accumulated CPU time.
    COMMAND: The command that started the process.'

    IFS=$'\n'  # Set Internal Field Separator to newline
    total_process_array=()
    process_count=0
    while read -r line; do
        ((process_count++))
        
        # Extracting values using awk
        user_process=$(echo "$line" | awk '{print $1}')
        pid_process=$(echo "$line" | awk '{print $2}')
        cpu_process=$(echo "$line" | awk '{print $3}')
        mem_process=$(echo "$line" | awk '{print $4}')
        vsz_process=$(echo "$line" | awk '{print $5}')
        rss_process=$(echo "$line" | awk '{print $6}')
        tty_process=$(echo "$line" | awk '{print $7}')
        stat_process=$(echo "$line" | awk '{print $8}')
        start_process=$(echo "$line" | awk '{print $9}')
        time_process=$(echo "$line" | awk '{print $10}')
        command_process=$(echo "$line" | awk '{for (i=11; i<=NF; i++) printf "%s ", $i; print ""}' | sed -E 's/"/'\''/g')

        unit_process_object=$(printf '{"id": "'$process_count'", "meta": {"pid": "%s", "cpu": "%s", "mem": "%s", "vsz": "%s", "rss": "%s", "tty": "%s", "stat": "%s", "start": "%s", "time": "%s", "command": "%s"}}' "$pid_process" "$cpu_process" "$mem_process" "$vsz_process" "$rss_process" "$tty_process" "$stat_process" "$start_process" "$time_process" "$command_process")

        craft_json_by_count "$process_count" "$unit_process_object" 
    done <<< "$(ps aux | tail -n +2)"
    craft_json_by_count "done"
    cat "$TEMP_PATH"
    # return as a bash array
}

export -f read_process_information