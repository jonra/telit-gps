#!/bin/sh

	printf '%s\n' 'Setting up the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_telit
	cronjob="@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/GNSS_to_MQTT.py >> ${HOME}/telit.log 2>&1"
	if ! grep -q "$cronjob" crontab_telit; then
		printf '%s\n' "$cronjob" >> crontab_telit
		crontab crontab_telit
		printf '\n'
	else
		printf '%s\n' 'Cron job already exists'
	fi
	rm crontab_telit