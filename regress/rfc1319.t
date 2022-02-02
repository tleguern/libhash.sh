#!/bin/sh

. ./t.sh
. ../md2.sh

echo "TAP version 13"
echo "# MD2 test suite"
echo "1..7"

t "md2 1" md2 0 "8350e5a3e24c153df2275c9f80692773" ""
t "md2 2" md2 0 "32ec01ec4a6dac72c0ab96fb34c0b5d1" "a"
t "md2 3" md2 0 "da853b0d3f88d99b30283a69e6ded6bb" "abc"
t "md2 4" md2 0 "ab4f496bfb2a530b219ff33031fe06b0" "message digest"
t "md2 5" md2 0 "4e8ddff3650292ab5a4108c3aa47940b" "abcdefghijklmnopqrstuvwxyz"
t "md2 6" md2 0 "da33def2a42df13975352846c30338cd" "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
t "md2 7" md2 0 "d5976f79d83d3a0dc9806c3c66f3efd8" "12345678901234567890123456789012345678901234567890123456789012345678901234567890"

test_done
