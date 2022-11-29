#!/usr/bin/env bash
#
# Start the VNC server.
#
echo -e "qqqqqq\nqqqqqq\n" | vnc4server -geometry 800x600 -depth 16
export DISPLAY=:1

websockify --web=/root/novnc/ 8081 localhost:5901 1>/dev/null 2>&1 &
wine start regedit.exe /root/bin/homm3.reg


while :
do
	wine 'Heroes3.exe'
	sleep 2
done
#
# cleanup processes that terminates the container:
#
#kill $(ps | grep -v bash | grep -v grep | grep -v PID | tr -s " " | cut -f2 -d\ )

