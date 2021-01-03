2015-12-03

how to share wifi connection over ethernet on linux
===================================================

after watching the **[video][1]**, maybe you want to know what exactly the
command does! well, I'll try to explain.

I write again the command here:

    # iptables -t nat -A POSTROUTING -o wlan0 -s 192.168.2.108 -j MASQUERADE

of course this is an [iptables][2] rule which use the [`nat`][3] table

    iptables -t nat

with this in effect, we tell iptables to manipulate the table (-t) [`nat`][3]

    -A POSTROUTING

append (`-A`) to chain `POSTROUTING`, the following rule

    -o wlan0

means that `wlan0` must be the outgoing interface of the packets

    -s 192.168.2.108 -j MASQUERADE

all packets which have as source address (`-s`) `192.168.2.108` (Xbox 360 IP)
will be [masked][4] (`-j MASQUERADE`) and will come out through `wlan0` (`-o wlan0`).

for a better understanding what words like: `table`, `chain` etc.. mean, I
suggest you to read the [iptables documentation][5].

I hope I have helped you to share your wifi connection over ethernet!

[1]: https://www.youtube.com/watch?v=YIRWwKraoRk
[2]: https://en.wikipedia.org/wiki/Iptables
[3]: https://netfilter.org/documentation/HOWTO/NAT-HOWTO.html
[4]: http://www.tldp.org/HOWTO/IP-Masquerade-HOWTO/ipmasq-background2.1.html
[5]: https://netfilter.org/documentation/
