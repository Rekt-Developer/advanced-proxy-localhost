#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

LOG_DIR="/data/data/com.termux/files/usr/var/log/proxy-setup"
LOG_FILE="$LOG_DIR/setup.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Print banner
print_banner() {
    echo -e "${CYAN}"
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

# Log a message
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Install prerequisites
install_prerequisites() {
    log "${YELLOW}Updating packages...${RESET}"
    pkg update -y && pkg upgrade -y

    log "${YELLOW}Installing essential tools...${RESET}"
    pkg install -y curl wget git nginx apache2 openssl
}

# Configure Nginx
configure_nginx() {
    log "${BLUE}Setting up Nginx...${RESET}"
    read -p "Enter the domain to configure (leave blank for localhost): " domain
    domain=${domain:-localhost}

    cat > $PREFIX/etc/nginx/nginx.conf <<EOL
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
    nginx -s reload || nginx
    log "${GREEN}Nginx is now running.${RESET}"
}

# Configure Apache
configure_apache() {
    log "${BLUE}Setting up Apache...${RESET}"
    read -p "Enter the domain to configure (leave blank for localhost): " domain
    domain=${domain:-localhost}

    cat > $PREFIX/etc/apache2/httpd.conf <<EOL
<VirtualHost *:80>
    ServerName ${domain}
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:8080/
    ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
EOL

    log "${GREEN}Apache configuration complete.${RESET}"
    apachectl restart
    log "${GREEN}Apache is now running.${RESET}"
}

# Display network information
display_network_info() {
    log "${CYAN}Fetching local IPs...${RESET}"
    ip addr show | grep "inet " | awk '{print $2}' | cut -d/ -f1
}

# Main menu
main_menu() {
    print_banner
    install_prerequisites

    while true; do
        echo -e "${BLUE}Choose an option:${RESET}"
        echo "1. Configure Nginx"
        echo "2. Configure Apache"
        echo "3. Display network info"
        echo "4. Exit"
        read -p "Enter your choice [1-4]: " choice

        case $choice in
            1) configure_nginx ;;
            2) configure_apache ;;
            3) display_network_info ;;
            4) 
                log "${GREEN}Exiting setup.${RESET}"
                exit 0
                ;;
            *)
                log "${RED}Invalid choice. Please try again.${RESET}"
                ;;
        esac
    done
}

# Start the script
main_menu
