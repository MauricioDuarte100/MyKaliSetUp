#!/bin/sh

# ==============================================================================
# TARGET STATUS SCRIPT (i3blocks) - With Click-to-Copy & Right-Click Edit
# ==============================================================================

TARGET_FILE="$HOME/.config/i3/target"
TARGET=""

if [ -f "$TARGET_FILE" ]; then
    TARGET=$(head -n 1 "$TARGET_FILE" 2>/dev/null | xargs)
fi

# Click Events
case "$BLOCK_BUTTON" in
    1) # Left click: Copy Target IP to clipboard
        if [ -n "$TARGET" ]; then
            echo -n "$TARGET" | xclip -selection clipboard 2>/dev/null
            if command -v notify-send >/dev/null 2>&1; then
                notify-send "Target IP" "$TARGET copied to clipboard." -i dialog-information -t 2000
            fi
        fi
        ;;
    3) # Right click: Open Target Setter GUI
        ~/.config/i3/scripts/set_target.sh &
        ;;
esac

# Display Output
if [ -n "$TARGET" ]; then
    echo "$TARGET"
    echo "$TARGET"
    echo "#FF7B72"
else
    echo "No Target"
    echo "No Target"
    echo "#7D8590"
fi
