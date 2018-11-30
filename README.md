libhash.sh
==========

This repository contains a series of libraries designed to perform
hashing algorithm in shell script.

* md2.sh implements the obsolete MD2 hashing algorithm, described in RFC1319.
* adler32.sh implements the ADLER32 checksum algorithm, described in RFC1950.

Note: The current implementations don't handle spaces nor the empty string.

Requirements
------------

* [libglarray.sh](https://github.com/Aversiste/libglarray.sh) ;
* encode.sh from [libencode.sh](https://github.com/Aversiste/libencode.sh) ;
* a POSIX shell from the § Compatibility section.

Compatibility
-------------

libhash.sh targets shells supporting the following KSH extensions:
“local” and arrays. It is therefore known to run with the following
shells:

- GNU Bourne-Again SHell - bash;
- MirBSD Korn SHell - mksh;
- OpenBSD Korn SHell - oksh
- Public Domain Korn SHell - pdksh;

The file adler32.sh is further compatible with:

- Z shell - zsh ;
- Debian Almquist shell - dash.
