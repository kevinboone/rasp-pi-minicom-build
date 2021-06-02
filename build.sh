#!/bin/bash

. ./CONFIG.sh

ESSENTIAL_PKGS="bash ncurses-base libtinfo6 sysvinit-core sudo coreutils strace libpam-runtime util-linux login console-data kbd hostname file kmod procps grep findutils psmisc sed console-tools console-data console-setup console-setup-linux gzip ncurses-bin"

# ========= Work out what to install ============

PKGS="$ESSENTIAL_PKGS $OPTIONAL_PKGS"

if [[ $INSTALL_NET_WIFI == 1 ]]; then
  INSTALL_NET_UTILS=1 
fi

if [[ $INSTALL_NET_UTILS == 1 ]]; then
  PKGS="$PKGS net-tools iputils-ping ifupdown dhcpcd dhcpcd5 curl dnsutils"
fi

if [[ $INSTALL_NET_WIFI == 1 ]]; then
  PKGS="$PKGS iw wpasupplicant"
fi

if [[ $INSTALL_ALSA == 1 ]]; then
  PKGS="$PKGS alsa-utils libasound2"
fi

if [[ $INSTALL_X == 1 ]]; then
  PKGS="$PKGS xorg xserver-xorg-input-evdev twm matchbox-window-manager"
fi

PKGS="$PKGS $OPTIONAL_PKGS"

MODULES=""
MODULES="$MODULES $OPTIONAL_MODULES"

# ============ Start build here =================

mkdir -p $BOOT 
mkdir -p $ROOTFS 

echo "Cleaning work area"

rm -rf $ROOTFS/*
rm -rf $BOOT/*

# ============ Download boot firmware =================

if [ -f "$TMP/firmware.zip" ]; then
  echo "Using cached firmware" ;
else
  echo "Downloading firmware"
  curl -o $TMP/firmware.zip \
     https://codeload.github.com/raspberrypi/firmware/zip/refs/heads/master
fi

# ============ Unpack firmware =================

echo "Unpacking firmware" ;
(cd $TMP; unzip -q $TMP/firmware.zip)

cp -aux $TMP/firmware-master/boot/* $BOOT/

mkdir -p $ROOTFS/lib/modules
cp -aux $TMP/firmware-master/modules/* $ROOTFS/lib/modules/

rm -rf $TMP/firmware-master/

# ===== Export env vars used by get_deb.pl =======

export ROOTFS 
export BOOT 
export TMP
export RASPBIAN_RELEASE

# ============ Download packages =================

echo "Downloading packages" ;
./get_deb.pl $PKGS

# ======== Add local config and binaries  ========

echo "Adding local configuration"

# Remove anything from /var and /run that was 
#  installed by the package installer. /var will be on a memory
#  filesystem in this implementation. We have to remove
#  the existing contents so we can replace it with a
#  symlink.

rm -rf $ROOTFS/var
rm -rf $ROOTFS/run
rm -rf $ROOTFS/tmp
mkdir $ROOTFS/tmp
cp -ax contrib-bin/* $ROOTFS
cp -ax rootfs-overlay/* $ROOTFS
cp CONFIG.sh $ROOTFS/etc
# Make bash available as /bin/sh
(cd $ROOTFS; ln -sfr bin/bash bin/sh)
(cd $ROOTFS; ln -sfr usr/bin/vim.basic bin/vi)

if [[ $INSTALL_NET_WIFI == 1 ]]; then
  (cd $ROOTFS/etc/; ln -sfr init.d/dhcpcd rc1.d/S25dhcpcd;  ln -sfr init.d/wpa_supplicant rc1.d/S10wpasupplicant; ln -sfr init.d/wifi rc1.d/S20wifi; ln -sfr init.d/dhcpcd rc1.d/S25dhcpcd; ln -sfr init.d/onetime_datetime rc1.d/S30onetime_datetime; ln -sfr init.d/sshd rc1.d/S40sshd; ) 
fi

if [[ $INSTALL_ALSA == 1 ]]; then
  (cd $ROOTFS/etc/; ln -sfr init.d/audio rc1.d/S80audio) 
fi

if [[ $ENABLE_STORAGE == 1 ]]; then
  (cd $ROOTFS/etc/; ln -sfr init.d/storage rc1.d/S05storage) 
fi

sed --in-place -e "s/MODULES/$MODULES/" $ROOTFS/etc/rc.d/startup.sh

# ======== Make essential directories =============

mkdir -p $ROOTFS/dev
mkdir -p $ROOTFS/sys
mkdir -p $ROOTFS/proc

# =============== Configure getty ==================

if [[ $AUTOLOGIN == 1 ]]; then
  sed --in-place -e "s/XXX/-a $USER/" $ROOTFS/etc/inittab
else
  sed --in-place -e "s/XXX//" $ROOTFS/etc/inittab
fi


# =============== Create user ======================

echo "Creating user"

echo "$USER:$USERPW:1000:100:User:/home/$USER:/bin/bash" >> $ROOTFS/etc/passwd
sed --in-place -e "s/audio:x:29:/audio:x:29:$USER/" $ROOTFS/etc/group
sed --in-place -e "s/dialout:x:20:/dialout:x:20:$USER/" $ROOTFS/etc/group

echo "$USER ALL=(ALL) ALL" >> $ROOTFS/etc/sudoers

mkdir -p $ROOTFS/home/$USER
cp misc-config/bashrc $ROOTFS/home/$USER/.bashrc
cp misc-config/bash_profile $ROOTFS/home/$USER/.bash_profile
(cd $ROOTFS/home/$USER; ln -sfr /mnt mnt)

#(cd $ROOTFS; ln -sfr bin/dash bin/init)

# ================= Configure minicom ================

sed --in-place -e "s/BAUD/$MC_BAUD/" $ROOTFS/bin/mini
sed --in-place -e "s/DEVICE/$MC_DEVICE/" $ROOTFS/bin/mini

# =============== Set hostname ======================

echo $HOSTNAME > $ROOTFS/etc/hostname
sed --in-place -e "s/XXX/$HOSTNAME/" $ROOTFS/etc/hosts

echo "Done. Now install using sudo ./copy-to-card.sh"

