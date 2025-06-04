#!/bin/bash

set -e

# Colors and symbols
green="\033[0;32m"
yellow="\033[1;33m"
red="\033[0;31m"
reset="\033[0m"
check="✔"
arrow="➡"

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while ps -p $pid &>/dev/null; do
        local temp=${spinstr#?}
        printf " [${yellow}%c${reset}]  " "$spinstr"
        spinstr=$temp${spinstr%$temp}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

function install_node() {
    if ! command -v node &>/dev/null; then
        echo -e "${arrow} ${yellow}Installing Node.js...${reset}"
        (curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt-get install -y nodejs) & spinner $!
        echo -e "${check} ${green}Node.js installed.${reset}"
    else
        echo -e "${check} ${green}Node.js is already installed.${reset}"
    fi
}

function install_docker() {
    if ! command -v docker &>/dev/null; then
        echo -e "${arrow} ${yellow}Installing Docker...${reset}"
        (curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && sudo usermod -aG docker $USER) & spinner $!
        echo -e "${check} ${green}Docker installed.${reset}"
        echo -e "${yellow}Please log out and log in again to activate Docker permissions.${reset}"
    else
        echo -e "${check} ${green}Docker is already installed.${reset}"
    fi
}

function install_synchronizer() {
    if ! command -v synchronize &>/dev/null; then
        echo -e "${arrow} ${yellow}Installing synchronizer...${reset}"
        (npm install -g synchronizer-cli) & spinner $!
        echo -e "${check} ${green}Synchronizer installed.${reset}"
    else
        echo -e "${check} ${green}Synchronizer already installed.${reset}"
    fi

    echo -e "${arrow} ${yellow}Initializing synchronizer...${reset}"
    (synchronize init || echo -e "${red}Initialization skipped or failed (already initialized?).${reset}") & spinner $!
    echo -e "${check} ${green}Synchronizer initialized.${reset}"
}

function setup_services() {
    echo -e "${arrow} ${yellow}Setting up synchronizer-cli service...${reset}"
    (synchronize service && sudo cp ~/.synchronizer-cli/synchronizer-cli.service /etc/systemd/system/ && \
     sudo systemctl daemon-reload && sudo systemctl enable synchronizer-cli && sudo systemctl start synchronizer-cli) & spinner $!
    echo -e "${check} ${green}synchronizer-cli service set up.${reset}"

    echo -e "${arrow} ${yellow}Setting up synchronizer-cli-web service...${reset}"
    (synchronize service-web && sudo cp ~/.synchronizer-cli/synchronizer-cli-web.service /etc/systemd/system/ && \
     sudo systemctl daemon-reload && sudo systemctl enable synchronizer-cli-web && sudo systemctl start synchronizer-cli-web) & spinner $!
    echo -e "${check} ${green}synchronizer-cli-web service set up.${reset}"
}

function check_logs() {
    echo -e "${green}Choose log source:${reset}"
    echo -e "${yellow}1️⃣  Systemd (journalctl)${reset}"
    echo -e "${yellow}2️⃣  Docker container logs${reset}"
    read -p "Select option: " log_choice
    if [ "$log_choice" == "1" ]; then
        echo -e "${green}Running systemd logs... Press Ctrl+C to exit.${reset}"
        journalctl -u synchronizer-cli -f
    elif [ "$log_choice" == "2" ]; then
        echo -e "${green}Running Docker logs... Press Ctrl+C to exit.${reset}"
        docker logs -f synchronizer-cli
    else
        echo -e "${red}Invalid choice.${reset}"
    fi
}

function update_multisynq() {
    echo -e "${arrow} ${yellow}Stopping services...${reset}"
    sudo systemctl stop synchronizer-cli
    sudo systemctl stop synchronizer-cli-web

    echo -e "${arrow} ${yellow}Updating synchronizer-cli...${reset}"
    (npm install -g synchronizer-cli) & spinner $!
    echo -e "${check} ${green}synchronizer-cli updated.${reset}"

    echo -e "${arrow} ${yellow}Starting services...${reset}"
    sudo systemctl start synchronizer-cli
    sudo systemctl start synchronizer-cli-web
    echo -e "${check} ${green}Services restarted.${reset}"
}

function check_version() {
    echo -e "${arrow} ${yellow}Checking synchronizer-cli version...${reset}"
    npm list -g synchronizer-cli --depth=0 || echo -e "${red}synchronizer-cli not found.${reset}"
}

function show_menu() {
    clear
    echo -e "${green}Synchronizer Installer Menu${reset}"
    echo -e "${yellow}1️⃣  Install Requirements (Node.js, Docker)${reset}"
    echo -e "${yellow}2️⃣  Install & Init Synchronizer${reset}"
    echo -e "${yellow}3️⃣  Setup Services (CLI + Web)${reset}"
    echo -e "${yellow}4️⃣  Check Logs${reset}"
    echo -e "${yellow}5️⃣  Update Multisynq${reset}"
    echo -e "${yellow}6️⃣  Check Version${reset}"
    echo -e "${yellow}7️⃣  Exit${reset}"
    echo ""
    read -p "Select an option: " choice

    case $choice in
        1) install_node; install_docker;;
        2) install_synchronizer;;
        3) setup_services;;
        4) check_logs;;
        5) update_multisynq;;
        6) check_version;;
        7) echo -e "${green}Exiting.${reset}"; exit 0;;
        *) echo -e "${red}Invalid option.${reset}"; sleep 1;;
    esac
}

while true; do
    show_menu
done
