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

LIBNAME="libhash_md4.sh"
LIBVERSION="1.0"

F() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"; shift

	# X AND Y OR !X AND Z
	print $(((_x & _y) | (~_x & _z)))
}

G() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"; shift

	# X AND Y OR X AND Z OR Y AND Z
	print $(((_x & _y) | (_x & _z) | (_y & _z)))
}

H() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"; shift

	# X XOR Y XOR Z
	print $((_x ^ _y ^ _z))
}

md4() {
	local _value="$*"

	# Step 0. Preparation
	local _i
	local _m=""
	for _i in $(printf "$_value" | sed 's/./& /g'); do
		_m="${_m}$(dectobin $(ord $_i))"
	done

	# Step 1. Append Padding Bits
	local _olen=${#_m}
	_m=${_m}1
	_m=$(rightpad $_m $((448 - _olen % 512 - 1)) 0)

	# Step 2. Append Length
	local _b=$(dectobin $_olen)
	_m="${_m}$(leftpad $_b $((64 - ${#_b})) 0)"
	glarray M $(printf "$_m" | sed -E 's/.{16}/& /g')
	local _N="${#M[*]}"
	if [ (($_N % 16)) -ne 0 ]; then # Assert !
		print "Error"
		exit 2
	fi

	# Step 3. Initialize MD Buffer
	glarray A 01 23 45 67
	glarray B 89 ab cd ef
	glarray C fe dc ba 98
	glarray D 76 54 32 10

	# Step 4. Process Message in 16-Word Blocks
	echo -n $_m | wc -c
	exit 42

	# Step 5. Output

	# Step 6. Cleanup
	unset M
}
