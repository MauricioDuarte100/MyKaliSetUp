#!/usr/bin/env bash
# ==============================================================================
# Kali-Clean: Fast Dotfiles & Configuration Updater
# Para la comunidad con amor del sultan
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}[*] Updating Kali-Clean configuration files...${NC}"

# 1. Directories
mkdir -p ~/.config/i3/scripts
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/rofi
mkdir -p ~/.config/picom
mkdir -p ~/.config/dunst
mkdir -p ~/.wallpaper
mkdir -p ~/Pictures/Screenshots

# 2. Deploy configs
cp -r .config/i3/* ~/.config/i3/ 2>/dev/null || true
cp -r .config/i3/scripts/* ~/.config/i3/scripts/ 2>/dev/null || true
cp .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml 2>/dev/null || true
cp .config/rofi/config.rasi ~/.config/rofi/config.rasi 2>/dev/null || true
cp .config/picom/picom.conf ~/.config/picom/picom.conf 2>/dev/null || true
cp .config/dunst/dunstrc ~/.config/dunst/dunstrc 2>/dev/null || true

# 3. Deploy shell & tmux configs
[ -f .zshrc ] && cp .zshrc ~/.zshrc
[ -f .bashrc ] && cp .bashrc ~/.bashrc
[ -f .tmux.conf ] && cp .tmux.conf ~/.tmux.conf
[ -f .fehbg ] && cp .fehbg ~/.fehbg
cp -r .wallpaper/* ~/.wallpaper/ 2>/dev/null || true

# 4. Permissions
chmod +x ~/.fehbg 2>/dev/null || true
chmod +x ~/.config/i3/clipboard_fix.sh 2>/dev/null || true
chmod +x ~/.config/i3/scripts/*.sh 2>/dev/null || true
touch ~/.config/i3/target

# 5. Reload environment
if pgrep -x i3 >/dev/null 2>&1; then
    i3-msg restart >/dev/null 2>&1 || true
fi

if pgrep -x picom >/dev/null 2>&1; then
    pkill -x picom 2>/dev/null || true
    picom -b --config ~/.config/picom/picom.conf 2>/dev/null || true
fi

echo -e "${GREEN}${BOLD}[+] Kali-Clean configuration updated successfully!${NC}"
echo -e "${YELLOW}Open a new terminal (Mod+Return) to see your upgraded cyber shell.${NC}"
