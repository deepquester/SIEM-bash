#!/bin/bash

function configure_mail(){

    local msmtprc_content="defaults
    auth           on
    tls            on
    tls_starttls   on
    tls_certcheck  off
    logfile        ~/.msmtp.log

    account        $SMTP_SERVICE_NAME
    host           $SMTP_SERVER_ADDRESS
    port           $SMTP_PORT
    from           $SMTP_SYSTEM_EMAIL
    user           $SMTP_SYSTEM_EMAIL
    password       $SMTP_APP_PASSWORD

    account default : $smtp_service_name"
    echo "$msmtprc_content" > "~/.msmtprc"
    sudo chmod 600 ~/.msmtprc
}

export -f configure_mail