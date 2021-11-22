#!/bin/sh

	sudo ip link set eth0 down
	sleep 5
	
	wget -q --spider http://google.com

	if [ $? -eq 0 ]; then
		
	else
		sudo ip link set eth0 up
	fi