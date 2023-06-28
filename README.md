# libhash.sh

This repository contains a series of libraries designed to perform hashing algorithm in shell script.

* md2.sh implements the obsolete MD2 hashing algorithm, described in RFC1319.
* adler32.sh implements the ADLER32 checksum algorithm, described in RFC1950.

## Requirements

* any POSIX shell from the § Compatibility section.

## Compatibility

libhash.sh targets shells supporting the following KSH extensions: the local keyword and arrays.
It is therefore known to run with the following shells:

* GNU Bourne-Again SHell - bash;
* MirBSD Korn SHell - mksh;
* OpenBSD Korn SHell - oksh
* Public Domain Korn SHell - pdksh;

The file adler32.sh is further compatible with:

* Debian Almquist shell - dash ;
* Yet Another SHell - yash.
