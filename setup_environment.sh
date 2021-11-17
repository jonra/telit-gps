#!/bin/sh

	printf '%s\n' 'Installing required packages'
	apt -y install minicom python3-pip git
	
	printf '%s\n' 'Installing required Python3 libraries'
	pip3 install pyserial paho-mqtt
	
	printf '%s\n' 'Setting up telit-gps service'
	sudo cp ./telit-gps.service /etc/systemd/system
	sudo systemctl daemon-reload
	sudo systemctl enable telit-gps.service