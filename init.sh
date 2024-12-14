#!/bin/bash

# Automation Script for Arch Linux

# ------------- Configurations -------------

# Log file
LOG_FILE="$HOME/automation.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Dotfiles repository
DOTFILES_REPO="https://github.com/anglakey/ArchLinuxBuild"

# Programs to pre-install via paru
PRE_INSTALL_PROGRAMS=("fenshi" "nvchad" "jellyfin-media-player" "vulkan-radeon" "lib32-vulkan-radeon" "steam")

# ------------- Functions -------------

log() {
    echo -e "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

error_exit() {
    log "${RED}[ERROR]${NC} $1"
    exit 1
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "This script must be run as root. Use sudo or run as root user."
    fi
}

enable_multilib() {
    log "Enabling multilib repository..."
    if grep -q "^\[multilib\]" /etc/pacman.conf && grep -q "Include = /etc/pacman.d/mirrorlist" /etc/pacman.conf; then
        log "${GREEN}Multilib repository is already enabled.${NC}"
    else
        sudo sed -i '/^\#\[multilib\]/,/^\#Include/s/^#//' /etc/pacman.conf || error_exit "Failed to enable multilib repository."
        log "${GREEN}Multilib repository enabled successfully.${NC}"
    fi

    log "Updating package databases..."
    sudo pacman -Sy || error_exit "Failed to update package databases."
}

install_paru() {
    if ! command -v paru &> /dev/null; then
        log "${YELLOW}Paru is not installed. Installing paru...${NC}"
        sudo pacman -S --noconfirm --needed base-devel git
        cd /tmp || error_exit "Failed to navigate to /tmp"
        git clone https://aur.archlinux.org/paru-bin.git || error_exit "Failed to clone paru-bin repository."
        cd paru-bin || error_exit "Failed to navigate to paru-bin directory."
        makepkg -si --noconfirm || error_exit "Failed to build and install paru."
        log "${GREEN}Paru installed successfully.${NC}"
    else
        log "${GREEN}Paru is already installed.${NC}"
    fi
}

clone_dotfiles() {
    log "Cloning dotfiles repository from $DOTFILES_REPO..."
    if [ -d "$HOME/dotfiles" ]; then
        log "${YELLOW}Dotfiles directory already exists. Removing it...${NC}"
        rm -rf "$HOME/dotfiles"
    fi
    git clone $DOTFILES_REPO "$HOME/dotfiles" || error_exit "Failed to clone dotfiles repository."
    log "${GREEN}Dotfiles cloned successfully.${NC}"
}

transfer_config() {
    log "Transferring .config folder to ~/.config..."
    if [ -d "$HOME/dotfiles/.config" ]; then
        mkdir -p "$HOME/.config"
        cp -r "$HOME/dotfiles/.config/"* "$HOME/.config/" || error_exit "Failed to copy .config folder."
        log "${GREEN}.config folder transferred successfully.${NC}"
    else
        error_exit "No .config folder found in the dotfiles repository."
    fi
}

transfer_amdgpu_conf() {
    log "Copying amdgpu.conf to /etc/X11/xorg.conf.d/20-amdgpu.conf..."
    if [ -f "$HOME/dotfiles/amdgpu.conf" ]; then
        sudo mkdir -p /etc/X11/xorg.conf.d
        sudo cp "$HOME/dotfiles/amdgpu.conf" /etc/X11/xorg.conf.d/20-amdgpu.conf || error_exit "Failed to copy amdgpu.conf."
        log "${GREEN}amdgpu.conf copied successfully.${NC}"
    else
        error_exit "amdgpu.conf not found in the dotfiles repository."
    fi
}

copy_xinitrc_and_xresources() {
    log "Copying .xinitrc and .Xresources to the home directory..."
    if [ -f "$HOME/dotfiles/.xinitrc" ]; then
        cp "$HOME/dotfiles/.xinitrc" "$HOME/.xinitrc" || error_exit "Failed to copy .xinitrc."
        log "${GREEN}.xinitrc copied successfully.${NC}"
    else
        error_exit ".xinitrc not found in the dotfiles repository."
    fi

    if [ -f "$HOME/dotfiles/.Xresources" ]; then
        cp "$HOME/dotfiles/.Xresources" "$HOME/.Xresources" || error_exit "Failed to copy .Xresources."
        log "${GREEN}.Xresources copied successfully.${NC}"
    else
        error_exit ".Xresources not found in the dotfiles repository."
    fi
}

install_dwm() {
    log "Installing dwm..."
    if [ -d "$HOME/dotfiles/dwm" ]; then
        cd "$HOME/dotfiles/dwm" || error_exit "Failed to navigate to dwm directory."
        sudo make clean install || error_exit "Failed to build and install dwm."
        log "${GREEN}dwm installed successfully.${NC}"
    else
        error_exit "dwm directory not found in the dotfiles repository."
    fi
}

install_dwmblocks() {
    log "Installing dwmblocks..."
    if [ -d "$HOME/dotfiles/dwmblocks" ]; then
        cd "$HOME/dotfiles/dwmblocks" || error_exit "Failed to navigate to dwmblocks directory."
        sudo make clean install || error_exit "Failed to build and install dwmblocks."
        log "${GREEN}dwmblocks installed successfully.${NC}"
    fi
}

install_st() {
    log "Installing st..."
    if [ -d "$HOME/dotfiles/st" ]; then
        cd "$HOME/dotfiles/st" || error_exit "Failed to navigate to st directory."
        sudo make clean install || error_exit "Failed to build and install st."
        log "${GREEN}st installed successfully.${NC}"
    else
        error_exit "st directory not found in the dotfiles repository."
    fi
}

preinstall_programs() {
    log "Pre-installing programs: ${PRE_INSTALL_PROGRAMS[*]}..."
    for program in "${PRE_INSTALL_PROGRAMS[@]}"; do
        paru -S --noconfirm "$program" || error_exit "Failed to install $program."
        log "${GREEN}$program installed successfully.${NC}"
    done
}

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -m | --multilib           Enable multilib repository"
    echo "  -p | --paru               Install paru"
    echo "  -c | --clone              Clone dotfiles from GitHub"
    echo "  -t | --transfer           Transfer .config folder to ~/.config"
    echo "  --amdgpu                  Copy amdgpu.conf to /etc/X11/xorg.conf.d/20-amdgpu.conf"
    echo "  --xfiles                  Copy .xinitrc and .Xresources to the home directory"
    echo "  --dwm                     Build and install dwm"
    echo "  --dwmblocks               Build and install dwmblocks"
    echo "  --st                      Build and install st"
    echo "  --preinstall              Pre-install defined programs: ${PRE_INSTALL_PROGRAMS[*]}"
    echo "  -h | --help               Display this help message"
    exit 1
}

# ------------- Main Script -------------

if [ $# -eq 0 ]; then
    usage
fi

while [ "$1" != "" ]; do
    case $1 in
        -m | --multilib) enable_multilib ;;
        -p | --paru) install_paru ;;
        -c | --clone) clone_dotfiles ;;
        -t | --transfer) transfer_config ;;
        --amdgpu) transfer_amdgpu_conf ;;
        --xfiles) copy_xinitrc_and_xresources ;;
        --dwm) install_dwm ;;
        --dwmblocks) install_dwmblocks ;;
        --st) install_st ;;
        --preinstall) preinstall_programs ;;
        -h | --help) usage ;;
        *) usage ;;
    esac
    shift
done
