#!/bin/sh

	printf '%s\n' 'Stopping GNSS_to_MQTT.py'
	kill $(ps -ef | grep '[G]NSS_to_MQTT.py' | awk '{print $2}') 2> /dev/null

	printf '%s\n' 'Initiating the script that stops the GNSS stream'
	./stop_gnss_stream.py >> "${HOME}/telit.log" 2>&1

	printf '%s\n' 'Cancelling the cron job for script automation'
	DIR="$(dirname "$(realpath "$0")")"
	cronjob="@reboot sleep 10 && ${DIR}/clear_log.sh && ${DIR}/start_gnss_stream.py >> ${HOME}/telit.log 2>&1 && ${DIR}/GNSS_to_MQTT.py >> ${HOME}/telit.log 2>&1"
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