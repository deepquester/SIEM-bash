#!/bin/bash

function convert_array_json_from_file(){
    local location="$1"
    #local json_string=$(cat "$location")
    local removed_brackets=($(echo "$location" | jq -c '.[]'))
    echo "${removed_brackets[@]}"
    return 1
}

export -f convert_array_json_from_file