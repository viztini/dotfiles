#!/usr/bin/env bash
exec kitty -e bash -c 'dnf5 upgrade -y; echo; echo "Press Enter to close"; read'
