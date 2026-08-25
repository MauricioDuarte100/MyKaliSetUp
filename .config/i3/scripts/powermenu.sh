#!/bin/bash

# ==============================================================================
# ROFI POWER MENU - KALI CYBER ENVIRONMENT
# ==============================================================================

options="Lock Screen\nLogout\nReboot\nShutdown\nSuspend"

chosen=$(echo -e "$options" | rofi -dmenu -p "System" -theme-str 'window {width: 280px;}')

case "$chosen" in
    "Lock Screen")
        i3lock -c 0f141c
        ;;
    "Logout")
        i3-msg exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Suspend")
        systemctl suspend
        ;;
esac
