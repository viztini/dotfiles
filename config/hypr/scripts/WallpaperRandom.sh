#!/usr/bin/env bash
set -euo pipefail
dir="$HOME/Pictures/wallpapers"
mapfile -t walls < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | sort)
((${#walls[@]})) || exit 1
pick="${walls[RANDOM % ${#walls[@]}]}"
matugen image "$pick" >/dev/null 2>&1 || true
ln -sf "$pick" "$HOME/.config/hypr/current_wallpaper"
