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

set -e

F() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"

	# X AND Y OR !X AND Z
	echo $(((_x & _y) | (~_x & _z)))
}

G() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"

	# X AND Y OR X AND Z OR Y AND Z
	echo $(((_x & _y) | (_x & _z) | (_y & _z)))
}

H() {
	local _x="$1"; shift
	local _y="$1"; shift
	local _z="$1"

	# X XOR Y XOR Z
	echo $((_x ^ _y ^ _z))
}

# Round 1 operation
FF() {
	local _a="$1"; shift
	local _b="$1"; shift
	local _c="$1"; shift
	local _d="$1"; shift
	local _x="$1"; shift
	local _s="$1"

	# The modulo operation is here to simulate an eventual integer overflow
	local _res=0

	_res=$(F $_b $_c $_d)
	_res=$(( ( _a + _res) % 4294967296 ))
	_res=$(( ( _x + _res) % 4294967296 ))
	_res=$(( ( _res << _s) % 4294967296 ))
	echo $_res
}

# Round 2 operation
GG() {
	local _a="$1"; shift
	local _b="$1"; shift
	local _c="$1"; shift
	local _d="$1"; shift
	local _x="$1"; shift
	local _s="$1"

	# 5A827999 is an hex representation of the square root of 2 / 4
	_res=$(G $_b $_c $_d)
	_res=$(( ( _a + _res) % 4294967296 ))
	_res=$(( ( _x + _res) % 4294967296 ))
	_res=$(( ( $(hextodec 5A827999) + _res) % 4294967296 ))
	_res=$(( ( _res << _s) % 4294967296 ))
	echo $_res
}

# Round 3 operation
HH() {
	local _a="$1"; shift
	local _b="$1"; shift
	local _c="$1"; shift
	local _d="$1"; shift
	local _x="$1"; shift
	local _s="$1"

	# 6ED9EBA1 is an hex representation of the square root of 3 / 4
	_res=$(H $_b $_c $_d)
	_res=$(( ( _a + _res) % 4294967296 ))
	_res=$(( ( _x + _res) % 4294967296 ))
	_res=$(( ( $(hextodec 6ED9EBA1) + _res) % 4294967296 ))
	_res=$(( ( _res << _s) % 4294967296 ))
	echo $_res
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
	#XXX: Do I need to swap?
	_m="${_m}$(swap64 $(leftpad $_b $((64 - ${#_b})) 0))"
	#_m="${_m}$(leftpad $_b $((64 - ${#_b})) 0)"

	# Step 3. Initialize MD Buffer
	_A=19088743
	_B=2309737967
	_C=4276878552
	_D=1985229328

	# Step 4. Process Message in 16-Word Blocks
	glarray M $(printf "$_m" | sed -E 's/.{16}/& /g')
	local _N="${#M[*]}"
	if [ $((_N % 16)) -ne 0 ]; then # Assert !
		printf "Error\n" >&2
		exit 2
	fi
	_i=0
	for _i in ${M[*]}; do
		glarray X $(printf "$_i" | sed -E 's/.{1}/& /g')

		local _AA=$_A
		local _BB=$_B
		local _CC=$_C
		local _DD=$_D

		# Round 1
		_A=$(FF $_A $_B $_C $_D ${X[0]} 3)
		_D=$(FF $_D $_A $_B $_C ${X[1]} 7)
		_C=$(FF $_C $_D $_A $_B ${X[2]} 11)
		_B=$(FF $_B $_C $_D $_A ${X[3]} 19)
		_A=$(FF $_A $_B $_C $_D ${X[4]} 3)
		_D=$(FF $_D $_A $_B $_C ${X[5]} 7)
		_C=$(FF $_C $_D $_A $_B ${X[6]} 11)
		_B=$(FF $_B $_C $_D $_A ${X[7]} 19)
		_A=$(FF $_A $_B $_C $_D ${X[8]} 3)
		_D=$(FF $_D $_A $_B $_C ${X[9]} 7)
		_C=$(FF $_C $_D $_A $_B ${X[10]} 11)
		_B=$(FF $_B $_C $_D $_A ${X[11]} 19)
		_A=$(FF $_A $_B $_C $_D ${X[12]} 3)
		_D=$(FF $_D $_A $_B $_C ${X[13]} 7)
		_C=$(FF $_C $_D $_A $_B ${X[14]} 11)
		_B=$(FF $_B $_C $_D $_A ${X[15]} 19)

		# Round 2
		_A=$(GG $_A $_B $_C $_D ${X[0]} 3)
		_D=$(GG $_D $_A $_B $_C ${X[4]} 5)
		_C=$(GG $_C $_D $_A $_B ${X[8]} 9)
		_B=$(GG $_B $_C $_D $_A ${X[12]} 13)
		_A=$(GG $_A $_B $_C $_D ${X[1]} 3)
		_D=$(GG $_D $_A $_B $_C ${X[5]} 5)
		_C=$(GG $_C $_D $_A $_B ${X[9]} 9)
		_B=$(GG $_B $_C $_D $_A ${X[13]} 13)
		_A=$(GG $_A $_B $_C $_D ${X[2]} 3)
		_D=$(GG $_D $_A $_B $_C ${X[6]} 5)
		_C=$(GG $_C $_D $_A $_B ${X[10]} 9)
		_B=$(GG $_B $_C $_D $_A ${X[14]} 13)
		_A=$(GG $_A $_B $_C $_D ${X[3]} 3)
		_D=$(GG $_D $_A $_B $_C ${X[7]} 5)
		_C=$(GG $_C $_D $_A $_B ${X[11]} 9)
		_B=$(GG $_B $_C $_D $_A ${X[15]} 13)

		# Round 3
		_A=$(HH $_A $_B $_C $_D ${X[0]} 3)
		_D=$(HH $_D $_A $_B $_C ${X[8]} 9)
		_C=$(HH $_C $_D $_A $_B ${X[4]} 11)
		_B=$(HH $_B $_C $_D $_A ${X[12]} 15)
		_A=$(HH $_A $_B $_C $_D ${X[2]} 3)
		_D=$(HH $_D $_A $_B $_C ${X[10]} 9)
		_C=$(HH $_C $_D $_A $_B ${X[6]} 11)
		_B=$(HH $_B $_C $_D $_A ${X[14]} 15)
		_A=$(HH $_A $_B $_C $_D ${X[1]} 3)
		_D=$(HH $_D $_A $_B $_C ${X[9]} 9)
		_C=$(HH $_C $_D $_A $_B ${X[5]} 11)
		_B=$(HH $_B $_C $_D $_A ${X[13]} 15)
		_A=$(HH $_A $_B $_C $_D ${X[3]} 3)
		_D=$(HH $_D $_A $_B $_C ${X[11]} 9)
		_C=$(HH $_C $_D $_A $_B ${X[7]} 11)
		_B=$(HH $_B $_C $_D $_A ${X[15]} 15)

		# Additions
		_A=$(( ( _A + _AA ) % 4294967296 ))
		_B=$(( ( _B + _BB ) % 4294967296 ))
		_C=$(( ( _C + _CC ) % 4294967296 ))
		_D=$(( ( _D + _DD ) % 4294967296 ))
	done

	# Step 5. Output
	#_A=$((_A & 0xFF))$(((_A >> 8) & 0xFF))$(((_A >> 16) & 0xFF))$(((_A >> 24) & 0xFF))
	#_B=$((_B & 0xFF))$(((_B >> 8) & 0xFF))$(((_B >> 16) & 0xFF))$(((_B >> 24) & 0xFF))
	#_C=$((_C & 0xFF))$(((_C >> 8) & 0xFF))$(((_C >> 16) & 0xFF))$(((_C >> 24) & 0xFF))
	#_D=$((_D & 0xFF))$(((_D >> 8) & 0xFF))$(((_D >> 16) & 0xFF))$(((_D >> 24) & 0xFF))
	printf "%x %x %x %x\n" $_A $_B $_C $_D

	# Step 6. Cleanup
	unset M X
}

. ./encode.sh
. ./glarray.sh
md4 a
