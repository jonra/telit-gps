#!/bin/sh

	sudo ip link set eth0 down
	sleep 10
	
	wget -q --spider http://google.com

	if [ ! $? -eq 0 ]; then
		sudo ip link set eth0 up
	fi