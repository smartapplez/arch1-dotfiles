#!/bin/sh

#Requirement: Must have hypridle running in order for loginctl to work!
loginctl lock-session
sleep 0.3
systemctl suspend
