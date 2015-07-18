## USB VID/PID Source Code Hunter
Create a better out-of-the-box USB experience on Linux.
Most Linux distributions use a file called usb.ids[1] to decode USB Vendor IDs (VIDs) and Product IDs (PIDs) when displaying information about the device for the user.
The information is updated using a web editor[2] and a new snapshot is generated every few weeks.
This project attempts to find information about all the VIDs/PIDs that already has Linux kernel[4] support, but user friendly name has not yet been added to usb.ids file. This involves finding C defines and extracting code comment or commit log information.


## Install/Update
### Debian / Ubuntu
Here usb.ids is distributed with a package called usbutils[3]. This package update interval is quite long so it's possible to download and install new snapshots with an included script called update-usbids.

    sudo update-usbids

### Fedora / Red Hat
Here usb.ids is distributed as a separate package called hwdata.noarch, and this package is updated very frequently. They what a tighter management of installed files and therefore do not include the update-usbids script. Just update the system with DNF or YUM.


## Linux USB Debugging
A typical USB device debugging scenario on Linux include sharing of verbose output of the lsusb command. This output will also include user friendly VID/PID names for easy device identification.

    lsusb -v

## Statistics
ID hunter is still under heavy development so take the total number of IDs with a grain of salt.

_Last update: 2015.07.18_

Vendor ID status:

    Progress: 0.00% (0/1366)

Product ID status:

    Progress: 0.00% (0/2357)

Vendor and/or Product ID status:

    Progress: 0.03% (2/6303)



VIDs found in 302 files; Top 10 files:

    194 ../linux/drivers/hid/hid-ids.h
     61 ../linux/drivers/media/dvb-core/dvb-usb-ids.h
     60 ../linux/drivers/gpu/drm/amd/include/asic_reg/dce/dce_11_0_d.h
     51 ../linux/drivers/usb/serial/ftdi_sio_ids.h
     48 ../linux/drivers/gpu/drm/amd/include/asic_reg/dce/dce_8_0_d.h
     48 ../linux/drivers/gpu/drm/amd/include/asic_reg/dce/dce_10_0_d.h
     43 ../linux/drivers/usb/serial/option.c
     40 ../linux/drivers/hwmon/jc42.c
     35 ../linux/drivers/usb/serial/pl2303.h
     32 ../linux/include/video/exynos7_decon.h


PIDs found in 178 files; Top 10 files:

    774 ../linux/drivers/usb/serial/ftdi_sio_ids.h
    630 ../linux/drivers/hid/hid-ids.h
    315 ../linux/drivers/media/dvb-core/dvb-usb-ids.h
     53 ../linux/drivers/usb/serial/pl2303.h
     36 ../linux/drivers/message/fusion/lsi/mpi_ioc.h
     36 ../linux/drivers/input/mouse/bcm5974.c
     34 ../linux/drivers/usb/atm/ueagle-atm.c
     33 ../linux/drivers/usb/misc/ldusb.c
     26 ../linux/include/linux/ssb/ssb_regs.h
     17 ../linux/drivers/usb/serial/ti_usb_3410_5052.h


VPIDs found in 377 files; Top 10 files:

    809 ../linux/drivers/usb/serial/ftdi_sio.c
    493 ../linux/drivers/hid/hid-core.c
    453 ../linux/drivers/usb/serial/ipaq.c
    330 ../linux/drivers/net/wireless/rt2x00/rt2800usb.c
    234 ../linux/drivers/usb/serial/option.c
    143 ../linux/drivers/usb/serial/cp210x.c
    116 ../linux/drivers/bluetooth/btusb.c
     96 ../linux/drivers/bluetooth/ath3k.c
     90 ../linux/drivers/media/usb/em28xx/em28xx-cards.c
     82 ../linux/drivers/media/usb/dvb-usb/dib0700_devices.c


## References
[1] https://usb-ids.gowdy.us/usb.ids

[2] https://usb-ids.gowdy.us/index.html

[3] http://www.linux-usb.org/

[4] https://github.com/torvalds/linux

