#!/usr/bin/env bash
# ==============================================================================
# Kali-Clean: Minimalist & Ultra-Fast i3wm Cyber Environment Installer
# Inspired by xct (HackTheBox Omniscient) - Ultimate Pentesting & CTF Setup
# ==============================================================================

set -e

# Terminal Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info() {
    echo -e "${CYAN}[*] ${NC}$1"
}

log_success() {
    echo -e "${GREEN}[+] ${NC}$1"
}

log_warning() {
    echo -e "${YELLOW}[!] ${NC}$1"
}

log_error() {
    echo -e "${RED}[-] ${NC}$1"
}

# User check (Do not run directly as root; sudo is requested when needed)
if [ "$(id -u)" -eq 0 ]; then
    log_error "Do not run this script as root (do not use 'sudo ./install.sh')."
    log_info "Run it as your standard user: './install.sh'. The script will prompt for sudo when needed."
    exit 1
fi

BANNER="
   ███████╗  ██████╗  ██╗     ██╗      ██████╗██╗     ███████╗ █████╗ ███╗   ██╗
   ██╔════╝ ██╔═══██╗ ██║     ██║     ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║
   ███████╗ ██║   ██║ ██║     ██║     ██║     ██║     █████╗  ███████║██╔██╗ ██║
   ╚════██║ ██║   ██║ ██║     ██║     ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║
   ███████║ ╚██████╔╝ ███████╗███████╗╚██████╗███████╗███████╗██║  ██║██║ ╚████║
   ╚══════╝  ╚═════╝  ╚══════╝╚══════╝ ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
   ${BOLD}${CYAN}Kali Linux i3wm xct Edition - HackTheBox & Cybersecurity Setup${NC}
"
echo -e "$BANNER"

# ==============================================================================
# 1. SYSTEM UPDATE
# ==============================================================================
log_info "Updating package lists..."
sudo apt update -y

# ==============================================================================
# 2. INSTALL DEPENDENCIES & WINDOW MANAGER (i3wm + Tmux + Zsh)
# ==============================================================================
log_info "Installing core packages, Alacritty, i3wm, Tmux, Zsh and utilities..."

BASE_PKGS=(
    i3
    i3-wm
    i3blocks
    i3status
    i3lock
    alacritty
    picom
    feh
    rofi
    tmux
    zsh
    fzf
    bat
    ripgrep
    fd-find
    htop
    jq
    xclip
    dunst
    libnotify-bin
    thunar
    lxappearance
    arc-theme
    papirus-icon-theme
    pavucontrol
    flameshot
    unclutter
    imagemagick
    arandr
    xautolock
    xbacklight
    fonts-font-awesome
    fonts-roboto
    git
    curl
    wget
    unzip
    lightdm
    lightdm-gtk-greeter
    network-manager
    network-manager-gnome
    open-vm-tools-desktop
    spice-vdagent
    python3-pip
)

sudo apt install -y "${BASE_PKGS[@]}"

# ==============================================================================
# 3. NERD FONTS INSTALLATION (Iosevka & RobotoMono)
# ==============================================================================
log_info "Installing Nerd Fonts (Iosevka & RobotoMono)..."
mkdir -p ~/.local/share/fonts/
FONT_DIR="$HOME/.local/share/fonts"

if [ ! -f "$FONT_DIR/IosevkaNerdFont-Regular.ttf" ] && [ ! -f "$FONT_DIR/Iosevka.zip" ]; then
    log_info "Downloading Iosevka Nerd Font..."
    wget -q --show-progress -O /tmp/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip || \
    wget -q --show-progress -O /tmp/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
    unzip -qo /tmp/Iosevka.zip -d "$FONT_DIR/"
    rm -f /tmp/Iosevka.zip
fi

if [ ! -f "$FONT_DIR/RobotoMonoNerdFont-Regular.ttf" ] && [ ! -f "$FONT_DIR/RobotoMono.zip" ]; then
    log_info "Downloading RobotoMono Nerd Font..."
    wget -q --show-progress -O /tmp/RobotoMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip || \
    wget -q --show-progress -O /tmp/RobotoMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
    unzip -qo /tmp/RobotoMono.zip -d "$FONT_DIR/"
    rm -f /tmp/RobotoMono.zip
fi

fc-cache -fv >/dev/null 2>&1
log_success "Nerd fonts installed successfully."

# ==============================================================================
# 4. PYWAL INSTALLATION
# ==============================================================================
log_info "Installing pywal for dynamic palette support..."
sudo apt install -y python3-pywal 2>/dev/null || pip3 install pywal --break-system-packages 2>/dev/null || pip3 install pywal 2>/dev/null || true

# ==============================================================================
# 5. DEPLOY CONFIGURATION FILES & SCRIPTS
# ==============================================================================
log_info "Deploying dotfiles and configuration directories..."

# Create directory hierarchy
mkdir -p ~/.config/i3/scripts
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/rofi
mkdir -p ~/.config/picom
mkdir -p ~/.config/compton
mkdir -p ~/.config/dunst
mkdir -p ~/.wallpaper
mkdir -p ~/Pictures/Screenshots

# Copy configurations
cp -r .config/i3/* ~/.config/i3/ 2>/dev/null || true
cp -r .config/i3/scripts/* ~/.config/i3/scripts/ 2>/dev/null || true
cp .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp .config/rofi/config* ~/.config/rofi/ 2>/dev/null || true
cp .config/picom/picom.conf ~/.config/picom/picom.conf 2>/dev/null || true
cp .config/dunst/dunstrc ~/.config/dunst/dunstrc 2>/dev/null || true

# Copy Tmux configuration
cp .tmux.conf ~/.tmux.conf

# Copy wallpaper and feh startup script
cp -r .wallpaper/* ~/.wallpaper/ 2>/dev/null || true
cp .fehbg ~/.fehbg

# Ensure executable permissions
chmod +x ~/.fehbg
chmod +x ~/.config/i3/clipboard_fix.sh
chmod +x ~/.config/i3/scripts/*.sh 2>/dev/null || true

# Create default target file
touch ~/.config/i3/target

# Create ~/.xinitrc for startx support
cat << 'EOF' > ~/.xinitrc
#!/bin/sh
exec i3
EOF
chmod +x ~/.xinitrc

log_success "Configurations and scripts deployed successfully."

# ==============================================================================
# 6. SET I3 AS DEFAULT WINDOW MANAGER
# ==============================================================================
log_info "Setting i3 as the default session and window manager..."

sudo update-alternatives --set x-session-manager /usr/bin/i3 2>/dev/null || true
sudo update-alternatives --set x-window-manager /usr/bin/i3 2>/dev/null || true

# Configure LightDM default session
if [ -d /etc/lightdm ]; then
    sudo mkdir -p /etc/lightdm/lightdm.conf.d/
    sudo tee /etc/lightdm/lightdm.conf.d/50-i3-default.conf > /dev/null << 'EOF'
[Seat:*]
user-session=i3
autologin-session=i3
EOF
    sudo systemctl enable lightdm 2>/dev/null || true
fi

# ==============================================================================
# 7. SAFE DESKTOP ENVIRONMENT PURGE (GNOME / XFCE)
# ==============================================================================
echo ""
log_info "Optimizing system memory and CPU consumption..."
echo -e "${YELLOW}Do you want to purge heavy desktop environments (GNOME/XFCE) to keep i3 as the sole environment?${NC}"
echo -e "This reduces idle RAM consumption below 350 MB while preserving LightDM, network connectivity, and all Kali pentesting tools."

CLEAN_DE="yes"
if [ -t 0 ]; then
    read -rp "Purge GNOME/XFCE and optimize for i3 exclusively? [Y/n]: " user_response
    case "$user_response" in
        [nN][oO]|[nN])
            CLEAN_DE="no"
            ;;
        *)
            CLEAN_DE="yes"
            ;;
    esac
fi

if [ "$CLEAN_DE" = "yes" ]; then
    log_info "Safely removing heavy desktop environments..."
    
    # Ensure critical networking and display manager packages remain protected
    sudo apt-get install -y --no-install-recommends \
        lightdm lightdm-gtk-greeter xorg x11-xserver-utils \
        network-manager network-manager-gnome \
        pulseaudio pavucontrol thunar
    
    # Purge GNOME and XFCE packages safely
    sudo apt-get purge -y \
        kali-desktop-gnome gnome-core gnome-shell gnome-session gdm3 \
        kali-desktop-xfce xfce4 xfce4-session 2>/dev/null || true
        
    sudo apt-get autoremove -y --purge
    
    # Disable GNOME background indexing services
    systemctl --user mask tracker-miner-fs-3.service tracker-extract-3.service 2>/dev/null || true
    
    log_success "Desktop environments purged. i3 is configured as the sole window manager."
else
    log_info "Retained existing desktop environments. i3 remains the default option."
fi

# ==============================================================================
# 8. OH-MY-ZSH & PRODUCTIVITY PLUGIN SUITE (xct Style)
# ==============================================================================
log_info "Configuring Oh-My-Zsh and high-productivity plugins..."

# Unattended Oh-My-Zsh install if not already present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

# 1. zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log_info "Installing plugin: zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
fi

# 2. zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log_info "Installing plugin: zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
fi

# 3. fzf-tab
if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
    log_info "Installing plugin: fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab" 2>/dev/null || true
fi

# 4. zsh-history-substring-search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    log_info "Installing plugin: zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search" 2>/dev/null || true
fi

# Deploy master .zshrc
if [ -f .zshrc ]; then
    cp .zshrc "$HOME/.zshrc"
    log_success "Master .zshrc deployed successfully."
fi

# Set default user shell to zsh
if [ "$SHELL" != "$(which zsh)" ] && [ -x "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || true
fi

# ==============================================================================
# 9. SUMMARY & VERIFICATION
# ==============================================================================
echo ""
echo -e "${GREEN}==============================================================================${NC}"
echo -e "${BOLD}${GREEN}   [SUCCESS] INSTALLATION & CONFIGURATION COMPLETED!   ${NC}"
echo -e "${GREEN}==============================================================================${NC}"
echo ""
echo -e "${CYAN}Key Features Ready for Pentesting & CTFs:${NC}"
echo -e " - ${BOLD}Interactive Status Bar${NC}: Left-click Target or VPN to copy IP to clipboard."
echo -e " - ${BOLD}Scratchpad Terminal${NC}: Press ${BOLD}Mod + u${NC} to toggle a dropdown floating terminal."
echo -e " - ${BOLD}Copy Target IP${NC}: Press ${BOLD}Mod + c${NC} or execute the ${BOLD}cptar${NC} command."
echo -e " - ${BOLD}Rofi Power Menu${NC}: Press ${BOLD}Mod + Shift + e${NC} for system power options."
echo -e " - ${BOLD}Tmux Pro${NC}: Mouse scrolling, Vim navigation ('Alt + h/j/k/l'), and live status bar."
echo -e " - ${BOLD}Zsh Plugins${NC}: Autosuggestions, Syntax Highlighting, FZF-tab, and offensive helpers."
echo ""
echo -e "${YELLOW}Please restart your system with 'sudo reboot' to launch your new environment.${NC}"
echo ""
