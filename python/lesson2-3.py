#! /usr/bin/python3

import random

number = random.randint(1, 100)


while True:
    print("I made up a number. Can you guess it?")
    usernumber = int(input())
    print(usernumber)

    if usernumber == number:
        print("Good job, you right!")
    elif usernumber < number:
        print("Too low")
    else:
        print("Too high")
