#!/bin/bash

# creates *a little* network traffic
# the idea is to wake up the network card in case it somehow goes to sleep
# the amount of traffic is so low that this is hopefully not an abuse of these servers (each gets one ping every 10, 20, 30, ... 100 seconds in a loop)

for j in {1..100} ; do
    echo "j = $j"
    for i in {1..100..10} ; do
        echo "i = $i"
        sleep "$i"
        ping -c 1 seznam.cz
        ping -c 1 nic.cz
        ping -c 1 youtube.com
    done
    echo "sleep"
    sleep "$(( RANDOM % 240 ))"
    echo "end of sleep"
done

