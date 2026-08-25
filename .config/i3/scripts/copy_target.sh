#!/bin/bash

# ==============================================================================
# COPY TARGET SCRIPT - Copies Target IP to Clipboard with Notification
# ==============================================================================

TARGET_FILE="$HOME/.config/i3/target"

if [ -f "$TARGET_FILE" ]; then
    TARGET=$(head -n 1 "$TARGET_FILE" 2>/dev/null | xargs)
    if [ -n "$TARGET" ]; then
        if command -v xclip >/dev/null 2>&1; then
            echo -n "$TARGET" | xclip -selection clipboard
        fi
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Target IP" "$TARGET copied to clipboard." -i dialog-information -t 2000
        fi
        exit 0
    fi
fi

if command -v notify-send >/dev/null 2>&1; then
    notify-send "Target IP" "No active target set." -i dialog-warning -t 2000
fi
