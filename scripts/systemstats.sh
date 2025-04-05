#!/bin/sh

cputemp=$(sensors | awk '/^Package/ {print $4}' | sed 's/+//;s/\..*$//')
memuse=$(free -m | awk '/^Mem/ {print ($3)/1000}' | cut -c-4)
cpuuse=$(iostat -c | awk 'NR>=4 && NR<=4' | awk '{print "User CPU use: "$1"%\nSystem CPU use:",$3"%"}')


if [[ $cputemp -gt 75 ]]; then color="#bf616a"; elif [[ $cputemp -gt 65 ]]; then color="#ebcd8b"; else color="#a3be8c"; fi

echo " "$cputemp"°C" "  "$memuse"G"

case $BUTTON in
	1) notify-send -h string:bgcolor:$color "$cpuuse";;
	2) setsid -w -f "$TERMINAL" -e btop;;
	3) setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac
