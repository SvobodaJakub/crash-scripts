#!/bin/sh

# crashes the ssd by performing the usage patterns that crash it - writes, reads, periods of inactivity
# tries to set various APM and spindown values to test whether the ssd crashes in some of these settings
# run as root for best results

ORIGDIR="$( pwd )"

echo "Disable all screensavers and sleep so that the info is always visible!"
echo "Disable tuned so that hdparm settings stick! (run once night with tuned, one night without tuned to cover all combinations of what might happen)"

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

    echo "run number $1 apm=$2 spindown=$3"
    cd "$ORIGDIR"
    echo "reading random data"
    dd if="$ORIGDIR/crash_random_data_tmp" of=/dev/null bs=512
    echo "writing 14G of random data"
    dd if=/dev/urandom of="$ORIGDIR/crash_random_data_tmp" bs=1M count=14000
    sync

    echo "run number $1 apm=$2 spindown=$3"
    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    echo "run number $1 apm=$2 spindown=$3"
    cd /usr
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    echo "run number $1 apm=$2 spindown=$3"
    cd /var
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    echo "run number $1 apm=$2 spindown=$3"
    cd /home
    pwd
    find . -type f -exec cat '{}' '+' > /dev/null

    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    for i in {0..260} ; do
        echo "dd $i th GB of /dev/sda"
        echo "run number $1 apm=$2 spindown=$3"
        dd if=/dev/sda of=/dev/null bs=1G count=1 skip="$i"
    done

    echo "run number $1 apm=$2 spindown=$3"
    echo "sleep for 5 mins"
    sleep 5m
    echo "end of sleep"

    echo "running du"
    cd /
    du >/dev/null 2>/dev/null

    echo "done and didn't crash"
}

for j in {1..100} ; do
    for k in {1..5} ; do
        for l in {1..4} ; do
            # -P 1, 254, 127, 128, 255
            # -S 1, 50, 253, 255
            # that is 20 combinations, times about half an hour == about 10 hours to run all combinations
            apm="1"
            spindown="1"
            # try to cover as much as possible as soon as possible by not simply going from lowest to highest value
            if [[ $k == "1" ]] ; then apm="1" ; fi # max powersaving
            if [[ $k == "2" ]] ; then apm="254" ; fi  # max performance, apm enabled
            if [[ $k == "3" ]] ; then apm="127" ; fi  # allows spindown
            if [[ $k == "4" ]] ; then apm="128" ; fi  # doesn't allow spindown
            if [[ $k == "5" ]] ; then apm="255" ; fi  # apm disabled
            if [[ $l == "1" ]] ; then spindown="1" ; fi # 1*5 seconds
            if [[ $l == "2" ]] ; then spindown="50" ; fi # 50*5 seconds
            if [[ $l == "3" ]] ; then spindown="253" ; fi # 8-12 hours (vendor-defined)
            if [[ $l == "4" ]] ; then spindown="255" ; fi # 21 mins + 15 seconds
            echo "run number $j apm=$apm spindown=$spindown"
            hdparm -B "$apm" -S "$spindown" /dev/sda
            one_run "$j" "$apm" "$spindown"
        done
    done
done
