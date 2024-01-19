#!/bin/bash

function init_app_config(){
    if [[ -e "$app_config_dir" ]]; then
           return 1
    else
        sudo mkdir -p "$APP_CONFIG_DIR" && touch "$APP_CONFIG_DIR$APP_CONFIG_NAME"
echo "
#META#
APP_NAME=""$APP_NAME""
APP_RELEASE_VERSION=""$APP_VERSION""
#END#

#EMAIL CONFIG#
SMTP_SERVICE_NAME=""
SMTP_SERVER_ADDRESS=""
SMTP_PORT=""
SMTP_SYSTEM_EMAIL=""
SMTP_APP_PASSWORD=""
#END#" > "$APP_CONFIG_DIR$APP_CONFIG_NAME"
    fi
    cat "$APP_CONFIG_DIR$APP_CONFIG_NAME"
}
rec_email="deeptestingdev@gmail.com"
function drop_queue_emails(){
    for x in "${queue[@]}"; do
        local level=$(echo "$x" | jq '.meta.level' | sed -E 's/^.//' | sed -E 's/.$//')
        local description=$(echo "$x" | jq '.meta.description' | sed -E 's/^.//' | sed -E 's/.$//')
        if [[ "$level" == "$drop_email_priority" ]]; then
            send_email "$rec_email" "$level level on Symo" "$description"
        fi
    done
}

export -f init_app_config