#!/usr/bin/env python
# import io
import sys
import re

last_key, max_val = None, -sys.float_info.max


def print_key(l_k, k, m_v, v):
    if l_k and l_k != k:
        print("%s\t%s" % (l_k, m_v))
        return k, float(v)
    else:
        return k, max(m_v, float(v))


# input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
for line in sys.stdin:
    try:
        key, val = line.strip().split(',')
        last_key, max_val = print_key(last_key, key, max_val, val)
    except ValueError:                                         # this exception for situations like Omaha 12.2Piano 49.1
        two_rows = line.strip().split(",")
        key1 = two_rows[0]
        start_k_2 = re.search(r'[A-z ]+', two_rows[1]).start()
        val1 = two_rows[1][:start_k_2]
        key2 = two_rows[1][start_k_2:]
        val2 = two_rows[2]
        last_key, max_val = print_key(last_key, key1, max_val, val1)
        last_key, max_val = print_key(last_key, key2, max_val, val2)
    except Exception:
        print('some error, not ValueError')
print("%s\t%s" % (last_key, max_val))
