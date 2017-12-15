#!/usr/bin/python3

"""
The script creates a bit of single-threaded work interleaved with quite a lot of sleep.
"""

import base64, getpass, hashlib, os
import time, random

def com(in_data):
    """performs a few sha calculations just to give some work to do to the cpu"""
    bits = bytes(in_data, "utf8")
    for i in range(2 ** 3):
        bits = hashlib.sha256(bits).digest()
    out_data = base64.b64encode(bits)[:16]
    out_data = str(out_data, "utf8")
    return out_data

def stepped_load_single():
    """does little and then more and more work in increasing steps"""
    for i in range(16):
        print("stepped_load_single i = {}".format(str(i)))
        iters = 2 ** i
        x = "asdf" + str(random.random())
        print("iters = {}".format(str(iters)))
        for j in range(iters):
            x = com(x)
        time.sleep(1)

for i in range(20):
    """makes a bunch of increasing work and then sleeps for a random time"""
    print("i = {}".format(str(i)))
    time.sleep(180.0 * random.random())
    stepped_load_single()


