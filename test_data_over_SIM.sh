#!/bin/sh

	screen -d -m
	
	sudo ip link set eth0 down
	sleep 10
	
	if ping -q -c 1 -W 1 8.8.8.8 > /dev/null; then
		printf '%s\n' 'Data over SIM is working'
	else
		printf '%s\n' 'Data over SIM is not working'
	fi
	
	sudo ip link set eth0 up