#!/bin/bash
# Formats an SD card for use. The device should be specified as 
#  CARD in CONFIG.sh. Note that all data will be erased, and no 
#  warning will be given.
# This script will almost certainly have to be run as root or, at least,
#  a user with permissions to operation on block devices.

. ./CONFIG.sh

umount ${CARD}1
umount ${CARD}2

fdisk $CARD << EOF
o
n
p
1

+256m
t
c
n
p
2



w
q
EOF

sync

mkfs.vfat ${CARD}1
mkfs.ext4 -F ${CARD}2

