#!/bin/bash

# ==============================================================================
# SET TARGET SCRIPT - Rofi GUI / CLI Setter with Clipboard & Notifications
# ==============================================================================

TARGET_FILE="$HOME/.config/i3/target"
mkdir -p "$(dirname "$TARGET_FILE")"

if [ "$1" = "--clear" ] || [ "$1" = "-c" ]; then
    > "$TARGET_FILE"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Target IP" "Target cleared." -i dialog-warning -t 2000
    fi
    pkill -RTMIN+1 i3blocks 2>/dev/null || true
    exit 0
fi

if [ -n "$1" ]; then
    NEW_TARGET="$1"
else
    CURRENT_TARGET=$(cat "$TARGET_FILE" 2>/dev/null || echo "")
    if command -v rofi >/dev/null 2>&1; then
        NEW_TARGET=$(rofi -dmenu -p "Target IP" -mesg "Current: ${CURRENT_TARGET:-None}" -lines 0 -theme-str 'window {width: 380px;}')
    else
        read -p "Enter Target IP: " NEW_TARGET
    fi
fi

if [ -n "$NEW_TARGET" ]; then
    echo "$NEW_TARGET" > "$TARGET_FILE"
    if command -v xclip >/dev/null 2>&1; then
        echo -n "$NEW_TARGET" | xclip -selection clipboard
    fi
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Target IP Set" "Target: $NEW_TARGET (Copied to clipboard)" -i dialog-information -t 2500
    fi
    pkill -RTMIN+1 i3blocks 2>/dev/null || true
fi
