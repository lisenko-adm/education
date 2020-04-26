def search_in_dict(list_in, dict_in):
    """search in keys for unittest"""
    return {x for x in list_in for key in dict_in.keys() if x == key}
