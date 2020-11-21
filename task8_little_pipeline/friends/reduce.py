#! /usr/bin/env python


import sys
import time

start_time = time.time()

friends = {}

for line in sys.stdin:
    delim_pos = line.find('->')
    friend = line[:delim_pos].rstrip()
    fs_f = line[delim_pos + 2:].split()
    friends[friend] = fs_f

# careful with dictionary order, u need to have python 3.6+

ind_friend = {}
for ind, friend in enumerate(friends):
    ind_friend[ind] = friend

mutual_f = {}
size = len(ind_friend)

# O(n^4); Intersection s&t: average: O(min(len(s), len(t)), Worst: O(len(s) * len(t))

# f_f - first friend, s_f -second friend
for ind_f_f in ind_friend:
    for ind_s_f in range(ind_f_f + 1, size):
        mutual_f[ind_friend[ind_f_f] + '-' + ind_friend[ind_s_f]] = list(set(friends[ind_friend[ind_f_f]]).intersection(
            friends[ind_friend[ind_s_f]]))
        # mutual_f[ind_friend[ind_f_f] + '-' + ind_friend[ind_s_f]] = \
        #     mutual_f[ind_friend[ind_s_f] + '-' + ind_friend[ind_f_f]] = list(set(friends[ind_friend[ind_f_f]]).
        #                                                                      intersection(friends[ind_friend[ind_s_f]]))
print(mutual_f)

print(" %s seconds of work 6 cores + 16gb" % (time.time() - start_time))

