#!/bin/sh

	printf '%s\n\n' 'Setting up the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	printf '%s\n' "@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.sh && /usr/bin/python3 ${DIR}/GNSS_to_MQTT.py >> 2>&1 ${HOME}/telit.log" >> crontab_telit
	crontab crontab_telit
	rm crontab_telit