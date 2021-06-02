#!/bin/bash

# Copies the boot and rootfs filesystems to a prepared SD card. 
# Pre-requisites: prepare-card.sh. This script will amost certainly have
#  to be run as root

. ./CONFIG.sh

mkdir -p $MNT_ROOTFS
mkdir -p $MNT_BOOT

echo "Mounting work areas"

mount ${CARD}1 $MNT_BOOT
mount ${CARD}2 $MNT_ROOTFS

echo "Cleaning card"

rm -rf $MNT_BOOT/*
rm -rf $MNT_ROOTFS/*

echo "Copying boot partition"

cp -aux ${BOOT}/* $MNT_BOOT/
cp -aux bootfiles/* $MNT_BOOT/

echo "Copying root filesystem"

cp -aux ${ROOTFS}/* $MNT_ROOTFS/
chown -R root:root $MNT_ROOTFS/*

echo "Setting permissions"

chown -R 1000:100 $MNT_ROOTFS/home/$USER
chmod ug+s /$MNT_ROOTFS/usr/bin/sudo
chmod ug+s /$MNT_ROOTFS/usr/bin/minicom

echo "Syncing card"

sync

umount $MNT_ROOTFS
umount $MNT_BOOT

echo "Copy to card done"


