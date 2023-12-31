#!/bin/bash

# Define ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'  # No Color

#Define Global Variables
queue=()

#Read-Only variables
readonly log_dir="/var/log/symo"

#Status
ALERT_VALUE=False #False - No alert, True - alert
ALERT_LEVEL="NILL" #HIGH LOW MEDIUM NILL
ALERT_DESC="NILL"

function read_system_info(){
    function read_os(){
        #example Ubuntu
        cat /etc/os-release | grep -w "NAME=" | cut -c 7- | sed 's/.$//'
    } 

    function read_os_version(){
        #example 23.10 (Mantic Minotaur)
        cat /etc/os-release | grep "VERSION=" | cut -c 10- | sed 's/.$//'
    }

    function read_kernel_version(){
        #example 6.6.8
        uname -r
    }

    function read_system_architecture(){
        #example x86_64
        uname -p
    }

    function read_system_uptime(){
        #example 2023-12-28 17:15:35
        uptime -s
    }

    local os=$(read_os)
    local os_version=$(read_os_version)
    local kernel_version=$(read_kernel_version)
    local system_architecture=$(read_system_architecture)
    local system_uptime=$(read_system_uptime)

    local system_info='{
        "os": "'"$os"'",
        "os_version": "'"$os_version"'",
        "kernel_version": "'"$kernel_version"'",
        "system_architecture": "'"$system_architecture"'",
        "system_uptime": "'"$system_uptime"'"
    }'
    echo "$system_info" | jq
}

function read_system_timestamp(){
    local date=$(date +'%d:%m:%Y')
    #example 28-12-2023
    local time=$(date +'%H:%M:%S')
    #example 18:04:42
    local day=$(date +'%A')
    #example Thursday

    timestamp_info='{
        "date": "'"$date"'",
        "time": "'"$time"'",
        "day": "'"$day"'"
    }' 
    echo "$timestamp_info" | jq
}

function read_cpu_usage(){
    : '#example
    {
        "cpu": "all",
        "usr": 7.82,
        "nice": 0.02,
        "sys": 1.79,
        "iowait": 0.16,
        "irq": 0,
        "soft": 0,
        "steal": 0,
        "guest": 0,
        "gnice": 0,
        "idle": 90.21
    } '
    mpstat -o JSON | jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0]'
}

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

function make_json_object(){
    local -n ref_assoc_arr="$1"
    keys_ref=("${!ref_assoc_arr[@]}")
    values_ref=("${ref_assoc_arr[@]}")
    # Print JSON object
    local key_array=()
    for key in "${values_ref[@]}"; do
        # Escape special characters in the key and value
        key_array+=("$key")
    done
    local value_array=()
    for value in "${keys_ref[@]}"; do
        # Escape special characters in the key and value
        value_array+=("$value")
    done
    if [[ ${key_array} -eq ${value_array} ]]; then
        for ((i=0; i<${#key_array}; i++)); do
            object_string+="\"${key_array[$i]}\""":""\"${value_array[$i]}\","
        done
    else
        return 0
    fi
    object_string="${object_string%,}"  # Remove the trailing comma
    object_string="{$object_string}"
    echo "$object_string" | jq > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        echo "$object_string"
    else
        return 0
    fi
}

function queue_mechanics(){
    if [[ "$1" && "$2" ]]; then
        if [[ "$1" == "PUSH" ]]; then
            queue+=("$2")
            return 1
        elif [[ "$1" == "POP" ]]; then
            queue=("${queue[@]:1}")
            return 1
        else
            :
        fi
    elif [[ "$1" == "RTN_ALL" ]]; then
        queue_length+=$(echo "${#queue[@]}")
        queue_strn+=$(echo "[${queue[@]}]")
        echo "$queue_length"

        for ((i=0; i<queue_length; i++)); do
            object=$(echo "${queue[""$i""]}")
            object_length=$(echo "${#object[@]}")

        done
    elif [[ "$1" == "RTN_SPEC" ]]; then
            return 1
    else
        return 0
    fi
}


: 'function notify_local_system(){
    local priority="$1"
    if [[ "$1" == "HIGH" ]]; then

    elif [[ "$1" == "MEDIUM" ]]; then

    elif [[ "$1" == "LOW" ]]; then
    else
        return 0
    fi


    if [[ "$1" ]]; then
        local description="$1"
    else 
        return 0
    fi


    if [[ "$2" ]]; then
        if [[ $2 == "low" ]]; then
            notify-send --urgency=low "SyMo alert! Priority: $2" "$description"
            return 1
        elif [[ $2 == "normal" ]]; then
            notify-send --urgency=normal "SyMo alert! Priority: $2" "$description"
            return 1
        elif [[ $2 == "critical" ]]; then
            notify-send --urgency=critical "SyMo alert! Priority: $2" "$description"
            return 1
        else 
            return 0
        fi
    else
        return 0
    fi
} '

function alert_metrics(){
    if [[ $1 =~ "HIGH" || $1 == "MEDIUM" || $1 == "LOW" ]]; then
        ALERT_VALUE="TRUE"
        ALERT_LEVEL="$1"
        if [[ $2 ]]; then
            ALERT_DESC="$2"
        else
            return 1
        fi
        local object='{
            "value": '"\"$ALERT_VALUE\","'
            "level": '"\"$ALERT_LEVEL\","'
            "description": '"\"$ALERT_DESC\""'
        },'
        queue_mechanics "PUSH" "$object"
        return 0
    elif [[ $1 =~ "NILL" ]]; then
        ALERT_VALUE="FALSE"
        ALERT_LEVEL="NILL"
        ALERT_DESC="NILL"
        return 0
    elif [[ $1 =~ "ECHO" ]]; then
        queue_array=$(printf "%s" "${queue[@]}")
        queue_array=$(echo "[${queue_array}]" | sed 's/\(.*\),\]$/\1]/')
        queue_length=$(echo "$queue_array" | jq length)
        for ((i=0; i<$queue_length; i++)); do
            element=$(echo "$queue_array" | jq '.['"$i"']')
            local value=$(echo "$element" | jq -r '.value')
            local level=$(echo "$element" | jq -r '.level')
            local description=$(echo "$element" | jq -r '.description')
            echo -e "${BOLD}${YELLOW}[∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞${GREEN}${BOLD}LOGS${YELLOW}∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞]${NC}" 
            if [[ $value == "FALSE" ]]; then
                echo -e "${GREEN}Alert:FALSE${NC}"
            else
                echo -e "${RED}Alert:${BOLD}TRUE${NC}"
            fi
            if [[ $level == "HIGH" ]]; then
                echo -e "${RED}Alert Level: ${BOLD}$level${NC}"
            elif [[ $level == "MEDIUM" ]]; then
                echo -e "${YELLOW}Alert Level: ${BOLD}$level${NC}"
            elif [[ $level == "LOW" ]]; then
                echo -e "${GREEN}Alert Level: ${BOLD}$level${NC}"
            fi
            echo -e "${BLUE}Alert Description: ${BOLD}$ALERT_DESC${NC}"
            echo -e "${BOLD}${YELLOW}[∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞${RED}${BOLD}END${YELLOW}∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞]${NC}"
        done
    elif [[ "$1" =~ "NOTIFY" ]]; then
        notify_local_system $2
    elif [[ $1 =~ "SAVE" ]]; then
        status_log_object='{
        "alert": '"\"""$ALERT_VALUE""\","'
        "level": '"\"""$ALERT_LEVEL""\","'
        "description": '"\"""$ALERT_DESC""\"}"
        echo "$status_log_object" | jq
        return 1
        #$log_dir/&status.smlog
    fi
}

#sudo apt-get install libnotify-bin
function convert_to_gb() {
    input=$1
    limit=
    if [[ $2 ]]; then
        limit=$2
    else
        limit=11
    fi
    unit=$(echo $input | sed -n -E 's/([0-9.]+)([KkMmGgTtPpEeZzYy])?.?/\2/p' | tr '[:lower:]' '[:upper:]')

    case $unit in
        K) factor=1e-6 ;;
        M) factor=1e-3 ;;
        G) factor=1 ;;
        T) factor=1e3 ;;
        P) factor=1e6 ;;
        E) factor=1e9 ;;
        Z) factor=1e12 ;;
        Y) factor=1e15 ;;
        *) factor=0 ;;  # Default case for gigabytes
    esac

    if [ "$factor" != "0" ]; then
        result=$(echo "$input" | sed -E "s/([0-9.]+)([KkMmGgTtPpEeZzYy])?B?/\1/" | awk "{printf \"%."$limit"f\", \$1 * $factor}")
        echo "$result"
    else
        return 0
    fi
}

function monitor_disk_usage(){
    a="/var/log/symo/13:42:06::30:12:2023"
    array_of_partitions=$(cat "$a/disk.smlog")
    file_systems=($(echo "$array_of_partitions" | jq -c '.[]'))
    for element in "${file_systems[@]}"; do
        partition=$(echo "$element" | jq '.meta.file_system' | sed -E 's/"//g')
        used_with_signed=$(echo "$element" | jq '.meta.used' | sed -E 's/"//g')
        total_size_with_signed=$(echo "$element" | jq '.meta.size' | sed -E 's/"//g')
        used=$(convert_to_gb $used_with_signed)
        size=$(convert_to_gb "$total_size_with_signed")
        usage=$(echo "scale=2; ($used/$size) * 100" | bc)
        if [[ $(echo "$usage > 40" | bc -l) -eq 1 ]]; then
            alert_metrics "HIGH" "Disk usage is HIGH on '$partition'. Metrics=$usage"
        fi
    done
    alert_metrics "ECHO"
}

function monitor_cpu_usage(){
    a="/var/log/symo/13:42:06::30:12:2023"
    idle=$(cat "$a/cpu.smlog" | jq '.idle')
    cpu_utilization=$(echo "100 - $idle" | bc -l)
    if [[ $cpu_utilization > 80 ]]; then   
        alert_metrics "MEDIUM" "CPU Utilization is High! Metrics=$cpu_utilization%"
        #return 0    
    fi
    alert_metrics "SAVE"
    return 1
}

function monitor_memory_usage(){
    a="/var/log/symo/13:42:06::30:12:2023"
    
    memory_log=$(cat "$1/memory.smlog")

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
    if [[ "$(echo "$memory_utilization > 0" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory Utilization $memory_utilization is High!" 
    elif [[ "$(echo "$buff_cache_utilization > 90" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory buff_cache utilization $buff_cache_utilization is High!"
    elif [[ "$(echo "$swap_utilization > 90" | bc -l)" -eq 1 ]]; then
        alert_metrics "HIGH" "Memory swap Utilization $swap_utilization is High!"
    fi
    echo "$ALERT_VALUE $ALERT_LEVEL $ALERT_DESC"
}

function logging(){
    declare -g parent_with_timestamp_dir="N"
    function make_parent_log_dir(){
        mkdir -p $log_dir
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
        timestamp_log_dir="$log_dir/$time::$date"
        return_array=("$timestamp_log_dir" "$time" "$date")
        echo "${return_array[@]}"
    }

    function save_log(){
        if ! echo "$1" | grep -E '^[0-9]{2}:[0-9]{2}:[0-9]{2}::[0-9]{2}:[0-9]{2}:[0-9]{4}$' > /dev/null; then
            echo -e "${RED}${BOLD}Something went wrong!${NC}"
        else
            #system_info
            echo "$(read_system_info)" > "$log_dir/$1/system.smlog"
            #network
            echo "$(read_network_statistics)" > "$log_dir/$1/network.smlog"
            #disk
            echo "$(read_disk_storage)" > "$log_dir/$1/disk.smlog"
            #memory
            echo "$(read_memory_usage)" > "$log_dir/$1/memory.smlog"
            #cpu
            echo "$(read_cpu_usage)" > "$log_dir/$1/cpu.smlog"
            #process
            echo "$(read_process_information)" > "$log_dir/$1/process.smlog"
        fi
    }
    if [[ ! -e $log_dir ]]; then
        make_parent_log_dir
    fi
    returned_timestamp_dir=$(return_timestamp_log_dir)
    timestamp_dir=$(echo "${returned_timestamp_dir[@]}" | awk '{print $1}')
    time=$(echo "${returned_timestamp_dir[@]}" | awk '{print $2}')
    date=$(echo "${returned_timestamp_dir[@]}" | awk '{print $3}')
    make_dir_log_timestamp "$timestamp_dir" "$time" "$date" 2>&1 >/dev/null
    save_log "$time::$date"
}

function configure_mail(){
    apt-get install postfix -y
    apt-get install sendmail -y
    apt-get remove sendmail-bin -y
    apt autoremove -y
    apt-get install -f

    read -p "Enter SMTP Server Address:" smtp_address
    read -p "Enter SMTP Server Port[TLS]:" smtp_port
    read -p "Enter Sender Email:" sender_email
    read -p "Enter App Password:" app_pass
    echo "[$smtp_address]:$smtp_port $sender_email:$app_pass" >  /etc/postfix/sasl/sasl_passwd
    postmap /etc/postfix/sasl/sasl_passwd
    chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
    chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db


    echo "mydestination = $myhostname, localhost, localhost.localdomain
    relayhost = [$smtp_address]:$smtp_port
    mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128

    # Enable SASL authentication
    smtp_sasl_auth_enable = yes
    smtp_sasl_security_options = noanonymous
    smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
    smtp_tls_security_level = encrypt
    smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt">> /etc/postfix/main.cf

    sudo systemctl restart postfix
}

function alert(){
    echo "alert"
}

function main_read_system(){
    echo "reading"
}

function init_config(){
    apt-get update && apt-get upgrade
    apt install sysstat -y
    apt install jq -y
    configure_mail
}

function main(){
    echo -e "${GREEN}${BOLD}Welcome to Symo [mini-SIEM bash project] by ${RED}${BOLD}Deep=⍜⎊⎈${NC}"
    if [[ -e /usr/local/bin/symo.sh ]]; then
        main_read_system
    else
        init_config
    fi
}