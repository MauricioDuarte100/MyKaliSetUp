#!/bin/sh

# ==============================================================================
# VPN STATUS SCRIPT (i3blocks) - With Click-to-Copy
# ==============================================================================

# Detect VPN IP (OpenVPN tun0 or Wireguard wg0)
VPN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ -z "$VPN_IP" ]; then
    VPN_IP=$(ip -4 addr show wg0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
fi

if [ -z "$VPN_IP" ] && command -v ifconfig >/dev/null 2>&1; then
    VPN_IP=$(ifconfig tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
fi

# Click Events
case "$BLOCK_BUTTON" in
    1) # Left click: Copy to clipboard
        if [ -n "$VPN_IP" ]; then
            echo -n "$VPN_IP" | xclip -selection clipboard 2>/dev/null
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "🔒 VPN IP Copiada" "$VPN_IP copiada al portapapeles." -i network-vpn -t 2000
            fi
        fi
        ;;
esac

# Display Output
if [ -n "$VPN_IP" ]; then
    echo "$VPN_IP"
    echo "$VPN_IP"
    echo "#7EE787"
else
    echo "No VPN"
    echo "No VPN"
    echo "#7D8590"
fi
