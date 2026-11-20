#!/usr/bin/env bash
case "${1:-status}" in
  toggle)
    if pgrep -x hypridle >/dev/null; then pkill -x hypridle; else hypridle >/dev/null 2>&1 & fi ;;
  status)
    pgrep -x hypridle >/dev/null && echo "on" || echo "off" ;;
esac
