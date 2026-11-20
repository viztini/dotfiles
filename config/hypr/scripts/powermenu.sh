#!/usr/bin/env bash

options="Lock\nSuspend\nLogout\nReboot\nShutdown"

if command -v wofi &> /dev/null; then
    chosen=$(echo -e "$options" | wofi --dmenu \
        --prompt "Power" \
        --width 260 \
        --height 255 \
        --cache-file /dev/null \
        --style ~/.config/wofi/style.css)
elif command -v rofi &> /dev/null; then
    chosen=$(echo -e "$options" | rofi -dmenu \
        -p "Power" \
        -config ~/.config/rofi/config.rasi \
        -theme-str '
            * { accent: #E60012; }
            window { width: 260px; border-color: #E60012; }
            listview { lines: 5; }
            element selected.normal { background-color: #E60012; text-color: #ffffff; }
        ')
fi

case "$chosen" in
    "Lock") hyprlock || swaylock || loginctl lock-session ;;
    "Suspend") systemctl suspend ;;
    "Logout") hyprctl dispatch exit ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
esac
