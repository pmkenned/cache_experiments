#!/usr/bin/env python3

import sys
import time

NROWS = 2000
NCOLS = 2000

def usage():
    sys.stderr.write(f"usage: {sys.argv[0]} DIR [N]\n  DIR  either 'row' or 'col'\n  N  number of iterations\n")
    exit()

if len(sys.argv) < 2:
    usage()

if sys.argv[1] in ["row", "col"]:
    major_dir = "row"
else:
    usage()

niter = int(sys.argv[2]) if len(sys.argv) >= 3 else 1000

matrix = [[None]*NROWS]*NCOLS

x = niter
t0 = time.time()
if major_dir == "row":
    for i in range(0, niter):
        for r in range(0, NROWS):
            for c in range(0, NCOLS):
                matrix[r][c] = x
                x += 1
else:
    for i in range(0, niter):
        for c in range(0, NCOLS):
            for r in range(0, NROWS):
                matrix[r][c] = x
                x += 1
t1 = time.time()

total = t1 - t0
print(f"{total:.2f}")
