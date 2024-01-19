#!/bin/bash

function modify_app_config(){
    local key="$1"
    local value="$2"
    if [[ -e "$app_config_dir" ]]; then
           return 1
    else
        sed -iE "/$key/c\\$key=$value" "$APP_CONFIG_DIR$APP_CONFIG_NAME"
        cat "$APP_CONFIG_DIR$APP_CONFIG_NAME"
    fi
}

export -f modify_app_config