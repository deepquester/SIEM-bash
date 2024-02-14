#!/bin/bash

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
    echo "$system_info" 
}

export -f read_system_info