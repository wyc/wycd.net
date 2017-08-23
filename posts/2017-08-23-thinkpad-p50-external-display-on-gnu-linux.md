---
title: "How to Mirror to Projectors Using a ThinkPad P50 on GNU/Linux"
tags: technology, thinkpad, linux
---

It's difficult to present using an external display using GNU/Linux on the
ThinkPad P50. It's outfitted with an NVIDIA Optimus setup, and the official
documentation even admits "[limited](http://us.download.nvidia.com/XFree86/Linux-x86/319.12/README/optimus.html)"
support for GNU/Linux. I recently had to figure this out to give a presentation
from my laptop.

## nouveau

This tutorial will use the proprietary NVIDIA drivers, but if you prefer a
completely open-source nouveau-based solution, the best resource may be the
ArchLinux wiki's page on [PRIME](https://wiki.archlinux.org/index.php/PRIME).

## Prerequisite Software

You need to install the following software for your distribution:

- [Bumblebee](https://bumblebee-project.org/)
- [NVIDIA Proprietary Drivers](https://www.nvidia.com/object/unix.html)
- [Intel Graphics Drivers](https://www.intel.com/content/www/us/en/support/graphics-drivers.html) with the [intel-virtual-output tool](https://cgit.freedesktop.org/xorg/app/intel-gpu-tools/)

I cannot praise the Bumblebee team enough for their excellent work. Thank you,
Bumblebee team.

## Configuration

In `/etc/bumblebee/xorg.conf.nvidia`, ensure that the following settings are active:

```
Section "ServerLayout"
    Identifier  "Layout0"
    Option      "AutoAddDevices" "true"
    Option      "AutoAddGPU" "false"
EndSection

Section "Device"
    Identifier  "DiscreteNvidia"
    Driver      "nvidia"
    VendorName  "NVIDIA Corporation"

    Option "ProbeAllGpus" "false"
    Option "AllowEmptyInitialConfiguration"
    Option "UseEDID" "true"
    # Option "UseDisplayDevice" "none"
EndSection
```

Important bits:

- `AutoAddDevices` ensures that the GPU gets recognized.
- `AllowEmptyInitialConfiguration` allows X and NVIDIA to play nicely and start
  up without being attached to an external display.
- `UseEDID` allows the NVIDIA card to probe the display device for metadata.

You should consult the Bumblebee documentation, but note that your NVIDIA card
should not have an entry in your default Xorg configuration.

## Presenting

First, plug in your external monitor. Then,

```bash
# init.d-style
$ sudo /etc/init.d/bumblebee start
# with systemd
$ sudo systemctl start bumblebee

$ sudo tee /proc/acpi/bbswitch <<<ON  # Turn the card on
$ sudo modprobe nvidia  # ensure the nvidia driver is loaded
$ optirun true  # "warm" the new session
$ intel-virtual-output  # register the new display
$ xrandr
# At this point, you should see a VIRTUALX display with resolutions read. This
# is the output name for your external device. Mine is VIRTUAL2. Additionally,
# you'll see the original output for your laptop's current monitor. Mine is
# eDP1.
$ xrandr --output VIRTUAL2 --auto  # broadcast to the external display
$ xrandr --output eDP1 --primary --scale 0.5x0.5  # scale down my hi-res display
$ export DISPLAY=:8  # bumblebee default display number
$ optirun evince -s presentation.pdf  # run my desired applicaiton with optirun
```

## Unpresenting

After you're done presenting, do the following,

```bash
$ xrandr --output VIRTUAL2 --off  # turn off the external display
$ xrandr --output eDP1 --primary --scale 1x1  # return scale to normal

# init.d
$ sudo /etc/init.d/bumblebee stop
# systemd
$ sudo systemctl stop bumblebee

$ sudo modprobe -r nvidia  # remove the nvidia kernel module
$ sudo tee /proc/acpi/bbswitch <<<OFF  # turn the card off
$ export DISPLAY=:0  # set the display back to the default
```

At this point, you can unplug the monitor.


## Other resources

I relied on these pages extensively to come to a working solution:

- [Bumblebee - ArchLinux Wiki](https://wiki.archlinux.org/index.php/Bumblebee#Output_wired_to_the_NVIDIA_chip)

- [Using the HDMI Port on Optimus-Enabled Thinkpads - Reddit](https://www.reddit.com/r/archlinux/comments/326bl6/using_the_hdmi_port_on_optimusenabled_thinkpads/)

- [Bumblebee with HDMI on NVIDIA - SuperUser](https://superuser.com/questions/1082617/bumblebee-with-hdmi-on-nvidia-make-usable-both-with-without-connected-monitor)
