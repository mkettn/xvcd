# xvcd

This is a daemon that listens to `xilinx_xvc` (xilinx virtual cable)
traffic and operates JTAG over an FTDI in either bitbang mode or in
MPSSE mode.

The bitbang mode is the original code with slight modifications with
changes to the arguments of the interface functions. After building,
the executeable that uses bitbang mode is called `xvcdbb`. From the
original README: "This version is hardcoded to use an FTDI cable with
an FT2232C chip. It does not use MPSSE but rather bitbang mode. It
uses ftdi_write_async which might not be available on your
platform. You can use the (much slower) non-async version instead."

For MPSSE mode, which can be faster than bitbang mode, the output
executable is called `xvcdmp`. As a comparison, for a Xilinx Zync
XCXC7Z020 and using Vivado 2017.4, programming the Zynq FPGA logic
directly can take about 35 seconds through bitbang_mode and about
27 seconds with MPSSE mode. Have tested this with both a FT2232H and a
FT4232H. Both MPSSE ports of either of these devices can be used by
selecting it through the -i option.

Additionally, if desire to use this with a **BCP board**, which has a
built-in FT4232H, use the executable called `xvcdbcp`. This uses MPSSE
mode but sets up the FTDI I/O in a way specific for use on the
BCP. Still use `xvcdmp` if using this with a generic FTDI cable or
development board.

If you do not desire to use this with a BCP board, it may be best to
revert to
[v1.0](https://github.com/sgoadhouse/xvcd/releases/tag/v1.0). Only the
new `xvcdbcp` executable has been tested. `xvcdbb` and `xvcdmp` are
expected to function as before but the code changes made to get the
BCP specific code inserted could have an unintended consequence. There
was just not time to fully test those older executables.

If having trouble connecting to the JTAG target, try forcing the
frequency lower with the -f option. However, this is only used by the
MPSSE mode version.

If use the -i option to select a different interface on a multiple
interface device like the FT2232H and FT4232H, keep in mind that for
MPSSE mode, only interface 0 & 1 have MPSSE engines and you will get
an error if try to select interface 2 or 3. However, for bitbang mode,
can use all 4 interfaces.

One key to speeding up both the bitbang and MPSSE modes is setting the
USB latency timer setting to a lower value in io_init(). However, this
may have a detrimental impact on the host system. If the host is a
Raspberry Pi, which this was tested on, it seems fine. If the host is
a PC with lots of USB devices, you may need to increase the latency
timer value. This can be done with the LATENCY_TIMER make variable
(ie. make LATENCY_TIMER=16)

Also, the base server code was merged with
https://github.com/Xilinx/XilinxVirtualCable/blob/master/XAPP1251/src/xvcServer.c
so that Xilinx Virtual Cable is fully supported through both ISE and
Vivado.

## Configuration

To try to determine the IP address where the executable is running in
order to tell the user, the ethernet interface must be selected by
defining USE_GETIFADDRS to the interface name. This can be done
through a make variable (ie. make USE_GETIFADDRS=wlan0). If do not
define it, then the code is skipped.


## Installation

Need both libusb and libftdi1 libraries. See individual README_xxx.txt
files with extensive comments on how to install/build libusb and
libftdi for this build.

## Specific use with BCP board

The **BCP** board has both a FTDI `FT4232H` interface and a JTAG
header. So when the XVC server is asked to connect over JTAG, the
server first checks that a programmer is not already plugged in. If
one is plugged in, the server refuses to change the JTAG I/O settings
so as to not conflict with the external JTAG programmer. This will
result in the user receiving an error when trying to open the XVC
server connection. **If you really intended to use the XVC connection,
you must first remove any external JTAG programmers from the JTAG
header.**

Conversely, if you want to use an external JTAG programmer, you must
have the executeble `xvcdbcp` running. By default, the FT4232H grabs
the JTAG I/O, unfortunately. By running `xvcdbcp`, the FT4232 is told
to release the JTAG I/O at start-up. This allows an external
programmer to be used. The other option is to simply unplug the USB
cable from the FT4232 port. However, this port also handles the IPMC
and ELM serial consoles, which will get closed down if the USB cable
is removed.

So, if you want the IPMC or ELM consoles, the best practice is to
always have `xvcdbcp` running and then the user can chose whether to
use an external programmer or the XVC server from the Hardware
Manager.

If switching between external programmer and XVC server, `Close
Server` in Hardware Manager first. This will disconnect from the XVC
server which triggers the server to switch I/O back into IDLE mode
where the JTAG signals are released. `Close Target` does not
disconnect from the XVC server and so control of the JTAG pins does
not change in that case.


*Have fun!*
