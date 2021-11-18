#!/bin/sh

	printf '%s\n' 'Initiating the script that stops the GNSS stream'
	/usr/bin/python3 ./stop_gnss_stream.py >> ${HOME}/telit.log 2>&1
	
	printf '%s\n' 'Cancelling the cron job for script automation'
	crontab -l > crontab_current
	grep -v 'start_gnss_stream.py' crontab_current > tmpfile
	mv tmpfile crontab_current
	crontab crontab_current
	rm crontab_current
	
	printf '%s\n\n' 'Stopping GNSS_to_MQTT.py'
	kill $(ps -ef | grep '[G]NSS_to_MQTT.py' | awk '{print $2}')
	