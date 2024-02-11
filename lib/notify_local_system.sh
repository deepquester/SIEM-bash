#!/bin/bash

function notify_local_system(){
    #sudo apt install dbus-x11
    local send_from="$1"
    local priority="$2"
    local title="$3"
    local description="$4"
    local urgency
    if [ "$priority" == "HIGH" ]; then
        urgency="critical"
    elif [ "$priority" == "MEDIUM" ]; then
        urgency="normal"
    elif [ "$priority" == "LOW" ]; then
        urgency="low"
    fi
    if [[ "$send_from" == "queue" ]]; then
        local queue_total="${#queue[@]}"
        for ((i=0; i<"$queue_total"; i++)); do
            local alert=$(echo "${queue[i]}" | jq 'if .meta.level == '"\"${priority}\""' then . else 0 end')
            [[ "$alert" =~ ^[0-9]+$ && "$alert" -eq 0 ]] && return 1
            local level=$(echo "$alert" | jq '.meta.level')
            local description=$(echo "$alert" | jq '.meta.description')
            notify-send --urgency="${urgency}" "SiMo alert! Priority: $level" "$description"
        done
    elif [[ "$send_from" == "call" ]]; then
        if [[ -n "$title" && -n "$description" ]]; then
            notify-send --urgency="${urgency}" "SiMo alert! $title Priority: $priority" "$description"
        fi
    else
        return 0
    fi
}

export -f notify_local_system