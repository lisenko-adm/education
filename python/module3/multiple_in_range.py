def multiple_in_range(a, b):
    """print some numbers in range"""
    return [x for x in range(a, b+1) if x % 7 == 0 and x % 5 != 0]
