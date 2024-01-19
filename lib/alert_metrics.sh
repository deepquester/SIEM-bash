#!/bin/bash

#sudo apt-get install libnotify-bin
function alert_metrics(){
    if [[ $1 =~ "HIGH" || $1 == "MEDIUM" || $1 == "LOW" ]]; then
        ALERT_VALUE="TRUE"
        ALERT_LEVEL="$1"
        if [[ $2 ]]; then
            ALERT_DESC="$2"
        else
            return 1
        fi
        local object='{
            "value": '"\"$ALERT_VALUE\","'
            "level": '"\"$ALERT_LEVEL\","'
            "description": '"\"$ALERT_DESC\""'
        }'
        queue_mechanics "PUSH" "$object"
        return 1
    elif [[ $1 =~ "NILL" ]]; then
        ALERT_VALUE="FALSE"
        ALERT_LEVEL="NILL"
        ALERT_DESC="NILL"
        return 0
    elif [[ $1 =~ "ECHO" ]]; then
        queue_array=$(printf "%s" "${queue[@]}")
        queue_array=$(echo "[${queue_array}]" | sed 's/\(.*\),\]$/\1]/')
        queue_length=$(echo "$queue_array" | jq length)
        for ((i=0; i<$queue_length; i++)); do
            element=$(echo "$queue_array" | jq '.['"$i"']')
            local value=$(echo "$element" | jq -r '.value')
            local level=$(echo "$element" | jq -r '.level')
            local description=$(echo "$element" | jq -r '.description')
            echo -e "${BOLD}${YELLOW}[∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞${GREEN}${BOLD}LOGS${YELLOW}∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞]${NC}" 
            if [[ $value == "FALSE" ]]; then
                echo -e "${GREEN}Alert:FALSE${NC}"
            else
                echo -e "${RED}Alert:${BOLD}TRUE${NC}"
            fi
            if [[ $level == "HIGH" ]]; then
                echo -e "${RED}Alert Level: ${BOLD}$level${NC}"
            elif [[ $level == "MEDIUM" ]]; then
                echo -e "${YELLOW}Alert Level: ${BOLD}$level${NC}"
            elif [[ $level == "LOW" ]]; then
                echo -e "${GREEN}Alert Level: ${BOLD}$level${NC}"
            fi
            echo -e "${BLUE}Alert Description: ${BOLD}$ALERT_DESC${NC}"
            echo -e "${BOLD}${YELLOW}[∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞${RED}${BOLD}END${YELLOW}∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞]${NC}"
        done
    elif [[ "$1" =~ "NOTIFY" ]]; then
        notify_local_system $2
    elif [[ $1 =~ "SAVE" ]]; then
        status_log_object='{
        "alert": '"\"""$ALERT_VALUE""\","'
        "level": '"\"""$ALERT_LEVEL""\","'
        "description": '"\"""$ALERT_DESC""\"}"
        echo "$status_log_object" | jq
        return 1
        #$log_dir/&status.smlog
    fi
}

export -f alert_metrics