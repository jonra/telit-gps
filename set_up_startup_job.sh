#!/bin/sh

	printf '%s\n' 'Setting up the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	crontab -l > crontab_current
	cronjob="@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/GNSS_to_MQTT.py >> ${HOME}/telit.log 2>&1"
	printf '%s\n' "$cronjob"
	if ! grep -q "$cronjob" crontab_current; then
		printf '%s\n' "$cronjob" >> crontab_current
		crontab crontab_current
		printf '\n'
	else
		printf '%s\n\n' 'Cron job already exists'
	fi
	rm crontab_current