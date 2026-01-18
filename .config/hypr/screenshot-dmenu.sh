#!/bin/sh
#
# Rofi dmenu Screenshot Tool for Wayland Using Zenity, Grim and Slurp
# This now includes wayfreeze into the screenshot tool

DEFAULT_SAVE_DIR=/home/Arieldynamic/Pictures/Screenshots
DEFAULT_FILENAME=Screenshot-From-$(date +%Y-%m-%d-%H-%M-%S).png
DEFAULT_FILE_PATH=$DEFAULT_SAVE_DIR/$DEFAULT_FILENAME

TMP_DIR=/tmp
TMP_FILE_PATH=$TMP_DIR/$DEFAULT_FILENAME

CHOICE=$(rofi -dmenu -p "󰹑 " \
  -theme ~/.config/hypr/dmenu-screenshot-rofi-style.rasi \
  <<<$'1 whole screen --> save to file\n2 part of screen --> save to file\n3 whole screen --> clipboard\n4 part of screen --> clipboard\n5 part of screen --> edit --> clipboard')

# echo $CHOICE

case $CHOICE in
"1 whole screen --> save to file")
  sleep 0.5 && grim "${DEFAULT_FILE_PATH}"
  ;;
"2 part of screen --> save to file")
  # sleep 0.5 && grim -g "$(slurp)" "$DEFAULT_SAVE_DIR/$DEFAULT_FILENAME"
  sleep 0.5 && wayfreeze --after-freeze-cmd "slurp | grim -g - "${DEFAULT_FILE_PATH}"; killall wayfreeze"
  ;;
"3 whole screen --> clipboard")
  sleep 0.5 && grim - | wl-copy
  exit
  ;;
"4 part of screen --> clipboard")
  sleep 0.5 && wayfreeze --after-freeze-cmd 'grim -g "$(slurp)" - | wl-copy; killall wayfreeze'
  exit
  ;;
"5 part of screen --> edit --> clipboard")
  # grim -g "$(slurp)" - | swappy -f - -o - | wl-copy
  sleep 0.5 && wayfreeze --after-freeze-cmd "slurp | grim -g - "${TMP_FILE_PATH}"; killall wayfreeze"
  swappy -f $TMP_FILE_PATH -o - | wl-copy
  exit
  ;;
"")
  exit
  ;;
esac

FILE=$(zenity --file-selection --title="Select a File" --filename=$DEFAULT_FILENAME --save 2>/dev/null)

# echo $FILE

case $? in
0)
  mv "$DEFAULT_SAVE_DIR/$DEFAULT_FILENAME" $FILE
  ;;
1) ;;
-1)
  echo "An unexpected error has occurred."
  ;;
esac

exit
