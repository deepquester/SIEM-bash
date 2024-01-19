#!/bin/bash

function queue_mechanics(){
    if [[ "$1" && "$2" ]]; then
        if [[ "$1" == "PUSH" ]]; then
            total_queue="${#queue[@]}"
            total_incremented=$(echo "$total_queue + 1" | bc)
            function check_incremented_conflicts(){
                local object="$1"
                for x in "${queue[@]}"; do
                    if [[ $(echo "$x" | jq '.id') == \"$total_incremented\" ]]; then
                        total_incremented=$(echo "$total_incremented + 1" | bc)
                        check_incremented_conflicts
                    fi
                done
                param_object="{
                            \"id\": \"$total_incremented\"","
                            \"meta\":"$object"
                        }"
            }
            check_incremented_conflicts "$2"
            queue+=("$param_object")
            return 1
        elif [[ "$1" == "POP" ]]; then
            queue=("${queue[@]:1}")
            return 1
        elif [[ "$1" == "SEARCH" && "$2" && "$3" ]]; then
            result=$(match_json queue "$3" "$4" "rtn_all")
            echo "$result"
            return 1
        else
            :
        fi
    else
        return 0
    fi
}

export -f queue_mechanics