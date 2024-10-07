#!/bin/bash

# Automation Script for Arch Linux

# ------------- Configurations -------------

# Log file (You can change this path)
LOG_FILE="$HOME/automation.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ------------- Functions ------------- 

# Logging function
log() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Error handling
error_exit() {
    log "${RED}[ERROR]${NC} $1"
    exit 1
}

# Check if root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "This script must be run as root. Use sudo or run as root user."
    fi
}

# Check if paru is installed and install if missing
install_paru() {
    if ! command -v paru &> /dev/null; then
        log "${YELLOW}Paru is not installed. Installing paru...${NC}"
        sudo pacman -S --noconfirm --needed base-devel
        cd /tmp || error_exit "Failed to navigate to /tmp"
        git clone https://aur.archlinux.org/paru-bin.git || error_exit "Failed to clone paru-bin"
        cd paru-bin || error_exit "Failed to navigate to paru-bin directory"
        makepkg -si --noconfirm || error_exit "Failed to build and install paru"
        log "${GREEN}Paru installed successfully.${NC}"
    else
        log "${GREEN}Paru is already installed.${NC}"
    fi
}

# Package installer (You can add your own programs here)
install_packages() {
    log "Installing packages using paru..."
    packages=("nvchad" "git" "htop" "steam" "bolt-launcher" "brave-bin" "lutris" "monero-gui" "nemo" "pavucontrol" "feishin-bin" "rofi" "pipewire" "noto-fonts-emoji" "blueberry" "flameshot" "file-roller" "filezilla" "galculator" "lxappearance" "jellyfin-media-player" "pipewire-alsa" "pipewire-pulse" "protontricks" "polkit-kde-agent" "numlockx" "dunst" "picom" "feh" ) # Add your desired packages here
    paru -Syu --noconfirm "${packages[@]}"
}

# Parse arguments
usage() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -i | --install      Install essential packages"
    echo "  -h | --help         Display this help message"
    exit 1
}

# ------------- Main Script -------------

if [ $# -eq 0 ]; then
    usage
fi

# Ensure paru is installed before performing any tasks
install_paru

while [ "$1" != "" ]; do
    case $1 in
        -i | --install)
            install_packages
            ;;
        -h | --help)
            usage
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# ------------- End of Script -------------

