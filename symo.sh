#!/bin/bash

fucntion read_os(){
    cat /etc/os-release | grep -w "NAME=" | cut -c 7- | sed 's/.$//'
    #example Ubuntu
} 

function read_os_version(){
    cat /etc/os-release | grep "VERSION=" | cut -c 10- | sed 's/.$//'
    #example 23.10 (Mantic Minotaur)
}

function read_kernel_version(){
    uname -r
    #example 6.6.8
}

function read_system_architecture(){
    uname -p
    #example x86_64
}

function read_system_uptime(){
    uptime -s
    #example 2023-12-28 17:15:35
}
function read_system_timestamp(){
    date +'%d-%m-%Y'
    #example 28-12-2023
    date +'%H:%M:%S'
    #example 18:04:42
    date +'%A'
    #example Thursday
}
function read_cpu_usage(){
    mpstat -o JSON | jq '.sysstat.hosts[0].statistics[0]."cpu-load"[0]'
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

}
function read_memory_usage(){
                    total        used        free      shared  buff/cache   available
        Mem:            11Gi       9.7Gi       545Mi       838Mi       2.4Gi       1.8Gi
        Swap:          4.0Gi       768Ki       4.0Gi               d
        Ada
    #MEMORY
    #total  11Gi  free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$1"; }'
    #used   9.7Gi   free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$2"; }'
    #free   545Mi   free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$3"; }'
    #shared 939Mi   free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$4"; }'
    #buff/cache 2.4Gi   free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$5"; }'
    #available 1.8Gi free -hl | sed -n '2p' | perl -ne 'if (/^Mem:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$6"; }'

    #Low
    #total  11Gi  free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$1"; }'
    #used   9.7Gi   free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$2"; }'
    #free   545Mi   free -hl | sed -n '3p' | perl -ne 'if (/^Low:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$3"; }'

    #High
    #total  11Gi  free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$1"; }'
    #used   9.7Gi   free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$2"; }'
    #free   545Mi   free -hl | sed -n '4p' | perl -ne 'if (/^High:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$3"; }'

    #Swap
    #total  11Gi  free -hl | sed -n '4p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$1"; }'
    #used   9.7Gi   free -hl | sed -n '4p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$2"; }'
    #free   545Mi   free -hl | sed -n '4p' | perl -ne 'if (/^Swap:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) { print "$3"; }'

}

function read_disk_storage(){
    Filesystem      Size  Used Avail Use% Mounted on
    tmpfs           1.2G  4.3M  1.2G   1% /run
    /dev/nvme0n1p7  249G  120G  117G  51% /
    tmpfs           5.8G   15M  5.8G   1% /dev/shm
    tmpfs           5.0M   12K  5.0M   1% /run/lock
    efivarfs        184K  122K   58K  68% /sys/firmware/efi/efivars
    /dev/nvme0n1p1   96M   33M   64M  34% /boot/efi
    tmpfs           1.2G  2.5M  1.2G   1% /run/user/1000


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
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
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
    COMMAND: The command that started the process.

    #USER      root       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$1\n"; }'
    #PID      1       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$2\n"; }'
    #CPU      0.0       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$3\n"; }'
    #MEM      0.1       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$4\n"; }'
    #VSZ      172488       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$5\n"; }'
    #RSS      16280       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$6\n"; }'
    #TTY      ?       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$7\n"; }'
    #STAT      Ss       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$8\n"; }'
    #START      17:15       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$9\n"; }'
    #TIME      0:09       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$10\n"; }'
    #COMMAND      /sbin/init splash       netstat -i | sed -n '3p' | perl -ne 'if (/^(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)$/) { print "$11\n"; }'

}

function logging(){
    /var/log/symo/H:M:S::D:M:Y.smlog
}

function configure_mail(){


}

function alert(){

}

function main_read_system(){
}