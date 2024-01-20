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

function craft_json(){
    local key="$1"
    local value="$2"
    local instruct="$3"
    local key_and_value="\"$key\":\"$value\""

    if [[ $(echo "$CRAFT_JSON_CALL_COUNT == 0" | bc ) -eq 1 ]]; then
        echo "{" > "$TEMP_PATH"
    fi
    
    if [[ "$instruct" == "done" ]]; then
        echo "$key_and_value}" >> "$TEMP_PATH"
        local path_content=$(cat "$TEMP_PATH")
        local trimmed_path_content=$(echo "$path_content" | sed 's/[[:space:]]*$//')
        echo "${trimmed_path_content%?}}" > "$TEMP_PATH"
        CRAFT_JSON_CALL_COUNT=0
        RECENT_OBJECT=$(cat "$TEMP_PATH")
        return 0
    elif [[ "$instruct" == "inner" ]]; then
        :
    else
        echo "$key_and_value," >> "$TEMP_PATH"
    fi
    ((CRAFT_JSON_CALL_COUNT++))
}
z=10
for ((i = 0; i < 10; i++)); do
    if [[ "$i" -eq 9 ]]; then
        craft_json "jimni$i" "deep$i" "done"
        break;
    fi
    craft_json "jimni$i" "deep$i"
done

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