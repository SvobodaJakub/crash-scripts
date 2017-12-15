#!/bin/sh

# crashes the ssd by performing the usage patterns that crash it - writes, reads, periods of inactivity
# run as root for best results

ORIGDIR="$( pwd )"

echo "Disable all screensavers and sleep so that the info is always visible!"

( xfce4-terminal -e "watch -n0 'date ; uptime ; sensors ; iotop -b -n1 -d0.1 | head -n 2 ; dmesg | tail -n 15'" ||  gnome-terminal -e "watch -n0 'date ; uptime ; sensors ; iotop -b -n1 -d0.1 | head -n 2 ; dmesg | tail -n 15'"  ) &

sleep 3
sync # don't want to lose data when it does crash
echo "writing random data"
cd "$ORIGDIR"
dd if=/dev/urandom of="$ORIGDIR/crash_random_data_tmp" bs=1M count=14000
sync

function one_run {
    sleep 3
    sync # don't want to lose data when it does crash

    cd "$ORIGDIR"
    echo "reading random data"
    dd if="$ORIGDIR/crash_random_data_tmp" of=/dev/null bs=512
    echo "writing 14G of random data"
    dd if=/dev/urandom of="$ORIGDIR/crash_random_data_tmp" bs=1M count=14000
    sync

    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    cd /usr
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    cd /var
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    cd /home
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    for i in {0..260} ; do
        echo "dd $i th GB of /dev/sda ; run number $1"
        dd if=/dev/sda of=/dev/null bs=1G count=1 skip="$i"
    done

    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    echo "running du"
    cd /
    du >/dev/null 2>/dev/null

    echo "done and didn't crash"
}

for j in {1..2000} ; do
    echo "run number $j"
    one_run "$j"
done
