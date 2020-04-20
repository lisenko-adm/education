#! /usr/bin/python3

import sys

side_a = int(sys.argv[1])
side_b = int(sys.argv[2])
side_c = int(sys.argv[3])

p = (side_a + side_b + side_c) / 2

S = (p * (p - side_a) * (p - side_b) * (p - side_c)) ** .5
print(S)
