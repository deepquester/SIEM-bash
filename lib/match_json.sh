#!/bin/bash

function match_json(){
    local type_param=$(declare -p "$1")
    local -n param_data="$1"
    if [[ "$type_param" =~ "declare -a" ]]; then
        #regular array
        declare -n param_array=param_data
    elif [[ "$type_param" =~ "declare -A" ]]; then
        #assoc array
        declare -n param_assoc_array=param_data
    else
        return 0
    fi
    #takes array as param
    local key="$2"
    local value="$3"
    local type_of_output="$4"
    local command_1="echo \"\${"
    local var_command="param_array[@]"
    local command_2="}\" | jq 'if ."
    local key_command="$key"
    local command_3=" == \""
    local value_command="$value"
    local command_4="\" then "
    local command_5=". "
    local command_6=" else 0 end'"
    if [[ "$type_of_output" == "once" ]]; then
        local is_found=0
        local output=$(eval "${command_1}${command_2}1${command_4}")
        for item in ${output[@]}; do
            if [[ "$item" -eq 1 ]]; then
                is_found=1
                break
            fi
        done
        echo "$is_found"
        #returns 1 if minimum one object has been found in search query else 0
    elif [[ "$type_of_output" == "mt1" ]]; then
        local is_found=\0
        local first_found=\0
        local return_false=\0
        local output=$(eval "${command_1}${command_2}1${command_4}")
        for item in ${output[@]}; do
            if [[ $first_found -eq 0 ]]; then
                if [[ $item -eq 1 ]]; then
                    first_found=1
                    continue
                fi
            elif [[ $first_found -eq 1 && $item -eq 0 ]]; then
                return_false=1
                continue
            elif [[ $first_found -eq 1 && $item -eq 1 ]]; then
                echo 1
                return 1
            fi
        done
        echo "$return_false"
        #returns 1 if more than one object has been found in search query else 0
    elif [[ "$type_of_output" == "rtn_first" ]]; then
        local output=$(eval "${command_1}${command_2}${command_3}${command_4}")
        local store_object_string=""
        for x in ${output[@]}; do
            if [[ "$x" =~ ^[0]$ ]]; then
                continue
            fi
            if [[ "$x" == "}" ]]; then
                store_object_string+="$x"
                break
            fi
            store_object_string+="$x"
        done 
        echo "$store_object_string"
        #returns one object
    elif [[ "$type_of_output" == "rtn_all" ]]; then
        local output=$(eval "${command_1}param_array[@]${command_2}meta.${key_command}${command_3}${value_command}${command_4}${command_5}${command_6}")
        local store_object_array=()
        local store_object_string=""
        for x in ${output[@]}; do
            if [[ "$x" =~ ^[0]$ ]]; then
                continue
            fi
            if [[ "$x" == "}" ]]; then
                store_object_string+="$x"
                store_object_array+=("$store_object_string")
                store_object_string=""
                continue
            fi
            store_object_string+="$x"
        done
        echo "${store_object_array[@]}"
        # returns array of objects
    else
        return 0
    fi
}

export -f match_json