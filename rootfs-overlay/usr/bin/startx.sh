#!/bin/bash
. /etc/CONFIG.sh
mkdir /var/log
modprobe evdev
Xorg -config /etc/X11/X.conf -logfile /tmp/Xlog &
su - $USER -c "DISPLAY=:0 matchbox-window-manager &"
su - $USER -c "DISPLAY=:0 xterm &"

