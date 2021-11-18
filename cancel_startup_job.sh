#!/bin/sh

	printf '%s\n' 'Cancelling the cron job for script automation'
	. ./stop_gnss_stream.sh >> ${HOME}/telit.log 2>&1
	crontab -l > crontab_current
	grep -v 'start_gnss_stream.sh' crontab_current > tmpfile
	mv tmpfile crontab_current
	crontab crontab_current
	rm crontab_current
	
	printf 's\n\n' 'Stopping GNSS_to_MQTT.py'
	$(ps -ef | grep 'GNSS_to_MQTT.py' | grep -v grep | awk '/[G]NSS_to_MQTT.py/{print $2}' | xargs kill)
	