2016-02-08

# virtualbox guest additions on debian

ok, this is a post for myself: every time that I need to install a new vm on
[virtualbox][1] I systematically forget the steps to install guest additions!

most of the times, I install [debian][2], so this "tutorial" will be focused on this
particular linux distribution.

open a terminal:

    # apt-get update && apt-get upgrade
    # apt-get install dkms

now from the **Devices** menu, click on "Insert Guest Additions CD image..."

if the .iso will not mount automatically, in a terminal:

    # mount /media/cdrom

then:

    # sh /media/cdrom/VBoxLinuxAdditions.run
    # reboot

info: [`dkms`][3]

from virtualbox site: "Be sure to install DKMS before installing the Linux
Guest Additions. If DKMS is not available or not installed, the guest kernel
modules will need to be recreated manually whenever the guest kernel is
updated".

actually these three packages are what we need for the guest additions:
[`make`][4], [`gcc`][5], [`linux-headers`][6], but they are included in
dependencies of `dkms` so they are installed automatically with `dkms`.

p.s. it's recommended to install `dkms` even on the host system.

if the installation failed, make sure that you have the last .iso available and
also the [last version of Virtualbox][7]

[1]: https://www.virtualbox.org/
[2]: https://www.debian.org/
[3]: https://packages.debian.org/en/stable/dkms
[4]: https://packages.debian.org/en/stable/make
[5]: https://packages.debian.org/en/stable/gcc
[6]: https://packages.debian.org/en/stable/linux-headers-amd64
[7]: http://download.virtualbox.org/virtualbox/
