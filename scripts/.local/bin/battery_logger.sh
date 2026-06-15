#!/bin/bash
# /home/ateebamateen/dotfiles/scripts/battery_logger.sh

# Prevent multiple instances
LOCKFILE=/tmp/battery_logger.lock
if [ -f "$LOCKFILE" ] && kill -0 $(cat "$LOCKFILE") 2>/dev/null; then
    exit 1
fi
echo $$ > "$LOCKFILE"
trap "rm -f $LOCKFILE" EXIT

LOG="$HOME/BatteryLogs/battery_log_$(date +'%d_%b_%Y_%H.%M').csv"
if [ ! -f "$LOG" ]; then
    echo "timestamp,battery_%,watt_draw_mW,status,cpu_avg_mhz,cpu_bzy_mhz,cpu_busy%,cpu_pkg_watt,top_processes(%CPU)" >> "$LOG"
fi

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")
    WATTS=$(cat /sys/class/power_supply/BAT0/power_now 2>/dev/null || echo "N/A")
    STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "N/A")
    PROCS=$(ps -eo pid,comm,%cpu --sort=-%cpu --cols=200 | awk 'NR>1 && NR<=11 && $3>0 {printf "%s(%s):%s%% ", $1,$2,$3}')

    CPU_DATA=$(sudo turbostat -q -n 1 -i 30 -s Avg_MHz,Bzy_MHz,Busy%,PkgWatt 2>/dev/null \
        | awk 'NR>1 && /^[0-9]/ {avg+=$1; bzy+=$2; busy+=$3; watt+=$4; count++}
               END {if(count>0) printf "%.0f,%.0f,%.1f,%.2f", avg/count, bzy/count, busy/count, watt/count
                    else print "N/A,N/A,N/A,N/A"}')

    echo "$TIMESTAMP,$BATTERY,$WATTS,$STATUS,$CPU_DATA,\"$PROCS\"" >> "$LOG"
    sleep 30
done