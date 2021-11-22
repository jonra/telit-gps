#!/bin/sh

	printf '%s\n' 'Stopping gnss_to_mqtt.py'
	kill $(ps -ef | grep '[g]nss_to_mqtt.py' | awk '{print $2}') 2> /dev/null

	printf '%s\n' 'Initiating the script that stops the GNSS stream'
	./stop_gnss_stream.py >> "${HOME}/telit.log" 2>&1

	printf '%s\n' 'Removing the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	cronjob="@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/gnss_to_mqtt.py >> ${HOME}/telit.log 2>&1"
	crontab -l > crontab_current
	if grep -q "$cronjob" crontab_current; then
		grep -v "$cronjob" crontab_current > tmpfile
		mv tmpfile crontab_current
		crontab crontab_current
		printf '\n'
	else
		printf '%s\n\n' 'Cron job not found'
	fi
	rm crontab_current