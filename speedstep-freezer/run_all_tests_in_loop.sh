#!/bin/bash

# Runs various types of load and periods of inactivity to try to trigger bugs that might lie in buggy handling of {cpu frequency scaling, heavy load, light load, light load with spikes, device powersaving}.

echo "WARNING: This script might kill innocent processes if you ctrl+c it because it is quick & dirty. Save all your work and restart the system after you are done testing. Ctrl+C now to exit safely or Enter to continue."
read || exit 1


# function called by trap
trap_quit() {
    # hoping that these PIDs are not used by other processes in the meantime...
    echo "killing..."
    kill -9 ${pid_bash_increasing_ping} ${pid_python3_light_spotty_load} ${pid_python3_light_spotty_load2} ${pid_python3_light_spotty_load3} ${pid_python3_light_spotty_load4} ${pid_python3_light_spotty_load5} ${pid_python3_light_spotty_load6} 
    kill -9 ${pid_bash_increasing_ping} ${pid_bash_loopback_flood_ping} ${pid_python3_increasing_load} ${pid_python3_increasing_load2} ${pid_python3_increasing_load3} ${pid_python3_increasing_load4} ${pid_python3_increasing_load5} ${pid_python3_increasing_load6}
    exit 0
}

trap 'trap_quit' SIGINT


bash increasing_ping.sh &
pid_bash_increasing_ping="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load2="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load3="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load4="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load5="$!"

python3 light_spotty_load.py &
pid_python3_light_spotty_load6="$!"


echo sleeping for 5 minutes

sleep 5m

echo killing
kill ${pid_bash_increasing_ping} ${pid_python3_light_spotty_load} ${pid_python3_light_spotty_load2} ${pid_python3_light_spotty_load3} ${pid_python3_light_spotty_load4} ${pid_python3_light_spotty_load5} ${pid_python3_light_spotty_load6} 
kill ${pid_bash_increasing_ping} ${pid_python3_light_spotty_load} ${pid_python3_light_spotty_load2} ${pid_python3_light_spotty_load3} ${pid_python3_light_spotty_load4} ${pid_python3_light_spotty_load5} ${pid_python3_light_spotty_load6} 
kill -9 ${pid_bash_increasing_ping} ${pid_python3_light_spotty_load} ${pid_python3_light_spotty_load2} ${pid_python3_light_spotty_load3} ${pid_python3_light_spotty_load4} ${pid_python3_light_spotty_load5} ${pid_python3_light_spotty_load6} 


bash increasing_ping.sh &
pid_bash_increasing_ping="$!"

bash loopback_flood_ping.sh &
pid_bash_loopback_flood_ping="$!"

python3 increasing_load.py &
pid_python3_increasing_load="$!"

python3 increasing_load.py &
pid_python3_increasing_load2="$!"

python3 increasing_load.py &
pid_python3_increasing_load3="$!"

python3 increasing_load.py &
pid_python3_increasing_load4="$!"

python3 increasing_load.py &
pid_python3_increasing_load5="$!"

python3 increasing_load.py &
pid_python3_increasing_load6="$!"

echo sleeping for 5 minutes

sleep 5m

echo killing
kill ${pid_bash_increasing_ping} ${pid_bash_loopback_flood_ping} ${pid_python3_increasing_load} ${pid_python3_increasing_load2} ${pid_python3_increasing_load3} ${pid_python3_increasing_load4} ${pid_python3_increasing_load5} ${pid_python3_increasing_load6}
kill ${pid_bash_increasing_ping} ${pid_bash_loopback_flood_ping} ${pid_python3_increasing_load} ${pid_python3_increasing_load2} ${pid_python3_increasing_load3} ${pid_python3_increasing_load4} ${pid_python3_increasing_load5} ${pid_python3_increasing_load6}
kill -9 ${pid_bash_increasing_ping} ${pid_bash_loopback_flood_ping} ${pid_python3_increasing_load} ${pid_python3_increasing_load2} ${pid_python3_increasing_load3} ${pid_python3_increasing_load4} ${pid_python3_increasing_load5} ${pid_python3_increasing_load6}

echo end
