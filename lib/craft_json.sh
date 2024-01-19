#!/bin/bash
CRAFT_JSON_CALL_COUNT=0

function gen_random_hash(){
    local hash_6=$(openssl rand -hex 32 | sha256sum | awk '{print substr($1, 1, 6)}')
    echo "$hash_6"
}

function make_temp_2_path(){
    local path="$TEMP_2_PATH$gen_random_hash"
    sudo touch "$path"
    echo "$path"
}

function craft_json(){
    local key="$1"
    local value="$2"
    local instruct="$3"
    local path=""
    if [[ "$CRAFT_JSON_CALL_COUNT" -eq 0 ]]; then
        path=$(make_temp_2_path)
        echo "[" > "$path"
    fi
    declare -A assoc_array 
    if [[ "$instruct" == "nest" ]]; then
        :
    elif
        :
    else
        assoc_array["$key"]="$value"
    fi

    ((CRAFT_JSON_CALL_COUNT++))
}

function craft_json_once(){
    local object="$2"
    echo "[$object]"
}

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

export -f craft_json_once craft_json_by_count