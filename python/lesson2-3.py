#! /usr/bin/python3

import random
number = random.randint(1, 100)
while True:
    print("I made up a number. Can you guess it?")
    try:
        user_number = int(input())
    except ValueError:
        print("Number, please")
        continue
    if user_number == number:
        print("Good job, you right!")
        break
    elif user_number < number:
        print("Too low")
    else:
        print("Too high")
