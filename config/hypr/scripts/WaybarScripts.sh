#!/usr/bin/env bash
case "${1:-}" in
  --term)   exec kitty ;;
  --btop)   exec kitty -e top ;;
  --nmtui)  exec kitty -e nmtui ;;
  --nvtop)  exec kitty -e htop ;;
  *)        exec kitty ;;
esac
