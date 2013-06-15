#!/usr/bin/python

import string

n = 123
step = 0
nums = [str(n)]

while n != 1:
    print "Step: %d -> %d" % (step, n)
    if n % 2 == 0:
        n = n / 2
    else:
        n = 3 * n + 1
    nums.append(str(n))
    step = step + 1

print "Step: %d -> %d" % (step, n)

print string.join(nums, ", ")
