#!/bin/sh

	printf '%s\n' 'Initiating the script that starts the GNSS stream'
	sleep 5 # 2.5 is the minimum. Safety factor of 2

	printf '%s\n' 'Switching off/on the module and restoring the default GNSS parameters in order to start from known GNSS settings'
	printf '\r%s\r' 'AT$GPSRST' > /dev/ttyUSB2
	sleep 5 # 2.5 is the minimum. Safety factor of 2
	cnt=0
	while read -r line < /dev/ttyUSB2; do
		hex=$(hexdump -e '"%X"' <<< "${line}")
		printf '%s\n' "${hex}"
		if [ "${line}" = "OK\r\n" ]; then
			break
		elif [ "${line}" = "ERROR\r\n" ]; then
			printf '\r%s\r' 'AT$GPSRST' > /dev/ttyUSB2
			sleep 5 # 2.5 is the minimum. Safety factor of 2
		else
			cnt=$((${cnt} + 1))
			if [ ${cnt} = 10 ]; then
				printf '%s\n\n' 'Telit module not responding'
				exit 1
			fi
			continue
		fi
	done

	#printf '%s\n' 'Deleting the GPS information (history buffer) stored in the NVM'
	#printf '\r%s\r' 'AT$GPSNVRAM=15,0' > /dev/ttyUSB2
	#sleep 5 # 2.5 is the minimum. Safety factor of 2

	printf '%s\n' 'Activating the unsolicited streaming of the GPS NMEA data (RMC sentence only)'
	printf '\r%s\r' 'AT$GPSNMUN=2,0,0,0,0,1,0' > /dev/ttyUSB2
	sleep 5 # 2.5 is the minimum. Safety factor of 2
	cnt=0
	while read -r line < /dev/ttyUSB2; do
		if [ "${line}" = "OK\r\n" ]; then
			break
		elif [ "${line}" = "ERROR\r\n" ]; then
			printf '\r%s\r' 'AT$GPSNMUN=2,0,0,0,0,1,0' > /dev/ttyUSB2
			sleep 5 # 2.5 is the minimum. Safety factor of 2
		else
			cnt=$((${cnt} + 1))
			if [ ${cnt} = 10 ]; then
				printf '%s\n\n' 'Telit module not responding'
				exit 1
			fi
			continue
		fi
	done

	printf '%s\n' 'Powering up the GNSS controller'
	printf '\r%s\r' 'AT$GPSP=1' > /dev/ttyUSB2
	sleep 5 # 2.5 is the minimum. Safety factor of 2
	cnt=0
	while read -r line < /dev/ttyUSB2; do
		if [ "${line}" = "OK\r\n" ]; then
			break
		elif [ "${line}" = "ERROR\r\n" ]; then
			printf '\r%s\r' 'AT$GPSP=1' > /dev/ttyUSB2
			sleep 5 # 2.5 is the minimum. Safety factor of 2
		else
			cnt=$((${cnt} + 1))
			if [ ${cnt} = 10 ]; then
				printf '%s\n\n' 'Telit module not responding'
				exit 1
			fi
			continue
		fi
	done

	printf '%s\n\n' 'Saving the current GNSS parameters to the NVM'
	printf '\r%s\r' 'AT$GPSSAV' > /dev/ttyUSB2
	sleep 5 # 2.5 is the minimum. Safety factor of 2
	cnt=0
	while read -r line < /dev/ttyUSB2; do
		if [ "${line}" = "OK\r\n" ]; then
			break
		elif [ "${line}" = "ERROR\r\n" ]; then
			printf '\r%s\r' 'AT$GPSSAV' > /dev/ttyUSB2
			sleep 5 # 2.5 is the minimum. Safety factor of 2
		else
			cnt=$((${cnt} + 1))
			if [ ${cnt} = 10 ]; then
				printf '%s\n\n' 'Telit module not responding'
				exit 1
			fi
			continue
		fi
	done
