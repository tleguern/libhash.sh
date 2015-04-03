#!/bin/ksh
#
# Copyright (c) 2015 Tristan Le Guern <tleguern@bouledef.eu>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

set -e

readonly PROGNAME="$(basename $0)"
readonly VERSION='v1.0'
 
usage() {
	echo "usage: $PROGNAME [-h hash] [-s string | file]"
}
 
file=""
hflag="md2"
sflag=""

while getopts ":h:s:" opt;do
	case $opt in
		h) hflag="$OPTARG";;
		s) sflag="$OPTARG";;
		:) echo "$PROGNAME: option requires an argument -- $OPTARG";
		   usage; exit 1;;
		?) echo "$PROGNAME: unkown option -- $OPTARG";
		   usage; exit 1;;
		*) usage; exit 1;;
	esac
done
shift $(( $OPTIND - 1 ))

if [ -n "$1" ]; then
	file="$1"
	shift
fi

if [ $# -ge 1 ]; then
	echo "$PROGNAME: invalid trailing chars -- $@"
	usage
	exit 1
fi

set -u

case "$hflag" in
	md2) . ./md2.sh;;
	*) echo "$PROGNAME: invalid hash algorithm -- $hflag";;
esac
if [ -n "$sflag" ] && [ -n "$file" ]; then
	usage
	exit 1
fi
if [ -z "$sflag" ] && [ -z "$file" ]; then
	usage
	exit 1
fi
if [ -n "$file" ]; then
	if [ -f "$file" ]; then
		sflag="$(cat $file)"
	else
		echo "$PROGNAME: $file: No such file"
	fi
fi

. ./encode.sh
. ./glarray.sh
. ./${hflag}.sh

glarray_init

${hflag} "$sflag"

