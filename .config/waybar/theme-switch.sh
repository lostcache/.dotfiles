#!/bin/bash
THEMES_DIR="$HOME/.config/waybar/themes"
CURRENT="$THEMES_DIR/current.css"
themes=(rose-pine vague)
current=$(basename "$(readlink "$CURRENT")" .css)
idx=0
for i in "${!themes[@]}"; do
  [[ "${themes[$i]}" == "$current" ]] && idx=$(( (i+1) % ${#themes[@]} )) && break
done
ln -sf "$THEMES_DIR/${themes[$idx]}.css" "$CURRENT"
pkill -SIGUSR2 waybar
sleep 0.1
pkill -SIGRTMIN+8 waybar
