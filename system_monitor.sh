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
        Swap:          4.0Gi       768Ki       4.0Gi               
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

}

function read_network_statistics(){

}

function read_process_information(){

}

function logging(){

}

function alert(){

}

function main_read_system(){
}