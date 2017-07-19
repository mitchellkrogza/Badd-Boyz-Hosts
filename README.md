# Badd-Boyz-Hosts
[![Build Status](https://travis-ci.org/mitchellkrogza/Badd-Boyz-Hosts.svg?branch=master)](https://travis-ci.org/mitchellkrogza/Badd-Boyz-Hosts)
A hosts file for use on any operating system to block bad domains out of your servers or devices.

* Here's the [raw hosts file](https://raw.githubusercontent.com/mitchellkrogza/Badd-Boyz-Hosts/master/hosts)

##### This hosts file is brought to you by Mitchell Krog
##### Copyright: https://github.com/mitchellkrogza
##### Source: https://github.com/mitchellkrogza/Badd-Boyz-Hosts

##### VERSION INFORMATION #
********************************************
#### Version: V1.2017.07.361
#### Bad Host Count: 4871
********************************************
##### VERSION INFORMATION ##

- You are free to copy and distribute this file for non-commercial uses, as long the original URL and attribution is included. 

### If this helps you why not [buy me a beer](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BKF9XT6WHATLG):beer:

# DOMAIN ADDITIONS / ISSUES: 

Please forward any additions, corrections or comments by logging an issue at https://github.com/mitchellkrogza/Badd-Boyz-Hosts/issues or simply send a Pull Request on the domains.txt file in the PULL_REQUESTS folder at https://github.com/mitchellkrogza/Badd-Boyz-Hosts/tree/master/PULL_REQUESTS

# FALSE POSITIVES / DOMAIN REMOVALS / OTHER ISSUES: 

If you find any domain names on this list which you believe are incorrectly listed, either log an issue at https://github.com/mitchellkrogza/Badd-Boyz-Hosts/issues or simply send a Pull Request on the domains.txt file in the PULL_REQUESTS folder at https://github.com/mitchellkrogza/Badd-Boyz-Hosts/tree/master/PULL_REQUESTS


## COMPILED FROM:

This list of hosts is compiled from real server logs on my own servers where I run a number of very busy web sites. 

This list originated from the list of bad referrers domain lists for The Nginx Ultimate Bad Bot Blocker at: https://github.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker and the Apache Ultimate Bad Bot Blocker at: https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker

The list has now been separated from those projects as it contains certain domains which do not actually belong in a hosts file.

## WHAT IS A HOSTS FILE?

A hosts file, named `hosts` (with no file extension), is a plain-text file
used by all operating systems to map hostnames to IP addresses.

In most operating systems, the `hosts` file is preferential to `DNS`.
Therefore if a domain name is resolved by the `hosts` file, the request never
leaves your computer.

Having a smart `hosts` file goes a long way towards blocking malware, adware, ransomware, porn and other nuisance web sites.

A hosts file like this causes any lookups to any of the listed domains to resolve back to your localhost so it prevents any outgoing connections to the listed domains.

## WHERE DO I PUT THIS ON MY COMPUTER?
To modify your current `hosts` file, look for it in the following places and modify it with a text
editor.

**Linux, Mac OS X, iOS, Android**: `/etc/hosts` folder.

**Windows Systems**: `%SystemRoot%\system32\drivers\etc\hosts` folder.

## UNDERSTANDS PUNYCODE / IDN DOMAIN NAMES
A lot of lists out there put funny domains into their hosts file. Your hosts file and DNS will not understand this. This list uses converted domains which are in the correct DNS format to be understood by any operating system.

For instance
The domain:

`lifehacĸer.com` (note the K)

actually translates to:

`xn--lifehacer-1rb.com`

You can do an nslookup on any operating system and it will resolve correctly.

`nslookup xn--lifehacer-1rb.com`

```xn--lifehacer-1rb.com
	origin = dns1.yandex.net
	mail addr = iskalko.yandex.ru
	serial = 2016120703
	refresh = 14400
	retry = 900
	expire = 1209600
	minimum = 14400
xn--lifehacer-1rb.com	mail exchanger = 10 mx.yandex.net.
Name:	xn--lifehacer-1rb.com
Address: 78.110.60.230
xn--lifehacer-1rb.com	nameserver = dns2.yandex.net.
xn--lifehacer-1rb.com	text = "v=spf1 redirect=_spf.yandex.net"
xn--lifehacer-1rb.com	nameserver = dns1.yandex.net.
```

- Look at: https://www.charset.org/punycode for more info on this.

# MIT License

## Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
## https://github.com/mitchellkrogza

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### If this helped you why not [buy me a beer](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BKF9XT6WHATLG):beer:

##### Some other free projects

- https://github.com/mitchellkrogza/nginx-ultimate-bad-bot-blocker
- https://github.com/mitchellkrogza/apache-ultimate-bad-bot-blocker
- https://github.com/mitchellkrogza/fail2ban-useful-scripts
- https://github.com/mitchellkrogza/linux-server-administration-scripts
- https://github.com/mitchellkrogza/Travis-CI-Nginx-for-Testing-Nginx-Configuration
- https://github.com/mitchellkrogza/Travis-CI-for-Apache-For-Testing-Apache-and-PHP-Configurations
- https://github.com/mitchellkrogza/Fail2Ban-Blacklist-JAIL-for-Repeat-Offenders-with-Perma-Extended-Banning

##### Into Photography?

Come drop by and visit me at https://mitchellkrog.com
