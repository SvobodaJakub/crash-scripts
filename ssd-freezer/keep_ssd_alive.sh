#!/bin/sh

# keeps the ssd alive by forcing it to keep awake
# the reads must be larger that the amount of free RAM so that it still reads from disk and not from cache
# run as root for best results

ORIGDIR="$( pwd )"

sync

function one_run {
    sync # don't want to lose data when it does crash

    for i in {0..260} ; do
        echo "dd $i th GB of /dev/sda ; run number $1"
        # sleep only if dd succeeds
        dd if=/dev/sda of=/dev/null bs=1G count=1 skip="$i" && sleep 0.5
    done

    cd /usr
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    sync # don't want to lose data when it does crash

    cd /var
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    sync # don't want to lose data when it does crash

    cd /home
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    sync # don't want to lose data when it does crash

    echo "done and didn't crash"
}

for j in {1..200000} ; do
    echo "run number $j"
    one_run "$j"
done
