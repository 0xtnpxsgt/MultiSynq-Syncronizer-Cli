#!/usr/bin/env bash

# Simple installer for synchronizer-cli
set -e

arrow="\xE2\x9E\x9C" # arrow symbol
yellow="\033[1;33m"
red="\033[0;31m"
reset="\033[0m"

spinner() {
    pid=$1
    spin='|/-\\'
    i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r[%c]" "${spin:$i:1}"
        sleep .1
    done
    printf "\r"
}

install_synchronizer() {
    if ! command -v synchronizer &>/dev/null; then
        echo -e "${arrow} ${yellow}Installing synchronizer...${reset}"
        (npm install -g synchronizer-cli >/dev/null 2>&1) & spinner $!
    fi

    echo -e "${arrow} ${yellow}Initializing synchronizer...${reset}"
    (synchronizer init >/dev/null 2>&1 || \
        echo -e "${red}Initialization skipped or failed (already initialized?).${reset}") & spinner $!
    wait
}

install_synchronizer

echo -e "${arrow} ${yellow}Installation complete.${reset}"
