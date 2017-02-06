---
title: Gentoo Offline Package Install
tags: gentoo, linux, devops
---

I had a desktop with a Gentoo Linux installation that was way out of date. Normally, updating it would be a simple `emerge --sync && emerge -uDNav @world`, but there was an issue: the desktop was physically too far away from the router/switch for any of my ethernet cables. Have no fear, for I have a Linux-compatible [USB WiFi modem](http://amzn.to/2khl6ew)!


### Loading the Firmware
After some research online using my Internet-enabled laptop, I compiled the necessary kernel modules on the offline machine for anything that was prefixed with [`ATH9K`](https://wireless.wiki.kernel.org/en/users/drivers/ath9k). I rebooted, and alas:

```bash
$ dmesg | grep ath9k_htc
usb 5-2: ath9k_htc: Firmware htc_9271.fw requested
usbcore: registered new interface driver ath9k_htc
usb 5-2: firmware: direct-loading firmware htc_9271.fw
usb 5-2: ath9k_htc: Firmware - htc_9271.fw download failed
usb 5-2: ath9k_htc: USB layer deinitialized
$ find /lib64/firmware -name htc_9271.fw
# no results
```

Womp. No firmware. I searched for some firmware online, and transfered via USB stick a recent [`linux-firmware_1.157.8.tar.gz`](http://archive.ubuntu.com/ubuntu/pool/main/l/linux-firmware/linux-firmware_1.157.8.tar.gz). I confirmed the [signature](http://archive.ubuntu.com/ubuntu/pool/main/l/linux-firmware/linux-firmware_1.157.8.dsc) and untarred into the firmware directory:

```bash
$ sudo tar -xvzf linux-firmware_1.157.8.tar.gz --strip=1 -C /lib64/firmware/
```

After a quick reboot, I now have working firmware!

```bash
$ dmesg | grep ath9
usb 5-2: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw requested
usbcore: registered new interface driver ath9k_htc
usb 5-2: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1.4.0.fw, size: 51008
ath9k_htc 5-2:1.0: ath9k_htc: HTC initialized with 33 credits
ath9k_htc 5-2:1.0: ath9k_htc: FW Version: 1.4
ath9k_htc 5-2:1.0: FW RMW support: On
ath9k_htc 5-2:1.0 wlp7s0u2: renamed from wlan0
```

### Installing Network Packages

```bash
$ nmtui
zsh: command not found: nmtui
```

Unfortunately, the installation didn't have networking packages such as `NetworkManager` or `wpa_supplicant` to connect to WiFi. `wpa_supplicant` is really all I need, but if I'm planning to go through the hassle of installing all these packages, then I might as well bring in `NetworkManager` to make my life easier, as it also contains `wpa_supplicant` as a dependency. I'll be transferring dependencies over [sneakernet](https://en.wikipedia.org/wiki/Sneakernet).

On the offline machine, I created the list of things required to install the package I wanted:

```bash
$ sudo mount /dev/<DEVICE> /mnt/usb
# -p for pretend, -f for fetchonly
$ emerge -pf networkmanager > /mnt/usb/distfiles_list.txt
$ sudo umount /mnt/usb
```

On my Internet-enabled laptop, I downloaded all the necessary files, including the dependencies:

```bash
$ sudo mount /dev/<DEVICE> /mnt/usb
$ mkdir /mnt/usb/distfiles
$ cat /mnt/usb/distfiles_list.txt | grep '^http' | cut -d' ' -f1 | xargs wget -P /mnt/usb/distfiles/
# these should be the same count, otherwise figure out what didn't download
$ ls /mnt/usb/distfiles | wc -l
$ cat /mnt/usb/distfiles_list.txt | grep '^http' | wc -l
$ sudo umount /mnt/usb
```

On the offline machine, I extracted them into `/usr/portage/distfiles`, where our package manager expects them to be. I then installed the target package:

```bash
$ sudo mount /dev/<DEVICE> /mnt/usb
$ cp /mnt/usb/distfiles/* /usr/portage/distfiles
$ sudo umount /mnt/usb
$ sudo emerge -av networkmanager
```

The installation finished without a hitch! I could now use `nmtui` to configure and connect to the WLAN.

### Updating the World

```bash
$ sudo su -c'emerge --sync && emerge -uDNav @world'
```

And now my machine's world is back up to date.
