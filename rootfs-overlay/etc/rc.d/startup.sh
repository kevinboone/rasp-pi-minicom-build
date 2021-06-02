#!/bin/bash
mount /proc
mount /sys
mount /tmp
mkdir /dev/pts
mount /dev/pts

mkdir /tmp/var
mkdir /tmp/run
mkdir /var/lib
mkdir -p /var/log
touch /tmp/resolv.conf

/bin/load-modules.sh MODULES
chown root:dialout /dev/ttyACM0
chown root:dialout /dev/ttyUSB0
chmod 660 /dev/ttyACM0
chmod 660 /dev/ttyUSB0

syslogd
dmesg --console-level 2
hostname --file /etc/hostname
setupcon
#chvt 2

