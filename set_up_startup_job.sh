#!/bin/sh

	printf '%s\n\n' 'Setting up the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	if ! grep -q 'start_gnss_stream.py' crontab_telit; then
		printf '%s\n' "@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/GNSS_to_MQTT.py >> ${HOME}/telit.log 2>&1" >> crontab_telit
		crontab crontab_telit
	fi
	rm crontab_telit