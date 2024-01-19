#!/bin/bash

function make_json_object(){
    #takes assoc array as param
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

export -f make_json_object