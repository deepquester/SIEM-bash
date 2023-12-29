#!/bin/bash

# Define ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'  # No Color

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
function read_system_timestamp(){
    $date=$(date +'%d-%m-%Y')
    #example 28-12-2023
    $time=$(date +'%H:%M:%S')
    #example 18:04:42
    $day=$(date +'%A')
    #example Thursday
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

    #MEMORY
    #total  11Gi  
    total_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$1"; }')
    #used   9.7Gi   
    used_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$2"; }')
    #free   545Mi   
    free_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$3"; }')
    #shared 939Mi   
    shared_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$4"; }')
    #buff/cache 2.4Gi   
    buff_cache_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$5"; }')
    #available 1.8Gi 
    available_memory=$(free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$6"; }')

    #Low
    #total  11Gi  
    total_low_memory=$(free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$1"; }')
    #used   9.7Gi   
    used_low_memory=$(free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$2"; }')
    #free   545Mi   
    free_low_memory=$(free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$3"; }')

    #High
    #total  11Gi  
    total_high_memory=$(free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$1"; }')
    #used   9.7Gi   
    used_high_memory=$(free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$2"; }')
    #free   545Mi   
    free_high_memory=$(free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$3"; }')

    #Swap
    #total  11Gi  
    total_swap_memory=$(free -hl | sed -n '5p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$1"; }')
    #used   9.7Gi   
    used_swap_memory=$(free -hl | sed -n '5p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$2"; }')
    #free   545Mi   
    free_swap_memory=$(free -hl | sed -n '5p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$3"; }')
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


    #Filesystem /dev/nvme0n1p7           df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)*/) { print "$1\n"; }'
    #Size   1.2G        df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+([\w\/]+)$/) { print "$2\n"; }'
    #Used   4.3M      df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+([\w\/]+)$/) { print "$3\n"; }'
    #Avail  1.2G        df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+([\w\/]+)$/) { print "$4\n"; }'
    #Use%   1%        df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+([\w\/]+)$/) { print "$5\n"; }'
    #Mounted on  /run        df -h | sed -n '7p' | perl -ne 'if (/^([\w\/]+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+([\w\/]+)$/) { print "$6\n"; }'
}

function read_network_statistics(){
    Kernel Interface table
    Iface             MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
    lo              65536   112558      0      0 0        112558      0      0      0 LRU
    wlp0s20f3        1500  4691780      0      0 0       1057684      0      0      0 BMRU

    #Iface  lo        netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #MTU   65536     netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #RX-OK  112558       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #RX-ERR   0      netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #RX-DRP     0       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #RX-OVR   0        netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #TX-OK   112558      netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #TX-ERR  0        netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #TX-DRP   0        netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #TX-OVR      0         netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
    #Flg      LRU       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'
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
        # Process each line as needed
        if [[ $process_count -eq 0 ]]; then
            process_count=$(echo "$process_count + 1" | bc)
            continue
        else
        pid_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #CPU      0.0     
        cpu_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #MEM      0.1       
        mem_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #VSZ      172488      
        vsz_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #RSS      16280       
        rss_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #TTY      ?       
        tty_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #STAT      Ss      
        stat_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #START      17:15      
        start_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #TIME      0:09     
        time_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')
        #COMMAND      /sbin/init splash       
        command_process=$(echo "$line" | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*$/) { print "$2\n"; }')    
        fi
        unit_process_object='{
            "id":'
        unit_process_object+="$process_count"
        unit_process_object+=',
            "meta":{
                "pid":'
        unit_process_object+="$pid_process," 
        unit_process_object+=' "cpu": '
        unit_process_object+="$cpu_process,"
        unit_process_object+=' "mem": '
        unit_process_object+="$mem_process,"
        unit_process_object+=' "vsz": '
        unit_process_object+="$vsz_process,"
        unit_process_object+=' "rss": '
        unit_process_object+="$rss_process,"
        unit_process_object+=' "tty": '
        unit_process_object+="$tty_process,"
        unit_process_object+=' "stat": '
        unit_process_object+="$stat_process,"
        unit_process_object+=' "start": '
        unit_process_object+="$start_process,"
        unit_process_object+=' "time": '
        unit_process_object+="$time_process,"
        unit_process_object+=' "command": '
        unit_process_object+="$command_process"
        unit_process_object+='}
        }'
        total_process_array+=("$unit_process_object")
        total_process_array+=(,)
        process_count=$(echo "$process_count + 1" | bc)
    done
        total_process_array=("${total_process_array[@]:0:$((${#total_process_array[@]}-1))}")
        total_process_array=("[" "${total_process_array[@]}")
        total_process_array+=(])
        echo "${total_process_array[@]}" | jq
}
read_process_information




















function logging(){
    /var/log/symo/H:M:S::D:M:Y.smlog
}

function configure_mail(){
    sudo apt-get install postfix -y
    sudo apt-get install sendmail -y
    sudo apt-get remove sendmail-bin -y
    sudo apt autoremove -y
    sudo apt-get install -f

    read -p "Enter SMTP Server Address:" smtp_address
    read -p "Enter SMTP Server Port[TLS]:" smtp_port
    read -p "Enter Sender Email:" sender_email
    read -p "Enter App Password:" app_pass
    sudo echo "[$smtp_address]:$smtp_port $sender_email:$app_pass" >  /etc/postfix/sasl/sasl_passwd
    sudo postmap /etc/postfix/sasl/sasl_passwd
    sudo chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db
    sudo chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db


    sudo echo "mydestination = $myhostname, localhost, localhost.localdomain
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
    sudo apt-get update && sudo apt-get upgrade
    sudo apt install sysstat -y
    sudo apt install jq -y
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