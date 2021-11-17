#!/bin/sh

	printf '%s\n' 'Installing required packages'
	sudo apt -y install minicom python3-pip git

	printf '%s\n' 'Installing required Python3 libraries'
	pip3 install pyserial paho-mqtt

	printf '%s\n' 'Setting up cron job'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	printf '%s\n' "@reboot ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.sh && /usr/bin/python3 ${DIR}/GNSS_to_MQTT.py" >> crontab_telit
	crontab crontab_telit
	rm crontab_telit