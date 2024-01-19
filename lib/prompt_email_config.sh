#!/bin/bash

function prompt_email_config(){
    read -p "Enter SMTP Service Name[gmail yahoo protonmail]:" SMTP_SERVICE_NAME
    read -p "Enter SMTP Server Address:" SMTP_SERVER_ADDRESS
    read -p "Enter SMTP Server Port[TLS]:" SMTP_PORT
    read -p "Enter Sender Email:" SMTP_SYSTEM_EMAIL
    read -p "Enter App Password:" SMTP_APP_PASSWORD

    modify_app_config "SMTP_SERVICE_NAME" "$SMTP_SERVICE_NAME"
    modify_app_config "SMTP_SERVER_ADDRESS" "$SMTP_SERVER_ADDRESS"
    modify_app_config "SMTP_PORT" "$SMTP_PORT"
    modify_app_config "SMTP_SYSTEM_EMAIL" "$SMTP_SYSTEM_EMAIL"
    modify_app_config "SMTP_APP_PASSWORD" "$SMTP_APP_PASSWORD"

    cat "$APP_CONFIG_DIR$APP_CONFIG_NAME"
}

export -f prompt_email_config