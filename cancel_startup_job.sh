#!/bin/sh
	
	printf '%s\n' 'Initiating the script that stops the GNSS stream'
	. ./stop_gnss_stream.sh > /dev/null 2>&1
	sleep 5
	
	printf '%s\n\n' 'Cancelling the cron job for script automation'
	crontab -l > crontab_current
	grep -v 'start_gnss_stream.sh' crontab_current > tmpfile
	mv tmpfile crontab_current
	crontab crontab_current
	rm crontab_current