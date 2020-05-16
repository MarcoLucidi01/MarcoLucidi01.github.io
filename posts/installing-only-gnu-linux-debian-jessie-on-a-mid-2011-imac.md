2016-12-03

# installing only gnu/linux (debian jessie) on a mid 2011 imac

[**boot process video**][1]

the reasons why I have done this are various, but I think, the most significant
is that, after using a linux distro daily on my laptop, going back on osx at
home was painful and I felt like in a "cage". this was not good for me, and in
fact, I preferred to use the laptop even at home and, I stopped to use that imac
for a while.

then I realize that a full linux installation on a mac can be done easily, so, I
did some research ([question unix stackExchange][2], [arch wiki][3], [debian
wiki][4]) and on a sunday morning I did it!

I have this little guy here ([imac12,1][5]), but with 8gb of ram which I
personally installed.

first of all, I made a [macos installation media][6], so, if in future I want, I
can reinstall it easily, since my intention was to completely format the hard
disk.

then I used a debian 8 [netinstall][7] through an usb drive, simply rebooted
holding down "opt key" and selected the right option. the installation was
completed without issues using the ethernet cable (the wifi has been also
recognized by the installer).

I installed kde and at the first reboot I got only the shell! unfortunately
[firmware-linux-nonfree][8] are required to get the radeon work!

## what did work out of the box

- **ethernet**: since the installer;
- **wifi**: I guess since the installer because it was recognized, but I can't
  say for sure;
- **usb**: nothing to say;
- **thunderbolt**: tested with a second 1080p vga monitor that I use regularly
  (the only thing I can test);
- **speakers**;
- **camera and microphone**: tested with vlc;
- **suspend to ram**: all good;
- **cd/dvd**: tested with k3b;

## what did NOT work out of the box

- **video card**: as I said, firmware-linux-nonfree are required;
- **jack audio**: small issue, fix:

      # echo "options snd-hda-intel model=imac27_122" >> /etc/modprobe.d/imac\_local.conf

  reboot. [Bugreport][9];
- **apple wireless keyboard and magic mouse**: fun fact, in the installer, I
  did the entire process with the apple wireless keyboard, but then, once
  debian was up and running, it didn't work anymore. I guess, bluetooth
  drivers are missing, but I won't install them since I hate that things;
- **brightness**: found a fix with xrandr:

      xrandr --output eDP --brightness 0.5

I can't test the **firewire port** nor the **sd reader**.

finally I started to use this machine again!

[1]: https://www.youtube.com/watch?v=TPbx6QH_p0s
[2]: https://unix.stackexchange.com/questions/320107/installing-only-linux-on-a-mac-and-in-case-go-back-to-macos
[3]: https://wiki.archlinux.org/index.php/IMac_Aluminum
[4]: https://wiki.debian.org/iMacIntel
[5]: https://support.apple.com/kb/sp623?locale=en_US
[6]: https://support.apple.com/en-us/HT201372
[7]: https://www.debian.org/CD/netinst/
[8]: https://packages.debian.org/stable/firmware-linux-nonfree
[9]: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=743936
