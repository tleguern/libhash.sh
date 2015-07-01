libhash.sh
==========

This repository contains a series of libraries designed to perform
hashing algorithm in shell script.

md2.sh implements the obsolete MD2 hashing algorithm, described in
RFC1319.

Note: The current implementation doesn't handle spaces nor the empty string.

Compatibility
-------------

libhash.sh targets shells supporting the following KSH extensions:
“local” and arrays. It is therefore known to run with the following
shells:

- GNU Bourne-Again SHell - bash;
- MirBSD Korn SHell - mksh;
- OpenBSD Korn SHell - oksh
- Public Domain Korn SHell - pdksh;
