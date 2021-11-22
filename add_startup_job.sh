#!/bin/sh

	printf '%s\n' 'Adding the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	cronjob="@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/gnss_to_mqtt.py >> ${HOME}/telit.log 2>&1"
	crontab -l > crontab_current
	if ! grep -q "$cronjob" crontab_current; then
		printf '%s\n' "$cronjob" >> crontab_current
		crontab crontab_current
		printf '\n'
	else
		printf '%s\n\n' 'Cron job already exists'
	fi
	rm crontab_current