#!/usr/bin/env python

import sys
import re

last_key, max_val = None, -sys.float_info.max


def print_key(l_k, k, m_v, v):
    if l_k and l_k != k:
        print("%s\t%s" % (l_k, m_v))
        return k, float(v)
    else:
        return k, max(m_v, float(v))


for line in sys.stdin:
    key, val = line.strip().split(',')
    last_key, max_val = print_key(last_key, key, max_val, val)
print("%s\t%s" % (last_key, max_val))
