#!/bin/bash

# Ensure we're running as root (using `tsu`)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Attempting to elevate to root..."
    
    # Use `tsu` for root access (Termux's sudo alternative)
    if command -v tsu >/dev/null 2>&1; then
        echo "Root access granted using tsu."
        exec tsu "$0" "$@"
    else
        echo "Error: tsu is not installed. Please install tsu first."
        exit 1
    fi
fi

# Update Termux repositories and upgrade all packages
echo "Updating Termux and upgrading packages..."
pkg update -y && pkg upgrade -y

# Install essential packages
echo "Installing essential packages..."
pkg install -y git nano curl wget zsh fish python nodejs npm build-essential termux-tools

# Install Node.js, Python, and other necessary tools
echo "Installing Node.js, Python, and npm..."
pkg install -y nodejs python

# Install Fish Shell and Zsh Shell
echo "Installing Fish shell..."
pkg install -y fish
echo "Installing Zsh shell..."
pkg install -y zsh

# Install Zsh plugins and configure Zsh
echo "Configuring Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "Zsh configured."

# Configure Fish shell (if it's your preferred shell)
echo "Configuring Fish shell..."
curl -L https://get.fish | fish
echo "Fish configured."

# Set default shell to Fish
chsh -s /data/data/com.termux/files/usr/bin/fish
echo "Fish set as the default shell."

# Set up Python and Node.js for development (npm packages)
echo "Setting up Python environment..."
pip install --upgrade pip
pip install virtualenv

echo "Setting up Node.js environment..."
npm install -g yarn
npm install -g express

# Install essential development tools
echo "Installing development tools..."
pkg install -y clang make python3-dev git

# Setup Sudo without a password for 'u0_a343'
echo "Configuring sudoers file for passwordless sudo..."
echo "u0_a343 ALL=(ALL) NOPASSWD:ALL" >> /data/data/com.termux/files/usr/etc/sudoers

# Fix permissions on sudoers file
chmod 440 /data/data/com.termux/files/usr/etc/sudoers

# Install any additional tools (like tmux, vim, etc.)
echo "Installing additional tools..."
pkg install -y tmux vim

# Final feedback
echo "Advanced Termux environment setup complete! Zsh and Fish are installed, development tools are set up, and sudo is configured."
echo "You can now start using the setup by launching Termux with Fish or Zsh!"
