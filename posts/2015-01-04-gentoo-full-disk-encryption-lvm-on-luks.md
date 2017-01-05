---
title: "Gentoo Full Disk Encryption: LVM on LUKS"
tags: gentoo, linux, security
---
Boot up a Gentoo Install CD/DVD/USB.

### Setup Disks
For simplicity, assume we're installing to the 500 GB disk `/dev/sda`.

Delete the partition table for the disk and make a new one with just one Linux (type 83) partition. At this point, additional partitions may be desired for UEFI compatibility or other operating systems, but such is beyond the scope of this article.
```
# dd if=/dev/zero of=/dev/sda bs=512 count=1 conv=notrunc
# echo -ne "n\np\n1\n\n\nt 1\n83\nw\n" | fdisk /dev/sda
```

Load necessary kernel modules and setup LUKS on the new partition.
```
# modprobe dm-crypt aes sha256
# cryptsetup luksFormat /dev/sda1
```

Open the LUKS partition and create an LVM physical volume, volume group, and logical volumes. The logical volumes can be simple as boot, swap, and root, but below is my habitual setup on a 500 GB disk.
```
# cryptsetup luksOpen /dev/sda1 main
# pvcreate /dev/mapper/main
# vgcreate vg1 /dev/mapper/main
# lvcreate -L 1G       -n boot vg1
# lvcreate -L 4G       -n swap vg1
# lvcreate -L 250G     -n data vg1
# lvcreate -L 5G       -n root vg1
# lvcreate -L 60G      -n home vg1
# lvcreate -L 80G      -n usr  vg1
# lvcreate -L 40G      -n var  vg1
# lvcreate -l 100%FREE -n opt  vg1
# pvdisplay # show physical volumes
# vgdisplay # show volume groups
# lvdisplay # show logical volumes
```
Format the logical volumes.
```
# mkfs.ext2 -L /boot /dev/vg1/boot
# mkswap    -L /swap /dev/vg1/swap
# mkfs.ext4 -L /data /dev/vg1/data
# mkfs.ext4 -L /     /dev/vg1/root
# mkfs.ext4 -L /home /dev/vg1/home
# mkfs.ext4 -L /usr  /dev/vg1/usr
# mkfs.ext4 -L /var  /dev/vg1/var
# mkfs.ext4 -L /opt  /dev/vg1/opt
```
Mount the volumes for a Gentoo install.
```
# mount /dev/vg1/root /mnt/gentoo
# mkdir -p /mnt/gentoo/{boot,data,home,usr,var,opt}
# mount /dev/vg1/boot /mnt/gentoo/boot
# mount /dev/vg1/data /mnt/gentoo/data
# mount /dev/vg1/home /mnt/gentoo/home
# mount /dev/vg1/usr  /mnt/gentoo/usr
# mount /dev/vg1/var  /mnt/gentoo/var
# mount /dev/vg1/opt  /mnt/gentoo/opt
```
### Install Gentoo
```
# wget http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-20141204.tar.bz2 # You may need to update this URL.
# tar -C /mnt/gentoo -xvjpf stage3-*.tar.bz2
# cp -L /etc/resolv.conf /mnt/gentoo/etc/
# mount -t proc proc /mnt/gentoo/proc
# mount --rbind /sys /mnt/gentoo/sys
# mount --make-rslave /mnt/gentoo/sys # systemd only
# mount --rbind /dev /mnt/gentoo/dev
# mount --make-rslave /mnt/gentoo/dev # systemd only
# chroot /mnt/gentoo /bin/bash # enter the matrix
# source /etc/profile
# export PS1="(chroot) $PS1"
```

[Setup portage, system time, the init system, and locales](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Configuring_portage).

[Configure the kernel](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel) and [enable dm-crypt in the kernel config](http://wiki.gentoo.org/wiki/Dm-crypt#Kernel_Configuration).

[Configure the system](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System) and [install system tools](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Tools).


`/etc/fstab` should include entries similar to:
```
/dev/vg1/root /     ext4 defaults,noatime  0 1
/dev/vg1/swap none  swap sw                0 0
/dev/vg1/boot /boot ext2 noatime           0 1
/dev/vg1/data /data ext4 defaults,noatime  0 2
/dev/vg1/home /home ext4 defaults,noatime  0 2
/dev/vg1/usr  /usr  ext4 defaults,noatime  0 2
/dev/vg1/var  /var  ext4 defaults,noatime  0 2
/dev/vg1/opt  /opt  ext4 defaults,noatime  0 2
```


Install genkernel.

```
# echo "sys-kernel/genkernel cryptsetup" >> /etc/portage/package.use
# emerge -av genkernel
```
In `/etc/genkernel.conf`, ensure that the following are set appropriately.
```
# Don't overwrite /usr/src/linux/.config
MRPROPER="no"
# Number of logical CPUs
MAKEOPTS="-j2"
# Ability to open LVM partitions
LVM="yes"
# Ability to decrypt
LUKS="yes"
# Default real_root variable (redundant, because it's specified via GRUB2)
REAL_ROOT="/dev/vg1/root"
# This overlays arbitrary files into the initramfs
INITRAMFS_OVERLAY="/boot/overlay"
```

Compile and install the kernel with `genkernel`.
```
# genkernel all
```

Install GRUB2 and configure to load from the encrypted partition.

```
# echo "sys-boot/grub device-mapper >> /etc/portage/package.use"
# emerge -av grub
# echo 'GRUB_ENABLE_CRYPTODISK=y' >> /etc/default/grub
# echo 'GRUB_CMDLINE_LINUX="udev dolvm crypt_root=/dev/sda1 root_key=disk.key real_root=/dev/vg1/root cryptdevice=/dev/sda1:vg1-boot"' >> /etc/default/grub
```

- `dolvm` runs the Linux Volume Manager
- `crypt_root` tells LUKS where the encrypted partition resides
- `real_root` tells initramfs where to mount the real root
- `root_key` tells LUKS the relative location of the key
- `cryptodevice` tells GRUB2 where to find the kernel on the encrypted drive

__If you don't want to store a secondary LUKS key on the encrypted disk, remove the `root_key=disk.key` parameter and skip the following optional section. The boot process will then prompt for the same interactive password twice. This is the time-old tradeoff between security and convenience.__

Generate the GRUB2 config and install GRUB2 into the MBR.

```
# grub2-mkconfig -o /boot/grub/grub.cfg
# grub2-mkinstall /dev/sda
```

#### Generate an alternative LUKS key (optional).
These steps will allow you to only enter the interactive password once at the initial GRUB2 prompt. A secondary access key will be generated and enabled, stored in the `initramfs` to decrypt the drive again. _At rest, the key will always be safely residing on your encrypted disk._
```
# mkdir -p /boot/overlay/mnt/key
# dd bs=1024 count=4 if=/dev/urandom of=/boot/overlay/mnt/key/disk.key
# cryptsetup luksAddKey /dev/sda1 /boot/overlay/mnt/key/disk.key
```

Reboot and cross your fingers.

### Some Remaining Risks
- Someone could still hack your BIOS
- Someone could still hack GRUB2
- Someone could still hack your hardware
- Someone could hold your kneecaps hostage with a $5 wrench
