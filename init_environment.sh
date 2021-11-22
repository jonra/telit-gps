#!/bin/sh

	printf '%s\n' 'Installing the required packages'
	sudo apt update
	sudo apt -y install minicom python3-pip libqmi-utils udhcpc screen
	
	printf '%s\n' 'Installing the required Python3 libraries'
	pip3 install pyserial paho-mqtt