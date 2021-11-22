#!/bin/sh

	sudo ip link set eth0 down
	sleep 10
	
	wget -q --spider https://www.google.com/
	
	if [ $? -eq 0 ]; then
		printf '%s\n' 'Data over SIM is working'
	else
		printf '%s\n' 'Data over SIM is not working'
	fi
	
	sudo ip link set eth0 up