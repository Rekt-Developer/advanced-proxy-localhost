#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
SPINNER="|/-\\"

LOG_DIR="/var/log/proxy-setup"
LOG_FILE="$LOG_DIR/setup.log"
TELEGRAM_LINK="https://t.me/rektdevelopers"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Check the environment
detect_environment() {
    if [[ -n "$(command -v termux-info)" ]]; then
        ENV="termux"
    elif [[ "$(uname -s)" == "Linux" ]]; then
        ENV="linux"
    else
        log "${RED}Unsupported environment. Exiting.${RESET}"
        exit 1
    fi
    log "${CYAN}Detected environment: $ENV${RESET}"
}

# Root check
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo -e "${RED}Error: This script must be run as root!${RESET}"
        echo "Trying to elevate permissions..."
        exec sudo bash "$0" "$@"
        exit 1
    fi
}

# Print banner
print_banner() {
    echo -e "${MAGENTA}"
    echo "████████╗ ██████╗ ██╗  ██╗███████╗"
    echo "╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝"
    echo "   ██║   ██║   ██║█████╔╝ █████╗  "
    echo "   ██║   ██║   ██║██╔═██╗ ██╔══╝  "
    echo "   ██║   ╚██████╔╝██║  ██╗███████╗"
    echo "   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝"
    echo "🚀 Advanced Proxy Localhost Setup"
    echo -e "Developed by ${GREEN}@Rekt-Developer${RESET}"
    echo
}

# Spinner animation
start_spinner() {
    local pid=$1
    while kill -0 $pid 2>/dev/null; do
        for i in ${SPINNER}; do
            echo -ne "\r[$i] Processing... "
            sleep 0.1
        done
    done
    echo -ne "\r[✔] Done!                   \n"
}

# Log a message
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Request permissions (for Termux only)
request_permissions() {
    if [[ "$ENV" == "termux" ]]; then
        log "${YELLOW}Requesting storage permissions...${RESET}"
        termux-setup-storage
        sleep 2
    fi
}

# Install prerequisites
install_prerequisites() {
    log "${YELLOW}Updating packages and installing prerequisites...${RESET}"
    if [[ "$ENV" == "termux" ]]; then
        pkg update -y && pkg upgrade -y &
    else
        apt update -y && apt upgrade -y &
    fi
    start_spinner $!

    log "${YELLOW}Installing essential tools...${RESET}"
    if [[ "$ENV" == "termux" ]]; then
        pkg install -y curl wget git nginx apache2 openssl xdg-utils &
    else
        apt install -y curl wget git nginx apache2 openssl xdg-utils &
    fi
    start_spinner $!
}

# Configure Nginx
configure_nginx() {
    log "${BLUE}Setting up Nginx...${RESET}"
    read -p "Enter the domain to configure (leave blank for localhost): " domain
    domain=${domain:-localhost}

    if [[ "$ENV" == "termux" ]]; then
        config_path="$PREFIX/etc/nginx/nginx.conf"
    else
        config_path="/etc/nginx/sites-available/default"
    fi

    cat > $config_path <<EOL
server {
    listen 80;
    server_name ${domain};

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL

    log "${GREEN}Nginx configuration complete.${RESET}"
    if [[ "$ENV" == "termux" ]]; then
        nginx -s reload || nginx
    else
        systemctl restart nginx
    fi
    log "${GREEN}Nginx is now running.${RESET}"
}

# Configure Apache
configure_apache() {
    log "${BLUE}Setting up Apache...${RESET}"
    read -p "Enter the domain to configure (leave blank for localhost): " domain
    domain=${domain:-localhost}

    if [[ "$ENV" == "termux" ]]; then
        config_path="$PREFIX/etc/apache2/httpd.conf"
    else
        config_path="/etc/apache2/sites-available/000-default.conf"
    fi

    cat > $config_path <<EOL
<VirtualHost *:80>
    ServerName ${domain}
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:8080/
    ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
EOL

    log "${GREEN}Apache configuration complete.${RESET}"
    if [[ "$ENV" == "termux" ]]; then
        apachectl restart
    else
        systemctl restart apache2
    fi
    log "${GREEN}Apache is now running.${RESET}"
}

# Display network information
display_network_info() {
    log "${CYAN}Fetching local IPs...${RESET}"
    ip addr show | grep "inet " | awk '{print $2}' | cut -d/ -f1 || log "${RED}Failed to fetch IPs.${RESET}"
}

# Open Telegram link
open_telegram() {
    log "${BLUE}Opening Telegram link...${RESET}"
    if [[ "$ENV" == "termux" ]]; then
        xdg-open "$TELEGRAM_LINK" || log "${RED}Failed to open browser. Please visit manually: $TELEGRAM_LINK${RESET}"
    else
        xdg-open "$TELEGRAM_LINK" &>/dev/null || log "${RED}Failed to open browser. Please visit manually: $TELEGRAM_LINK${RESET}"
    fi
}

# Main menu
main_menu() {
    while true; do
        clear
        print_banner

        echo -e "${BLUE}Choose an option:${RESET}"
        echo "1. Install Prerequisites"
        echo "2. Configure Nginx"
        echo "3. Configure Apache"
        echo "4. Display Network Info"
        echo "5. Exit"
        read -p "Enter your choice [1-5]: " choice

        case $choice in
            1) install_prerequisites ;;
            2) configure_nginx ;;
            3) configure_apache ;;
            4) display_network_info ;;
            5) 
                log "${GREEN}Setup complete. Redirecting you to Telegram...${RESET}"
                open_telegram
                log "${GREEN}Exiting setup.${RESET}"
                exit 0
                ;;
            *) 
                log "${RED}Invalid choice. Please try again.${RESET}"
                sleep 1
                ;;
        esac
        read -p "Press Enter to return to the menu..." dummy
    done
}

# Start script
detect_environment
check_root
request_permissions
main_menu
