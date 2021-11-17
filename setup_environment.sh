#!/bin/sh

	printf '%s\n' 'Installing required packages'
	sudo apt -y install minicom python3-pip git

	printf '%s\n' 'Installing required Python3 libraries'
	pip3 install pyserial paho-mqtt

	printf '%s\n\n' 'Setting up the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	printf '%s\n' "@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.sh >> ${HOME}/telit.log 2>&1 && /usr/bin/python3 ${DIR}/GNSS_to_MQTT.py >> ${HOME}/telit.log 2>&1" >> crontab_telit
	crontab crontab_telit
	rm crontab_telit