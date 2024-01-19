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
        local low_only_alerts_array=$(echo "${queue[0]}" | jq 'if .meta.level == '"\"${priority}\""' then . else 0 end')
            for x in "${low_only_alerts_array[@]}"; do
                local level=$(echo "$x" | jq '.meta.level')
                local description=$(echo "$x" | jq '.meta.description')
                sudo notify-send --urgency="${urgency}" "SyMo alert! Priority: $level" "$description"
            done
    elif [[ "$send_from" == "call" ]]; then
        if [[ -n "$title" && -n "$description" ]]; then
            sudo notify-send --urgency="${urgency}" "SyMo alert! $title Priority: $priority" "$description"
        fi
    else
        return 0
    fi
}

export -f notify_local_system