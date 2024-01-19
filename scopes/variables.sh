#!/bin/bash

# Define ANSI color codes
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export ORANGE='\033[0;33m'
export PURPLE='\033[0;35m'
export BOLD='\033[1m'
export NC='\033[0m'  # No Color

#Define Global Variables
export queue=()
export drop_email_priority="HIGH"

#Read-Only variables
#export readonly LOG_DIR="/var/log/symo"
export readonly EPHEMERAL_DIR="$(dirname "${BASH_SOURCE[0]}")/../ephemeral"
export readonly TEMP_PATH="$EPHEMERAL_DIR/temp"
export readonly TEMP_2_PATH="$EPHEMERAL_DIR/temp_"
export readonly LOG_DIR="/root/bash_volume/symo_temp"
export readonly APP_CONFIG_DIR="/home/$(whoami)"
export readonly APP_CONFIG_NAME="/symo.config"
export readonly APP_NAME="symo"
export readonly APP_VERSION="1.0.1"
export SMTP_SERVER_ADDRESS=""
export SMTP_PORT=""
export SMTP_SYSTEM_EMAIL=""
export SMTP_APP_PASSWORD=""

#Status
export ALERT_VALUE=False #False - No alert, True - alert
export ALERT_LEVEL="NILL" #HIGH LOW MEDIUM NILL
export ALERT_DESC="NILL"