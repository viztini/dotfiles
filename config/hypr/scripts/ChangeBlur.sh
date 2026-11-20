#!/usr/bin/env bash
state=$(hyprctl -j getoption decoration:blur:enabled | jq -r '.int // .value // 0')
if [[ "$state" == "1" || "$state" == "true" ]]; then
  hyprctl keyword decoration:blur:enabled false
else
  hyprctl keyword decoration:blur:enabled true
fi
