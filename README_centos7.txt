 Use these instructions for building on a Linux PC, specifically
 CentOS 7. Tested with Linux Kernel 3.10.0-1062.18.1.el7.x86_64.

 Need libusb and libftdi installed. On my CentOS 7 system, yum worked. The minimum version is libusb-1.0. If yum provides at least this version, use:

 sudo yum install libusb


 If not, must install libusb manually:

 Can download from: http://libusb.info/ or
   git clone https://github.com/libusb/libusb

 I needed libudev-devel to build libusb, so before building libusb, do:

 sudo yum install libudev-devel

 cd into libusb top level folder (whatever its full name is) and then:

 ./configure && make

 If that seems to build correctly, install with:

 sudo make install


 Next, get libftdi. On my system, yum worked with:

 sudo yum install libftdi-devel

 If that does not also install libftdi, then install it as well:

 sudo yum install libftdi


 If must install libftdi manual, use:

 mkdir libftdi
 cd libftdi
 git clone git://developer.intra2net.com/libftdi

 Can also download from: https://www.intra2net.com/en/developer/libftdi/download.php

 cd into the libftdi folder (may have version numbers in the folder name).

 Open README.build and follow the instructions. Namely, install the
 build tools, but they should have been installed to even build
 libusb. Can ignore installation of sudo libconfuse-dev swig
 python-dev & libboost-all-dev. They are optional for libftdi and
 not needed here.

 Then, as README.build says:

 mkdir build
 cd build
 cmake  -DCMAKE_INSTALL_PREFIX="/usr" ../
 make
 sudo make install


 Before can use the FTDI device, may need to create a udev entry. See
 the udev instructions at:
 http://eblot.github.io/pyftdi/installation.html. For my system,
 instead of setting the group to "plugdev", I set it to
 "dialup", which already existed as a group on this system. Also, I
 set the filename to 99-libftdi.rules so it was lower priority than
 existing udev rules for Xilinx and Digilent devices with the same
 vendor ID of 0x0403. Then unplug and plug the FTDI device in to have
 udev use this new rule.


 To build xvcd for CentOS7, simply do:

 make centos7

 The executables are in the src/ folder. xvcdbb uses bit-bang mode,
 which is likely slightly slower but can be used on FTDI GPIO. xvcdmp
 uses a MPSSE within the FTDI device.

 NOTE: Once have the executables built and running, may need to use
 the "-f" option to lower the frequency that Vivado picks.
