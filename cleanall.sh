#!/bin/bash

# Clean up after building rasp-pi-min-ro-build. There should be no need
#  to run this script as root

. ./CONFIG.sh

rm -rf $TMP/firmware-master
rm -rf $TMP/firmware.zip
rm -rf $TMP/rootfs
rm -rf $TMP/boot



