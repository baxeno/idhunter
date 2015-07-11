## USB VID/PID Source Code Hunter
Create a better out-of-the-box USB experience on Linux.
Most Linux distributions use a file called usb.ids[1] to decode USB Vendor IDs (VIDs) and Product IDs (PIDs) when displaying information about the device for the user.
The information is updated using a web editor[2] and a new snapshot is generated every few weeks.
This project attempts to find information about all the VIDs/PIDs that already has Linux kernel[4] support, but user friendly name has not yet been added to usb.ids file. This involves finding C defines and extracting code comment or commit log information.


## Install
### Debian / Ubuntu
Here usb.ids is distributed with a package called usbutils[3]. This package update interval is quite long so it's possible to download and install new snapshots with an included script called update-usbids.

    sudo update-usbids

### Fedora / Red Hat
Here usb.ids is distributed as a separate package called hwdata.noarch, and this package is updated very frequently. They what a tighter management of installed files and therefore do not include the update-usbids script. Just update the system with DNF or YUM.


## Linux USB Debugging
A typical USB device debugging scenario on Linux include sharing of verbose output of the lsusb command. This output will also include user friendly VID/PID names for easy device identification.

    lsusb -v


## References
[1] https://usb-ids.gowdy.us/usb.ids

[2] https://usb-ids.gowdy.us/index.html

[3] http://www.linux-usb.org/

[4] https://github.com/torvalds/linux
