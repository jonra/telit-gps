#!/bin/sh

	printf '%s\n' 'Installing minicom and pip3'
	sudo apt -y install minicom python3-pip
	
	printf '%s\n' 'Installing pyserial and paho-mqtt Python3 libraries'
	pip3 install pyserial paho-mqtt