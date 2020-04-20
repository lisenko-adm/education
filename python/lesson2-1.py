#! /usr/bin/python3

import sys

number = int(sys.argv[1])
if (-15 < number <= 12) or (14 < number < 17) or (19 <= number):
    print(True)
else:
    print(False)
