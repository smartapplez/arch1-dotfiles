#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"

#Can be checked by echo $WAYLAND_DISPLAY command
export WAYLAND_DISPLAY="wayland-1"

# Can be checked by echo $DISPLAY command
export DISPLAY=":0"

# Optional logging
echo "$(date): Lock and suspend triggered" >>"$HOME/lid-suspend.log"

# Run hyprlock
echo "Executing hyprlock" >>"$HOME/lid-suspend.log"
pidof hyprlock || hyprlock &
sleep 1

# Delay then suspend
echo "Preparing to sleep" >>"$HOME/lid-suspend.log"
systemctl suspend
