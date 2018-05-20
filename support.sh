#!/bin/bash

# Export colour variables
# Lifted from https://unix.stackexchange.com/questions/148/colorizing-your-terminal-and-shell-environment?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

export COLOR_NC=$(echo -e '\x1B[0m') # No Color
export COLOR_WHITE=$(echo -e '\x1B[1;37m')
export COLOR_BLACK=$(echo -e '\x1B[0;30m')
export COLOR_BLUE=$(echo -e '\x1B[0;34m')
export COLOR_LIGHT_BLUE=$(echo -e '\x1B[1;34m')
export COLOR_GREEN=$(echo -e '\x1B[0;32m')
export COLOR_LIGHT_GREEN=$(echo -e '\x1B[1;32m')
export COLOR_CYAN=$(echo -e '\x1B[0;36m')
export COLOR_LIGHT_CYAN=$(echo -e '\x1B[1;36m')
export COLOR_RED=$(echo -e '\x1B[0;31m')
export COLOR_LIGHT_RED=$(echo -e '\x1B[1;31m')
export COLOR_PURPLE=$(echo -e '\x1B[0;35m')
export COLOR_LIGHT_PURPLE=$(echo -e '\x1B[1;35m')
export COLOR_BROWN=$(echo -e '\x1B[0;33m')
export COLOR_YELLOW=$(echo -e '\x1B[1;33m')
export COLOR_GRAY=$(echo -e '\x1B[0;30m')
export COLOR_LIGHT_GRAY=$(echo -e '\x1B[0;37m')

export BOLD=$(tput bold)
export RESET=$(tput sgr0)

# Log functions

function info {
    echo "${RESET}${COLOR_BLUE}${BOLD}[+] ${1}${RESET}"
}

function warning {
    echo "${RESET}${COLOR_YELLOW}${BOLD}[?] ${1}${RESET}"
}

function error {
    echo "${RESET}${COLOR_RED}${BOLD}[!] ${1}${RESET}"
}

function success {
    echo "${RESET}${COLOR_GREEN}${BOLD}[+] ${1}${RESET}"
}
