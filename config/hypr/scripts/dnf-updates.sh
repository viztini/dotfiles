#!/usr/bin/env bash
# Number of available Fedora package updates (waybar custom/updater module).
dnf5 -q check-update 2>/dev/null | grep -c '^[^[:space:]]' || true
