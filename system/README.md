# System reference configs

These are reference copies of system-level files from the live Fedora 45 machine.
They are **not** installed by `install.sh`.

- `thinkpad-battery-thresholds.service` — sets battery charge thresholds to 75/80.
- `ly-config.ini` — Ly display manager configuration from `/etc/ly/config.ini`.

SDDM was removed; Ly runs as `ly@tty2.service`.
