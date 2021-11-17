#!/bin/sh

	printf '%s\n' 'Installing required packages'
	sudo apt -y install minicom python3-pip git
	
	printf '%s\n' 'Installing required Python3 libraries'
	pip3 install pyserial paho-mqtt