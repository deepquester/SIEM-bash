#!/bin/bash

function send_email(){
    local recipient_email="$1"
    local subject="$2"
    local block="$3"
    echo -e "Subject: $subject\n\n$email_body" | msmtp $recipient_email
}

export -f send_email