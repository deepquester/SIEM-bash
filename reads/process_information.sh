#!/bin/bash


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
    for line in $(ps aux); do
        ((line_count++))

        if [[ $process_count -eq 0 ]]; then
            process_count=$((process_count + 1))
            continue
        else
            # Extracting values using awk
            pid_process=$(echo "$line" | awk '{print $2}')
            cpu_process=$(echo "$line" | awk '{print $3}')
            mem_process=$(echo "$line" | awk '{print $4}')
            vsz_process=$(echo "$line" | awk '{print $5}')
            rss_process=$(echo "$line" | awk '{print $6}')
            tty_process=$(echo "$line" | awk '{print $7}')
            stat_process=$(echo "$line" | awk '{print $8}')
            start_process=$(echo "$line" | awk '{print $9}')
            time_process=$(echo "$line" | awk '{print $10}')
            command_process=$(echo "$line" | awk '{for (i=11; i<=NF; i++) printf "%s ", $i; print ""}')

            unit_process_object='{
                "id": '"$process_count"',
                "meta": {
                    "pid": '"$pid_process"',
                    "cpu": '"$cpu_process"',
                    "mem": '"$mem_process"',
                    "vsz": '"$vsz_process"',
                    "rss": '"$rss_process"',
                    "tty": "'"$tty_process"'",
                    "stat": "'"$stat_process"'",
                    "start": "'"$start_process"'",
                    "time": "'"$time_process"'",
                    "command": "'"$command_process"'"
                }
            }'

            total_process_array+=("$unit_process_object")
            total_process_array+=(,)
        fi
    done
        total_process_array=("${total_process_array[@]:0:$((${#total_process_array[@]}-1))}")
        total_process_array=("[" "${total_process_array[@]}")
        total_process_array+=(])
        echo "${total_process_array[@]}" | jq
}

export -f read_process_information