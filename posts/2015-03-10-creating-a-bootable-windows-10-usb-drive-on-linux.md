---
title: Creating a Bootable Windows 10 USB Drive on Linux
tags: windows, linux
---

I ran into this problem recently, and it took me a while to solve it because I couldn't find very good material online. I hope this post helps some people reduce their frustrations.

#### Ingredients
- Recent  version of [ms-sys](http://ms-sys.sourceforge.net/)  (check your package manager)
- Windows Installation ISO (we'll call this `winstall.iso`)
- USB drive >= 8 GB with no data worth keeping
- [ntfs3g](http://www.tuxera.com/community/ntfs-3g-download/) (NTFS kernel config must be enabled/as module)

#### Instructions
1. Plug the drive in. We'll assume that it comes up as `/dev/sdX`.
2. Destroy the old partition table.
`# dd if=/dev/zero of=/dev/sdX bs=512 count=1 conv=notrunc`
3. Partition the disk.
`# echo -e "n\np\n1\n\n\nt 1\n7\nw\n" | fdisk /dev/sdX`
4. Create the NTFS file system.
`# mkfs.ntfs -f /dev/sdX1`
5. Create mounting directories.
`# mkdir -p /mnt/usb /mnt/iso}`
6. Mount the installation ISO.
`# mount -o loop winstall.iso /mnt/iso`
7. Mount the USB drive.
`# mount /dev/sdX1 /mnt/usb`
8. Copy over files (`-a` for archive mode, `-v` for verbose).
`# cp -av /mnt/iso/* /mnt/usb/`
9. Unmount everything.
`# umount /mnt/usb /mnt/iso`
10. This is where it gets a bit strange. Windows uses the disk MBR to load the partition EBR for boot, so we must prepare both.
11. Prepare the partition EBR.
`# ms-sys -n /dev/sdX1`
12. Prepare the disk MBR.
`# ms-sys -7 /dev/sdX`
13. Wait for the buffer cache to flush.
`# sync`
14. Reboot into the USB drive.

#### Troubleshooting
_The installer won't proceed after I select a disk with the error "we couldn't create a new partition or locate an existing one"._
I had to unplug my primary Linux HDD's SATA cable so that the Windows drive was the only one. 
