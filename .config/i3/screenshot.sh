#!/bin/sh
#
# GUI Screenshot Tool for Wayland Using Zenity, Grim and Slurp
# Modified by smartapplez to use with scrot (X.org)
# Last Modification: Thu Nov 14 18:05:37 PM WET 2024
#

TMP_DIR=/home/Arieldynamic/Pictures/Screenshots/
DEFAULT_FILENAME=Screenshot-From-$(date +%Y-%m-%d-%H-%M-%S).png

CHOICE=$(zenity --width=450 --height=400 --title "Screenshot" \
  --text "Take a screenshot of" \
  --list --radiolist \
  --column "Pick" \
  --column "Choice" \
  True "whole screen --> save to file" \
  False "part of screen --> save to file" \
  False "whole screen --> clipboard" \
  False "part of screen --> clipboard")

# echo $CHOICE

case $CHOICE in
"whole screen --> save to file")
  sleep 0.5 && scrot -F "$TMP_DIR/$DEFAULT_FILENAME"
  ;;
"part of screen --> save to file")
  sleep 0.5 && scrot -s -f -F "$TMP_DIR/$DEFAULT_FILENAME"
  ;;
"whole screen --> clipboard")
  scrot -F "-" | xclip -selection clipboard -t image/png
  exit
  ;;
"part of screen --> clipboard")
  scrot -s -f -F "-" | xclip -selection clipboard -t image/png
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
  mv "$TMP_DIR/$DEFAULT_FILENAME" $FILE
  ;;
1) ;;
-1)
  echo "An unexpected error has occurred."
  ;;
esac

exit
