#!/bin/sh

. ./t.sh
. ../adler32.sh

echo "TAP version 13"
echo "# Adler32 test suite"
echo "1..4"

t "adler32 1" adler32 0 "00620062" "a"
t "adler32 2" adler32 0 "07040191" "00620062"
t "adler32 3" adler32 0 "11e60398" "Wikipedia"
t "adler32 4" adler32 0 "4dab074c" "Wikipedia c'est bien"

test_done
