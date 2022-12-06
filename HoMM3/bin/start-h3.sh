#!/usr/bin/env bash

wine start regedit.exe /home/heroes/bin/homm3.reg

cd /home/heroes/.wine/drive_c/Program\ Files\ \(x86\)/3DO/Heroes\ III\ Demo/

while :
do
	wine 'Heroes3.exe'
	sleep 1
done

