def swap_max_and_min(tasklist):
    if len(tasklist) == len(set(tasklist)):
        max_index = tasklist.index(max(tasklist))
        min_index = tasklist.index(min(tasklist))
        max_item = max(tasklist)
        min_item = min(tasklist)
        tasklist[max_index] = min_item
        tasklist[min_index] = max_item
        return tasklist
    else:
        raise ValueError