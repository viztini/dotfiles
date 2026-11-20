#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT:-$HOME/.dotfiles-backup}/$STAMP"
LINK_WALLPAPERS=1

usage() {
    cat <<'EOF'
Usage: ./install.sh [--no-wallpapers]

Symlinks this repo's dotfiles into $HOME and $HOME/.config.
Existing files/directories are backed up to ~/.dotfiles-backup/<timestamp>/.
EOF
}

for arg in "$@"; do
    case "$arg" in
        --no-wallpapers) LINK_WALLPAPERS=0 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
    esac
done

link_path() {
    local src="$1" dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
        echo "already linked: $dst"
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup="$BACKUP_DIR/${dst#$HOME/}"
        mkdir -p "$(dirname "$backup")"
        echo "backing up: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    echo "linking: $dst -> $src"
    ln -s "$src" "$dst"
}

shopt -s nullglob

for src in "$REPO_DIR"/shell/.* "$REPO_DIR"/shell/*; do
    [ -e "$src" ] || [ -L "$src" ] || continue
    [ "$(basename "$src")" = "." ] && continue
    [ "$(basename "$src")" = ".." ] && continue
    link_path "$src" "$HOME/$(basename "$src")"
done

for src in "$REPO_DIR"/config/* "$REPO_DIR"/config/.*; do
    [ -e "$src" ] || [ -L "$src" ] || continue
    name="$(basename "$src")"
    [ "$name" = "." ] && continue
    [ "$name" = ".." ] && continue
    link_path "$src" "$HOME/.config/$name"
done

if [ "$LINK_WALLPAPERS" -eq 1 ]; then
    link_path "$REPO_DIR/wallpapers" "$HOME/Pictures/wallpapers"
fi

echo
echo "Done. Backup directory (if used): $BACKUP_DIR"
echo "Log out and back in for all changes to take effect."
