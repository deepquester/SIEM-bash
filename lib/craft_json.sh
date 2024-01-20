#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../scopes/variables.sh" 

function gen_random_hash(){
    local hash_6=$(openssl rand -hex 32 | sha256sum | awk '{print substr($1, 1, 6)}')
    echo "$hash_6"
}

function make_temp_2_path(){
    local path="$TEMP_2_PATH$gen_random_hash"
    sudo touch "$path"
    echo "$path"
}
function craft_json_once(){
    local object="$1"
    echo "[$object]"
}

function craft_json(){
    local key="$1"
    local value="$2"
    local instruct="$3"
    local instruct_2="$4"
    local key_and_value="\"$key\":\"$value\""

    if [[ $(echo "$CRAFT_JSON_CALL_COUNT == 0" | bc ) -eq 1 ]]; then
        echo "{" > "$TEMP_PATH"
    fi
    
    if [[ "$instruct" == "done" ]]; then
        if [[ ! -z "$1" ]]; then
            echo "$key_and_value}" >> "$TEMP_PATH"
        else
            echo "}" >> "$TEMP_PATH"
        fi
        if [[ "$instruct_2" == "craft" ]]; then
            local path_content_final=$(cat "$TEMP_PATH")
            local crafted=$(craft_json_once "$path_content_final")
            echo "$crafted" > "$TEMP_PATH"
        fi
        CRAFT_JSON_CALL_COUNT=0
        RECENT_OBJECT=$(cat "$TEMP_PATH")
        ((CRAFT_JSON_CALL_COUNT++))
        return 0
    elif [[ "$instruct" == "inner_done" ]]; then
        #local close_braces=""
        #for ((i=0; i<=$CRAFT_INNER_JSON_CALL_COUNT; i++)); do
        #    close_braces+="}"
        #done
        if [[ ! -z "$1" ]]; then
            echo "$key_and_value}" >> "$TEMP_PATH"
        else
            echo "}" >> "$TEMP_PATH"
        fi
        if [[ "$instruct_2" == "craft" ]]; then
            local path_content_final=$(cat "$TEMP_PATH")
            local crafted=$(craft_json_once "$path_content_final}")
            echo "$crafted" > "$TEMP_PATH"
        fi
        CRAFT_JSON_CALL_COUNT=0
        RECENT_OBJECT=$(cat "$TEMP_PATH")
        ((CRAFT_JSON_CALL_COUNT++))
        return 0
    elif [[ "$instruct_2" == "inner" || "$instruct_2" == "inner_and_done" || "$instruct_2" == "inner_and_done_all" ]]; then
        local inner_key_and_value="\"$instruct\":{$key_and_value"
        if [[ "$instruct_2" == "inner_and_done" ]]; then
            echo "$inner_key_and_value}" >> "$TEMP_PATH"
        elif [[ "$instruct_2" == "inner_and_done_all" ]]; then
            echo "$inner_key_and_value}" >> "$TEMP_PATH"
            craft_json "" "" "done"
        else
            echo "$inner_key_and_value," >> "$TEMP_PATH"
        fi
        ((CRAFT_INNER_JSON_CALL_COUNT++))
        ((CRAFT_JSON_CALL_COUNT++))
        return 0
    else
        echo "$key_and_value," >> "$TEMP_PATH"
    fi
    ((CRAFT_JSON_CALL_COUNT++))
}

craft_json "jimni" "deep" 
craft_json "jimni1" "deep1" "love1" "inner_and_done_all"
#craft_json "jimni2" "deep2" "inner_done" "craft"

function craft_json_by_count(){
    local count="$1" 
    local object="$2"
    if [[ "$count" -eq 1 ]]; then
        echo "[ $object," > "$TEMP_PATH"
    elif [[ "$count" == "done" ]]; then
        sed -i '$s/,$//' "$TEMP_PATH"
        echo " ]" >> "$TEMP_PATH"
    else
        echo "$object," >> "$TEMP_PATH"
    fi
    echo "$TEMP_PATH"
}

export -f craft_json craft_json_once craft_json_by_count