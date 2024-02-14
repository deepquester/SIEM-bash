#!/bin/bash

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
    echo "$timestamp_info" 
}

export -f read_system_timestamp