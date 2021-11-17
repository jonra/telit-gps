#!/bin/sh

	printf '%s\n' 'Installing required packages'
	sudo apt -y install minicom python3-pip git
	
	printf '%s\n' 'Installing required Python3 libraries'
	pip3 install pyserial paho-mqtt
	
	printf '%s\n' 'Setting up cron job'
	TELIT-GPS_DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	printf '%s\n' "@reboot ${TELIT-GPS_DIR}/clear_log.sh && ${TELIT-GPS_DIR}/start_gnss_stream.sh && /usr/bin/python3 ${TELIT-GPS_DIR}/GNSS_to_MQTT.py" >> crontab_telit
	crontab crontab_telit
	rm crontab_telit