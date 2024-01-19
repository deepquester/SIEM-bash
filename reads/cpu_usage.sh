#!/bin/bash
#sudo apt-get install sysstat

function read_cpu_usage() {
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

export -f read_cpu_usage