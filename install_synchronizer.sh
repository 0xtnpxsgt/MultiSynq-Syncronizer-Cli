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
    clear
    PS3=$'\nSelect log source: '
    options=("Systemd (last 100 lines)" "Docker container (last 100 lines)" "Return to menu")
    select opt in "${options[@]}"; do
        case $REPLY in
            1)
                echo -e "${green}⤷ Showing systemd logs for synchronizer-cli:${reset}"
                journalctl -u synchronizer-cli --no-pager -n 100
                ;;
            2)
                container=$(docker ps --filter "name=synchronizer-cli" --format "{{.Names}}" | head -n1)
                if [ -z "$container" ]; then
                    echo -e "${red}No running synchronizer-cli container found.${reset}"
                else
                    echo -e "${green}⤷ Showing Docker logs for '$container':${reset}"
                    docker logs --tail 100 "$container"
                fi
                ;;
            3)
                break
                ;;
            *)
                echo -e "${red}Invalid choice.${reset}"
                ;;
        esac

        read -n1 -r -p $'\nPress any key to return to logs menu…'
        clear
        PS3=$'\nSelect log source: '
    done
}

function update_multisynq() {
    echo -e "${arrow} ${yellow}Stopping services…${reset}"
    sudo systemctl stop synchronizer-cli synchronizer-cli-web

    echo -e "${arrow} ${yellow}Updating synchronizer-cli…${reset}"
    ( npm update -g synchronizer-cli \
      && echo -e "${check} ${green}synchronizer-cli updated.${reset}" ) & spinner $!

    echo -e "${arrow} ${yellow}Starting services…${reset}"
    sudo systemctl start synchronizer-cli synchronizer-cli-web
    echo -e "${check} ${green}Services restarted.${reset}"

    echo -e "${arrow} ${yellow}Installed version:${reset}"
    npm list -g synchronizer-cli --depth=0

    read -n1 -r -p $'\nPress any key to return to main menu…'
}

function check_version() {
    echo -e "${arrow} ${yellow}Checking synchronizer-cli version...${reset}"

    if ! version_output=$(synchronize --version 2>&1); then
        echo -e "${red}synchronizer-cli failed to run (exit $?).${reset}"
    elif [[ -z "${version_output//[[:space:]]/}" ]]; then
        echo -e "${red}synchronizer-cli returned no output.${reset}"
    else
        echo -e "${green}${version_output}${reset}"
    fi

    # ensure there's a blank line before the prompt
    echo
    read -n1 -s -r -p "Press any key to return to main menu…"
    echo
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
