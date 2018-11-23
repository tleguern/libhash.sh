#!/bin/ksh
# Tristan Le Guern <tleguern@bouledef.eu>
# This file is placed in the public domain.

. ../encode.sh
. ../glarray.sh
. ../adler32.sh

FAILED=0

t() {
	# $1 -> shell function to call
	# $2 -> $test expression
	# $3 -> expected exit code
	# $4 -> expected result

	echo "Run $1 \"$2\", expect $4 and exit code $3"
	tmp="$(mktemp -t test-adler32.sh.XXXXXXXX)"
	"$1" "$2" > "$tmp" #2> /dev/null
	ret="$?"
	if [ $ret -ne $3 ]; then
		echo "Wrong exit code for $1 \"$2\" ($ret)"
		FAILED=$((FAILED + 1))
		rm -f "$tmp"
		return
	fi
	if [ "$(cat $tmp)" != "$4" ]; then
		echo "Wrong result for $1 \"$2\" $(cat $tmp)"
		FAILED=$((FAILED + 1))
		rm -f "$tmp"
		return
	fi
	rm -f "$tmp"
	echo OK
}

t adler32 "a" 0 "00620062"
t adler32 "00620062" 0 "07040191"
t adler32 "Wikipedia" 0 "11e60398"

if [ $FAILED -ne 0 ]; then
	echo "Error: $FAILED errors found."
	exit 1
fi

