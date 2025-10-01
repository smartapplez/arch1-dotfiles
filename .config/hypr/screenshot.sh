#!/bin/sh
#
# GUI Screenshot Tool for Wayland Using Zenity, Grim and Slurp
# Last Modification: Thu Nov 14 18:05:37 PM WET 2024
#

TMP_DIR=/home/Arieldynamic/Pictures/Screenshots/
DEFAULT_FILENAME=Screenshot-From-$(date +%Y-%m-%d-%H-%M-%S).png

CHOICE=$(zenity --width=450 --height=400 --title "Screenshot" \
  --text "Take a screenshot of" \
  --list --radiolist \
  --column "Pick" \
  --column "Choice" \
  True "1 whole screen --> save to file" \
  False "2 part of screen --> save to file" \
  False "3 whole screen --> clipboard" \
  False "4 part of screen --> clipboard" \
  False "5 part of screen --> edit --> clipboard")
# echo $CHOICE

case $CHOICE in
"1 whole screen --> save to file")
  grim "$TMP_DIR/$DEFAULT_FILENAME"
  ;;
"2 part of screen --> save to file")
  slurp | grim -g - "$TMP_DIR/$DEFAULT_FILENAME"
  ;;
"3 whole screen --> clipboard")
  grim -g - - | wl-copy
  exit
  ;;
"4 part of screen --> clipboard")
  slurp | grim -g - - | wl-copy
  exit
  ;;
"5 part of screen --> edit --> clipboard")
  grim -g "$(slurp)" - | swappy -f - -o - | wl-copy
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
