---
title: Fixing FreeBSD Networking on Digital Ocean
tags: freebsd, bsd, cloud
---

I decided it was time to update my FreeBSD Digital Ocean droplet from the
end-of-life version 10.1 (shame on me) to the modern [version 10.3 (good until
April 2018)](https://www.freebsd.org/releases/10.3R/announce.html), and maybe
even [version 11 (good until
2021)](https://www.freebsd.org/releases/11.0R/schedule.html).  There were no
sensitive files on the VM, so I had put it off. Additionally, cloud providers
tend to have shoddy support for BSDs, so breakages after messing with the
kernel or init system are rampant, and I had been skirting that risk.

The last straw for me was a broken `pkg`:

```
$ pkg update
/usr/local/lib/libpkg.so.3: Undefined symbol "openat"
```

Uh oh. Some Googling led to an
[answer](https://github.com/freebsd/pkg/issues/1526). Essentially, around `pkg`
version 1.9, there were some library version requirements that my outdated
installation didn't have. Let's start with upgrading to FreeBSD 10.3.

```bash
# freebsd-update fetch install
# freebsd-update -r 10.3-RELEASE upgrade
# freebsd-update install
```

I rebooted, and of course, it happened: no `ssh` access after 30 seconds, 1
minute, 2 minutes...I logged into my Digital Ocean account and saw green status
lights for the instance, but something was definitely wrong.

### Investigation
Fortunately, Digital Ocean provides console access (albeit slow, buggy, and
crashes my browser every time I run `ping`). `ifconfig` revealed that the
interfaces `vtnet0` (public) and `vtnet1` (private) haven't been configured
with IP addresses. Combing through files in `/etc/rc.*`, I found a file called
`/etc/rc.digitalocean.d/${DROPLET_ID}.conf` containing static network settings
for this droplet (`${DROPLET_ID}` was something like `1234567`).

It seemed that FreeBSD wasn't picking up the Digital Ocean network settings
config file. The quick and dirty way would have been to messily append the
contents of this file to `/etc/rc.conf`, but I wanted a nicer way. Reading the
script in `/etc/rc.d/digitalocean` told me that
`/etc/rc.digitalocean.d/${DROPLET_ID}.conf` was supposed to have a symlink at
`/etc/rc.digitalocean.d/droplet.conf`. It was broken and pointed to
`/etc/rc.digitalocean.d/.conf`, which could happen when the `curl` command in
`/etc/rc.d/digitalocean` fails:

```bash
# /etc/rc.d/digitalocean

DROPLET_ID=$(/usr/local/bin/curl --retry 5 --retry-delay 2 \
             --connect-timeout 2 -s http://169.254.169.254/metadata/v1/id)
# ...
/bin/ln -s -f /etc/rc.digitalocean.d/$DROPLET_ID.conf \
              /etc/rc.digitalocean.d/droplet.conf
```


Using `grep` to fish for files containing `droplet.conf`, I discovered that it
was hacked into the init system via `load_rc_config()` in `/etc/rc.subr`:

```bash
# /etc/rc.subr

if [ -L /etc/rc.digitalocean.d/droplet.conf -a -f /etc/rc.digitalocean.d/droplet.conf ]
then
        . /etc/rc.digitalocean.d/droplet.conf
fi
```

### The Fix

I could fix that symlink and restart the services:

```bash
# set DROPLET_ID=$(curl -s http://169.254.169.254/metadata/v1/id)
# ln -s -f /etc/rc.digitalocean.d/${DROPLET_ID}.conf /etc/rc.digitalocean.d/droplet.conf
# /etc/rc.d/netif restart
# /etc/rc.d/routing restart
```

Networking was working again, and I could then `ssh` into my server and run the
following to finish the upgrade:
```bash
# freebsd-update install
```

At this point, I decided that I didn't want to deal with this mess again until
at least 2021, so I decided to go for 11.0-RELEASE:

```bash
# freebsd-update -r 11.0-RELEASE update
# freebsd-update install
# reboot
```

No network outages!

```bash
# freebsd-update install
# pkg-static install -f pkg
# pkg update
# pkg upgrade
# portsnap fetch update
# portmaster -Da
# uname -a
FreeBSD hostname 11.0-RELEASE-p9 FreeBSD 11.0-RELEASE-p9
# pkg -v
1.10.1
```

The problem was solved correctly, and my `/etc/rc.conf` remains free of
generated cruft.

The Digital Ocean team can make our lives easier by having their init scripts
do more thorough system checking, e.g., catching broken symlinks and bad
network addresses. I'm hopeful that collaboration of the FreeBSD team and cloud
providers will one day result in automatic fixing of these situations, or at
least a correct status indicator.
