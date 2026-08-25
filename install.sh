#!/usr/bin/env bash
# ==============================================================================
# 🛡️ Kali-Clean: Minimalist & Ultra-Fast i3 Cyber Environment Installer
# Inspired by xct (HackTheBox Omniscient) - Ultimate Pentesting & CTF Setup
# ==============================================================================

set -e

# Colores de Terminal
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

# Verificación de usuario (No ejecutar como root directamente, pero se requerirá sudo)
if [ "$(id -u)" -eq 0 ]; then
    log_error "No ejecutes este script como root (no uses 'sudo ./install.sh')."
    log_info "Ejecútalo como tu usuario normal: './install.sh'. El script solicitará sudo cuando sea necesario."
    exit 1
fi

BANNER="
   ███████╗  ██████╗  ██╗     ██╗      ██████╗██╗     ███████╗ █████╗ ███╗   ██╗
   ██╔════╝ ██╔═══██╗ ██║     ██║     ██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║
   ███████╗ ██║   ██║ ██║     ██║     ██║     ██║     █████╗  ███████║██╔██╗ ██║
   ╚════██║ ██║   ██║ ██║     ██║     ██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║
   ███████║ ╚██████╔╝ ███████╗███████╗╚██████╗███████╗███████╗██║  ██║██║ ╚████║
   ╚══════╝  ╚═════╝  ╚══════╝╚══════╝ ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝
   ${BOLD}${CYAN}Kali Linux i3wm xct Edition - HackTheBox & Cybersecurity Pro Setup${NC}
"
echo -e "$BANNER"

# ==============================================================================
# 1. ACTUALIZACIÓN DEL SISTEMA
# ==============================================================================
log_info "Actualizando repositorios e índices de paquetes..."
sudo apt update -y

# ==============================================================================
# 2. INSTALACIÓN DE DEPENDENCIAS Y GESTOR DE VENTANAS (i3wm + Tmux + Zsh)
# ==============================================================================
log_info "Instalando paquetes base, Alacritty, i3wm, Tmux, Zsh y utilidades..."

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
# 3. FUENTES NERD FONTS (Iosevka & RobotoMono)
# ==============================================================================
log_info "Instalando fuentes Nerd Fonts (Iosevka & RobotoMono)..."
mkdir -p ~/.local/share/fonts/
FONT_DIR="$HOME/.local/share/fonts"

if [ ! -f "$FONT_DIR/IosevkaNerdFont-Regular.ttf" ] && [ ! -f "$FONT_DIR/Iosevka.zip" ]; then
    log_info "Descargando Iosevka Nerd Font..."
    wget -q --show-progress -O /tmp/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip || \
    wget -q --show-progress -O /tmp/Iosevka.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Iosevka.zip
    unzip -qo /tmp/Iosevka.zip -d "$FONT_DIR/"
    rm -f /tmp/Iosevka.zip
fi

if [ ! -f "$FONT_DIR/RobotoMonoNerdFont-Regular.ttf" ] && [ ! -f "$FONT_DIR/RobotoMono.zip" ]; then
    log_info "Descargando RobotoMono Nerd Font..."
    wget -q --show-progress -O /tmp/RobotoMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/RobotoMono.zip || \
    wget -q --show-progress -O /tmp/RobotoMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/RobotoMono.zip
    unzip -qo /tmp/RobotoMono.zip -d "$FONT_DIR/"
    rm -f /tmp/RobotoMono.zip
fi

fc-cache -fv >/dev/null 2>&1
log_success "Fuentes instaladas correctamente."

# ==============================================================================
# 4. INSTALACIÓN DE PYWAL (Soporte PEP 668)
# ==============================================================================
log_info "Instalando pywal para gestión de paletas..."
sudo apt install -y python3-pywal 2>/dev/null || pip3 install pywal --break-system-packages 2>/dev/null || pip3 install pywal 2>/dev/null || true

# ==============================================================================
# 5. DESPLIEGUE DE ARCHIVOS DE CONFIGURACIÓN
# ==============================================================================
log_info "Copiando dotfiles y configuraciones (.config, wallpapers, scripts, tmux, zsh)..."

# Crear directorios
mkdir -p ~/.config/i3/scripts
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/rofi
mkdir -p ~/.config/picom
mkdir -p ~/.config/compton
mkdir -p ~/.config/dunst
mkdir -p ~/.wallpaper
mkdir -p ~/Pictures/Screenshots

# Copiar configuraciones
cp -r .config/i3/* ~/.config/i3/ 2>/dev/null || true
cp -r .config/i3/scripts/* ~/.config/i3/scripts/ 2>/dev/null || true
cp .config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
cp .config/rofi/config* ~/.config/rofi/ 2>/dev/null || true
cp .config/picom/picom.conf ~/.config/picom/picom.conf 2>/dev/null || true
cp .config/compton/compton.conf ~/.config/compton/compton.conf 2>/dev/null || true
cp .config/dunst/dunstrc ~/.config/dunst/dunstrc 2>/dev/null || true

# Copiar Tmux Config
cp .tmux.conf ~/.tmux.conf

# Copiar fondo de pantalla y script de feh
cp -r .wallpaper/* ~/.wallpaper/ 2>/dev/null || true
cp .fehbg ~/.fehbg

# Permisos de ejecución
chmod +x ~/.fehbg
chmod +x ~/.config/i3/clipboard_fix.sh
chmod +x ~/.config/i3/scripts/*.sh 2>/dev/null || true

# Crear archivo de Target por defecto
touch ~/.config/i3/target

# Crear ~/.xinitrc para soporte de startx
cat << 'EOF' > ~/.xinitrc
#!/bin/sh
exec i3
EOF
chmod +x ~/.xinitrc

log_success "Archivos de configuración y scripts desplegados con éxito."

# ==============================================================================
# 6. CONFIGURAR I3 COMO ENTORNO PREDETERMINADO
# ==============================================================================
log_info "Configurando i3 como gestor de ventanas predeterminado en el sistema..."

sudo update-alternatives --set x-session-manager /usr/bin/i3 2>/dev/null || true
sudo update-alternatives --set x-window-manager /usr/bin/i3 2>/dev/null || true

# Configurar LightDM para iniciar sesión en i3 por defecto
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
# 7. LIMPIEZA SEGURA DE ENTORNOS PESADOS (GNOME / XFCE)
# ==============================================================================
echo ""
log_info "Optimizando consumo de recursos (RAM/CPU)..."
echo -e "${YELLOW}¿Deseas desinstalar los entornos pesados (GNOME/XFCE) para dejar i3 como único entorno ultra-rápido?${NC}"
echo -e "Esto liberará espacio y recursos en RAM mientras preserva LightDM, la red y todas tus herramientas de Kali."

CLEAN_DE="yes"
if [ -t 0 ]; then
    read -rp "Desinstalar GNOME/XFCE y optimizar para i3 únicamente? [S/n]: " user_response
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
    log_info "Eliminando entornos de escritorio pesados de forma segura..."
    
    # Asegurar que los componentes críticos nunca se eliminen
    sudo apt-get install -y --no-install-recommends \
        lightdm lightdm-gtk-greeter xorg x11-xserver-utils \
        network-manager network-manager-gnome \
        pulseaudio pavucontrol thunar
    
    # Remover GNOME y XFCE de forma segura
    sudo apt-get purge -y \
        kali-desktop-gnome gnome-core gnome-shell gnome-session gdm3 \
        kali-desktop-xfce xfce4 xfce4-session 2>/dev/null || true
        
    sudo apt-get autoremove -y --purge
    
    # Desactivar indexadores pesados de GNOME
    systemctl --user mask tracker-miner-fs-3.service tracker-extract-3.service 2>/dev/null || true
    
    log_success "Entornos pesados eliminados. i3 configurado como gestor único."
else
    log_info "Se mantuvieron los otros entornos. i3 sigue siendo la opción predeterminada."
fi

# ==============================================================================
# 8. OH-MY-ZSH Y SUITE DE PLUGINS DE ALTA PRODUCTIVIDAD (xct Style)
# ==============================================================================
log_info "Configurando Oh-My-Zsh y plugins de alta productividad..."

# Instalación desatendida de Oh-My-Zsh si no existe
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

# 1. zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    log_info "Instalando plugin: zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
fi

# 2. zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    log_info "Instalando plugin: zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
fi

# 3. fzf-tab
if [ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]; then
    log_info "Instalando plugin: fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab" 2>/dev/null || true
fi

# 4. zsh-history-substring-search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    log_info "Instalando plugin: zsh-history-substring-search..."
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search" 2>/dev/null || true
fi

# Desplegar .zshrc maestro
if [ -f .zshrc ]; then
    cp .zshrc "$HOME/.zshrc"
    log_success "Archivo .zshrc maestro desplegado correctamente."
fi

# Cambiar shell por defecto a zsh si está disponible
if [ "$SHELL" != "$(which zsh)" ] && [ -x "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null || true
fi

# ==============================================================================
# 9. FINALIZACIÓN Y VERIFICACIÓN
# ==============================================================================
echo ""
echo -e "${GREEN}==============================================================================${NC}"
echo -e "${BOLD}${GREEN}   ✓ INSTALACIÓN Y CONFIGURACIÓN COMPLETADA CON ÉXITO!   ${NC}"
echo -e "${GREEN}==============================================================================${NC}"
echo ""
echo -e "${CYAN}Características listas para Pentesting & CTF:${NC}"
echo -e " • ${BOLD}Target & VPN Interactivos${NC}: Clic en la barra para copiar la IP al portapapeles."
echo -e " • ${BOLD}Scratchpad Terminal${NC}: Presiona ${BOLD}Mod + u${NC} para desplegar una terminal flotante."
echo -e " • ${BOLD}Copiar Target IP${NC}: Presiona ${BOLD}Mod + c${NC} o usa el comando ${BOLD}cptar${NC}."
echo -e " • ${BOLD}Menu de Apagado Rofi${NC}: Presiona ${BOLD}Mod + Shift + e${NC}."
echo -e " • ${BOLD}Tmux Pro${NC}: Soporte de ratón, navegación Vim ('Alt + h/j/k/l') y Target en la barra."
echo -e " • ${BOLD}Zsh Plugins${NC}: Autosuggestions, Syntax Highlighting, FZF-tab y atajos ofensivos."
echo ""
echo -e "${YELLOW}Por favor reinicia tu sistema con 'sudo reboot' para disfrutar de tu nuevo entorno.${NC}"
echo ""
