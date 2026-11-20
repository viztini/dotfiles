# Console (TUI) login: greet, then drop straight into Hyprland on tty1.
# Only triggers on a real VT1 login — never inside an existing graphical session.
if [[ -t 0 && -z "$WAYLAND_DISPLAY" && -z "$DISPLAY" && ( "$XDG_VTNR" == "1" || "$(tty)" == "/dev/tty1" ) ]]; then
    export XDG_SESSION_TYPE=wayland
    fastfetch
    exec uwsm start -g -1 -e -D Hyprland hyprland.desktop
fi
