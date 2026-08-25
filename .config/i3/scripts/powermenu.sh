#!/bin/bash

# ==============================================================================
# ROFI POWER MENU - KALI CYBER ENVIRONMENT
# ==============================================================================

options="🔒 Bloquear Pantalla\n🚪 Cerrar Sesión (i3)\n🔄 Reiniciar Sistema\n🛑 Apagar Sistema\n💤 Suspender"

chosen=$(echo -e "$options" | rofi -dmenu -p "⚡ Sistema" -theme-str 'window {width: 320px;}')

case "$chosen" in
    "🔒 Bloquear Pantalla")
        i3lock -c 0f141c
        ;;
    "🚪 Cerrar Sesión (i3)")
        i3-msg exit
        ;;
    "🔄 Reiniciar Sistema")
        systemctl reboot
        ;;
    "🛑 Apagar Sistema")
        systemctl poweroff
        ;;
    "💤 Suspender")
        systemctl suspend
        ;;
esac
