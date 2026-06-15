#!/usr/bin/env bash
# /home/ateebamateen/.local/bin/lisgd/lisgd-gestures.sh

if [ -z "$NIRI_SOCKET" ]; then
    exit 0
fi
#export NIRI_SOCKET=$(systemctl --user show-environment | grep ^NIRI_SOCKET | cut -d= -f2)

OUTPUT="eDP-1"
DEVICE=/dev/input/by-id/usb-Wacom_Co._Ltd._Pen_and_multitouch_sensor-event-if00

start_lisgd() {
    local o="$1"
    pkill -x lisgd
    sleep 0.5
    lisgd -m 1200 -d "$DEVICE" \
        -g "4,DU,B,*,R,sh -c 'niri msg action open-overview'" \
        -g "4,UD,B,*,R,sh -c 'niri msg action close-overview'" \
        -g "4,UD,T,*,R,sh -c 'niri msg action toggle-overview'" \
        -g "4,UD,N,*,R,sh -c 'niri msg action close-window'" \
        -g "4,DU,N,*,R,sh -c 'niri msg action maximize-window-to-edges'" \
        -g "3,DU,B,*,R,sh -c 'niri msg action focus-workspace-down'" \
        -g "3,UD,T,*,R,sh -c 'niri msg action focus-workspace-up'" \
        -g "3,LR,N,*,R,sh -c 'niri msg action focus-column-left'" \
        -g "3,RL,N,*,R,sh -c 'niri msg action focus-column-right'" \
        -g "2,UD,T,*,R,sh -c 'dms ipc call spotlight toggle'" \
        -g "2,DU,B,*,R,sh -c 'kill -USR2 \$(pgrep -x wvkbd-mobintl)'" \
        -g "2,UD,B,*,R,sh -c 'kill -USR1 \$(pgrep -x wvkbd-mobintl)'" \
        -g "1,LR,L,*,R,sh -c 'niri msg action focus-column-left'" \
        -g "1,RL,R,*,R,sh -c 'niri msg action focus-column-right'"\
        -o "$o" &
}
    
        # -g "1,UD,T,*,R,sh -c 'niri msg action spawn-sh -- \"timeout 10 grim -g \\\"\\\$(slurp)\\\" -t ppm - | satty --filename - --copy-command wl-copy\"'" \
        # -g "1,DU,N,*,R,sh -c 'qs -c ~/shell ipc call topCurtain close'" \
        #   -g "1,DU,T,*,R,sh -c 'qs -c ~/shell ipc call topCurtain close'" \
        #   -g "1,UD,T,*,R,sh -c 'qs -c ~/shell ipc call topCurtain open'" \
        #   -g "1,DU,B,*,R,sh -c 'qs -c ~/shell ipc call bottomDrawer open'" \
        #   -g "1,UD,N,*,R,sh -c 'qs -c ~/shell ipc call bottomDrawer close'" \
        #   -g "1,UD,B,*,R,sh -c 'qs -c ~/shell ipc call bottomDrawer

       
apply_orientation() {
    local niri_transform="$1"
    local lisgd_orient="$2"
    niri msg output "$OUTPUT" transform "$niri_transform"
    start_lisgd "$lisgd_orient"
}

apply_orientation normal 0

last=""
while read -r line; do
    state=""
    case "$line" in
        *"normal"*)    state="normal" ;;
        *"left-up"*)   state="left-up" ;;
        *"right-up"*)  state="right-up" ;;
        *"bottom-up"*) state="bottom-up" ;;
        *) continue ;;
    esac
    [[ "$state" == "$last" ]] && continue
    last="$state"
    case "$state" in
        normal)    apply_orientation normal 0 ;;
        left-up)   apply_orientation 90 3 ;;
        right-up)  apply_orientation 270 2 ;;
        bottom-up) apply_orientation 180 1 ;;
    esac
done < <(monitor-sensor)
