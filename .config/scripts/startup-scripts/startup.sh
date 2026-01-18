#!/bin/bash

PROFILE=$(rofi -dmenu -p " " \
  -theme ~/.config/scripts/startup-scripts/startup-dmenu-style.rasi \
  <<<$'1 Work Obsidian\n2 Work Xournal\n3 Gaming')

# Load browser env configs
if [ -r "$HOME/.config/startup-config/chrome-env.env" ]; then
  # Avoid leaking secrets if xtrace is on
  case $- in *x*) set +x ;; esac
  set -a # auto-export all vars defined while set
  . "$HOME/.config/startup-config/chrome-env.env"
  set +a
fi

# Launch apps based on selected profile
case "$PROFILE" in
"1 Work Obsidian")
  hyprctl dispatch exec [workspace 1 silent] discord
  hyprctl dispatch exec [workspace 1 silent] spotify
  hyprctl dispatch exec [workspace 2 silent] "google-chrome-stable --profile-directory="Default" file:///home/Arieldynamic/.dotfiles/.config/scripts/startup-scripts/startup-chrome-supplements/default-tab.html"
  hyprctl dispatch exec [workspace 3 silent] "ghostty --title="Terminal" -e bash"
  hyprctl dispatch exec [workspace special:magic silent] "google-chrome-stable --profile-directory="${WORK_ACCOUNT_NAME}" file:///home/Arieldynamic/.dotfiles/.config/scripts/startup-scripts/startup-chrome-supplements/work-tab.html"
  hyprctl dispatch exec [workspace 4 silent] obsidian
  ;;
"2 Work Xournal")
  hyprctl dispatch exec [workspace 1 silent] discord
  hyprctl dispatch exec [workspace 1 silent] spotify
  hyprctl dispatch exec [workspace 2 silent] "google-chrome-stable --profile-directory="Default" file:///home/Arieldynamic/.dotfiles/.config/scripts/startup-scripts/startup-chrome-supplements/default-tab.html"
  hyprctl dispatch exec [workspace 3 silent] "ghostty --title="Terminal" -e bash"
  hyprctl dispatch exec [workspace special:magic silent] "google-chrome-stable --profile-directory="${WORK_ACCOUNT_NAME}" file:///home/Arieldynamic/.dotfiles/.config/scripts/startup-scripts/startup-chrome-supplements/work-tab.html"
  hyprctl dispatch exec [workspace 4 silent] xournalpp
  ;;
"3 Gaming")
  hyprctl dispatch exec [workspace 1 silent] discord
  hyprctl dispatch exec [workspace 1 silent] spotify
  hyprctl dispatch exec [workspace 2 silent] "google-chrome-stable --profile-directory="Default" file:///home/Arieldynamic/.dotfiles/.config/scripts/startup-scripts/startup-chrome-supplements/default-tab.html"
  hyprctl dispatch exec [workspace 3 silent] "ghostty --title="Terminal" -e bash"
  hyprctl dispatch exec [workspace 4 silent] steam
  ;;
*) ;;
esac
