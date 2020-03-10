# [PowerDNS-renumber.lua][PowerDNS-renumber]

IP address renumbering Lua script for [PowerDNS Recursor][].

## Prior Art

[Unbound-Views][] and the [Knot-Resolver renumber][Knot-renumber] module.

## Problem: [Redirection and Reflection][Reflection]

Quoting from the [OpenBSD pf FAQ][Reflection]:

> Often, redirection rules are used to forward incoming connections from
> the Internet to a local server with a private address in the internal
> network or LAN, as in:
>
>	server = 192.168.1.40
>
>	pass in on $ext_if proto tcp from any to $ext_if port 80 \
>	    rdr-to $server port 80
>
> But when the redirection rule is tested from a client on the LAN, it
> doesn't work.

## Solution: [Split-Horizon DNS][]

Quoting again from the [OpenBSD pf FAQ][Split-Horizon DNS]:

> It's possible to configure DNS servers to answer queries from local hosts
> differently than external queries so that local clients will receive the
> internal server's address during name resolution. They will then connect
> directly to the local server, and the firewall isn't involved at all.
> This reduces local traffic since packets don't have to be sent through
> the firewall.

[PowerDNS-renumber][] implements the [Split-Horizon DNS][] solution with a
[Lua][] script for the excellent [PowerDNS Recursor][].

[PowerDNS-renumber][] Split-Horizon is configured inside the
[renumber.lua][] script itself:

```lua
local wan = newNetmask('169.254.42.0/25')
local lan = '192.168.42'
```

With the above example config, if a lookup resolves to `169.254.42.69`
then `192.168.42.69` will be returned.

## Getting Started

* Install
* Install [renumber.lua][] in [PowerDNS Recursor][]'s configuration folder.
* Edit `recursor.conf` [lua-dns-script](https://Doc.PowerDNS.com/recursor/settings.html#lua-dns-script)
  setting to point to [renumber.lua][].
  e.g. `lua-dns-script=/etc/pdns/renumber.lua`
* Edit [renumber.lua][] with the destination subnet prefix assigned to the
  `lan` variable and an apropos `newNetmask()` CIDR assigned to the `wan`
  variable reflecting your network config.
* Configure `pf` (or the firewall of your choice) to portforward the redirects.
* Restart [PowerDNS Recursor][].
* Profit!!!

## License

See the [UNLICENSE](https://GitHub.com/yds/PowerDNS-renumber.lua/blob/master/LICENSE "public domain").

[README]:https://GitHub.com/yds/PowerDNS-renumber.lua/blob/master/README.md
[renumber.lua]:https://GitHub.com/yds/PowerDNS-renumber.lua/blob/master/renumber.lua
[Redirection]:http://www.OpenBSD.org/faq/pf/rdr.html "PF: Redirection (Port Forwarding)"
[Reflection]:http://www.OpenBSD.org/faq/pf/rdr.html#reflect "Redirection and Reflection"
[Split-Horizon DNS]:http://www.OpenBSD.org/faq/pf/rdr.html#splitdns "Split-Horizon DNS"
[Lua]:https://www.Lua.org/ "Lua is a powerful, efficient, lightweight, embeddable scripting language"
[Knot-renumber]:https://Knot-Resolver.ReadTheDocs.io/en/stable/modules-renumber.html "Knot-Resolver renumber module"
[PowerDNS Recursor]:https://www.PowerDNS.com/recursor.html "PowerDNS Recursor is a high-end, high-performance resolving name server"
[PowerDNS-renumber]:https://GitHub.com/yds/PowerDNS-renumber.lua "IP address renumbering Lua script for PowerDNS Recursor"
[Unbound-Views]:https://GitHub.com/yds/unbound-views/ "Split-Horizon Views plugin for the Unbound DNS resolver"
[Unbound]:http://Unbound.net/ "Unbound is a validating, recursive, and caching DNS resolver"
