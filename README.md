# rasp-pi-minicom-build

Kevin Boone, May 2021

This is a collection of shell and Perl scripts that builds a minimal
Raspberry Pi Zero image, which boots straight to the Minicom terminal
emulator. The purpose is to use the Pi Zero as the terminal for another
serial device, using a USB-to-serial adapter like the CH341. The Pi
Zero is potentially a good choice as a terminal for, say, a CP/M system
since it allows a modern HDMI monitor and USB keyboard to be
connected. There are a number of minimal Rasberry Pi distributions that
will work on the Pi Zero, but my goal here is to create an installation
that boots to Minicom in about five seconds, and is completely read-only,
so there's no shutdown protocol -- just power it off.

This build is for the (cheap) version of the Pi Zero that has no network
or bluetooth support. These things aren't needed in a terminal emulator,
and only add to the complexity.

You'll need as a minimum to modify CONFIG.sh to set the serial port 
device and baud rate. It may be necessary to add additional kernel 
modules, if those included do not work with the USB-to-serial you have.
It should also be possible to configure this build to use the real
built-in UART, rather than USB-to serial.

The Linux build boots so that Minicom is running on the virtual
terminal /dev/tty1, while tty2 and tty3 have an ordinary Linux
shell prompt. You can switch using ctrl+alt+FXX in the usual way.
I've arranged it like this so that, if Minicom doesn't start, or 
doesn't work, it's at least possible to get a shell session to 
troubleshoot.


