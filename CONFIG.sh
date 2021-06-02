# This is the main configuration files for rasp-pi-min-ro-build. It
#   controls the build process, and is also copied into the image where
#   it will also be used to provide settings at run-time.

# RASPBIAN_RELEASE identifies the Raspbian repository that will be used
#  to obtain the binaries used by this build process. Possibilities are
#  jessie, buster, bullseye, etc.
RASPBIAN_RELEASE=buster

# Where to put the root FS and the boot directory, as they are generated
#  by the build process. These directories will be created. They need
#  to be in a place where they can be written by an unprivileged used.
#  These directories are left after the build, so that copy-to-card.sh
#  can use them to populate the SD card. To clean up completely, use
#  cleanall.sh
BOOT=/tmp/boot
ROOTFS=/tmp/rootfs

# Location for general temporary files. Any that are not deleted after
#  the build and installation can be removed using cleanall.sh. Note, 
#  however, that subsequent builds will be much faster if these files
#  are left in place.
TMP=/tmp

# The device for the SD card that will be populated by the build. Note
#  that prepare-card.sh completely obliterates this device, and without
#  warning, so you need to be really, really sure this is the right
#  disk device. Usually you can find out by running dmesg before and
#  after plugging the card reader in.
CARD=/dev/sdb

# The locations where the partitions of the SD card will be mounted, whilst
#  files are being copied onto the card. Any empty directory will do.
#  The directories will be created if necessary.
MNT_ROOTFS=/mnt/rootfs
MNT_BOOT=/mnt/boot

# The hostname of the system to be built. This appears at the command
#  prompt, but isn't of much greater significance in this kind of installation.
HOSTNAME=console

# The name and password of the user that will be created. An easy-ish way
#  to get the encrypted password is to create a user with the required
#  name on a desktop Linux system, and copy the generated password from
#  /etc/shadow. The example is the encrypted version of the password
#  'test'
USER=test
USERPW='$6$8ETU8uasmz8lSajT$kTdd/3VjOFqeK5VUpMJBv1Fk7yZHxsPqgttcRMiubsfA4C5ZCv1BEZVllvuWEV/iPzcSfv/OTgy7Gw/jJVUHw1'

# Set AUTOLOGIN=1 to generate an installation that logs the user int
#  automatically at boot. You'll still need to use the password for remote
#  access (if enabled).
AUTOLOGIN=1

# Wifi settings. This build does not provide any way to select Wifi 
#  access point or credentials at runtime -- you must choose in
#  advance. This is a significant limitation to this kind of installation.
SSID=
PSK=

# A list of optional packages to install (the essential packages are
#   defined in build.sh, and will depend on what optional components
#   are selected).
OPTIONAL_PKGS="vim minicom"

# Specify additional modules to load. For example, cdc-acm is the driver
#  for USB-serial devices. This list should be separated by spaces.
OPTIONAL_MODULES="cdc-acm ch341"

# Decide whether to install network utilities like ifconfig. This is
#  implied by INSTALL_NET_WIFI. If INSTALL_NET_UTILS=0, then the
#  startup will still try to configure the built-in ethernet adapter
#  using DHCP, unless it is disable in firmware.
INSTALL_NET_UTILS=0

# Install Wifi support. This will include the start-up scripts, and also
#  utilties like iwconfig
INSTALL_NET_WIFI=0

# Install ALSA audio utilties and enable the audio set-up scripts.
INSTALL_ALSA=0

# Mount a single USB memory stick on /mnt. You may well need to modify
#  the mount parameters in overlay-rootfs/etc/init.d/storage
ENABLE_STORAGE=0

# Enable skeleton X support. This will install a _lot_ of software, and 
#  it's still nowhere near enough for a practical X destkop. You'll need
#  to hack on rootfs-overlay/etc/X11/X.conf to configure input devices.
#  Start an X session by running /usr/bin/startx.sh as root
INSTALL_X=0

# Default Minicom configuration. We need to specify the device and the
#  baud rate. They can be changed at runtime, but the initial values have
#  to make sense, else Minicom won't even start, so we won't be able
#  to change them. To use the built-in, GPIO UART, I think you should
#  be able to use ttyAMA0 here, but I haven't actually tested it, and
#  I'm not sure what additional kernel modules are required.
MC_DEVICE=ttyUSB0
MC_BAUD=230400


