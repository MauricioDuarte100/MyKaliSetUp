#!/bin/bash

# Update and Upgrade
sudo apt update && sudo apt upgrade -y

# Basic Utilities
sudo apt-get install -y wget curl git thunar unzip xfce4-power-manager dunst lxpolkit brightnessctl

# UI/UX & Window Management
# Note: Modern i3 in Kali repositories already supports gaps, no need to compile from source usually.
sudo apt-get install -y arandr flameshot arc-theme feh i3blocks i3status i3 i3-wm lxappearance python3-pip rofi unclutter cargo picom papirus-icon-theme imagemagick alacritty

# Install Fonts
mkdir -p ~/.local/share/fonts/

if [ ! -d ~/.local/share/fonts/Iosevka ]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
    unzip -o Iosevka.zip -d ~/.local/share/fonts/
fi

if [ ! -d ~/.local/share/fonts/RobotoMono ]; then
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
    unzip -o RobotoMono.zip -d ~/.local/share/fonts/
fi

fc-cache -fv

# Install Pywal
pip3 install pywal --break-system-packages 2>/dev/null || pip3 install pywal

# Create Config Directories
mkdir -p ~/.config/i3
mkdir -p ~/.config/picom
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/.wallpaper

# Copy Config Files
# We use -u to update only if newer, or standard cp
cp -r .config/i3/* ~/.config/i3/
cp -r .config/picom/* ~/.config/picom/
cp -r .config/rofi/* ~/.config/rofi/
cp -r .config/alacritty/* ~/.config/alacritty/ 2>/dev/null || true
cp .fehbg ~/.fehbg
cp -r .wallpaper/* ~/.wallpaper/

# Make scripts executable
chmod +x ~/.config/i3/clipboard_fix.sh

echo "Done! Grab some wallpaper and run pywal -i filename to set your color scheme. To have the wallpaper set on every boot edit ~.fehbg"
echo "After reboot: Select i3 on login, run lxappearance and select arc-dark"

# Oh My Zsh (Optional - Interactive)
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
