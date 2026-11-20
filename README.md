# Fedora ThinkPad Hyprland dotfiles

Personal dotfiles and desktop rice for Fedora 45 on a ThinkPad, captured from `/home/lain`.

This is a **local snapshot only** — no remote has been configured yet.

## Highlights

- Hyprland 0.57 **Lua** config (classic `.conf` files are kept for reference)
- Waybar, Rofi, Kitty, swaync, wlogout, matugen, fastfetch, cava
- ThinkPad media keys, TrackPoint/touchpad tuning, natural scrolling, gestures
- Cherry-blossom pink + TrackPoint red palette
- Ly TUI display manager on `tty2` (SDDM removed)
- Fingerprint unlock via `authselect with-fingerprint`
- TLP/TLP-PD power management; battery charge thresholds **75/80**
- 59 wallpapers from `~/Pictures/wallpapers`

## Repository layout

```text
shell/       shell dotfiles (.zshrc, .zprofile, .bashrc, .bashrc.d, ...)
config/      ~/.config contents for the rice and desktop apps
wallpapers/  wallpaper library
system/      reference copies of system-level configs (not installed automatically)
install.sh   symlink installer with backup support
```

## Install

From a fresh clone:

```bash
cd ~/dotfiles
./install.sh
```

`install.sh` symlinks the dotfiles into `$HOME` and `$HOME/.config`. Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before linking.

Skip the wallpaper symlink if you already manage `~/Pictures/wallpapers`:

```bash
./install.sh --no-wallpapers
```

Log out and back in (or reboot) after installing.

## Dependencies

Key packages used by this setup:

```bash
sudo dnf copr enable nett00n/hyprland
sudo dnf copr enable heus-sueh/packages
sudo dnf install hyprland hyprlock hypridle waybar swww swaync rofi kitty \
  nautilus ranger matugen fastfetch wlogout pipewire wireplumber \
  playerctl brightnessctl grim slurp hyprpicker \
  zsh oh-my-zsh
```

Nerd Fonts: JetBrains Mono Nerd Font is used in the terminal/bar configs.

## Fedora / ThinkPad notes

- Display manager: `ly@tty2.service` is enabled; there is no `display-manager.service` symlink and SDDM is not installed.
- Fingerprint: enroll with `fprintd-enroll`, then unlock with your finger at Ly or hyprlock.
- Battery: `system/thinkpad-battery-thresholds.service` is a reference copy of the active 75/80 threshold service.
- Power: TLP and TLP-PD are enabled; tuned is intentionally not used because they conflict.
- Startup is deliberately light: Waybar, wallpaper, and polkit agent start immediately; `nm-applet`, `swaync`, and `hypridle` are deferred by 3–5 seconds.

## Not included

For safety and size, this repo intentionally excludes:

- shell history (`.zsh_history`, `.bash_history`)
- browser profiles and mail/KDE account data
- SSH keys, tokens, certificates, and private keys
- `.local/share` app data, caches, logs, and zsh completion dumps
- the original `.config-backup-*` and `.setup-backup-*` directories

Wallpapers are included because they were explicitly requested.
