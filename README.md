# Project objective
Create a better out-of-the-box USB experience on Linux.
Most Linux distributions use a file called usb.ids[1] to decode USB VIDs and PIDs
when displaying information about the device for the user.
The information is updated using a web editor[2] and a new snapshot is generated every few weeks.

## Install
Normally usb.ids is distributed with a package called usbutils[3].
This package update interval is quite long so it's possible to download and
install new snapshots with an included script called update-usbids.

    sudo update-usbids


## References
[1] https://usb-ids.gowdy.us/usb.ids
[2] https://usb-ids.gowdy.us/index.html
[3] http://www.linux-usb.org/
