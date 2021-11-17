#!/bin/sh

	printf '%s\n' 'Starting the stop_gnss_stream.sh script'
	sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n' 'Switching off/on the module and restoring the default GNSS parameters'
	printf '\r%s\r' 'AT$GPSRST' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2

	#printf '%s\n' 'Deleting the GPS information (history buffer) stored in the NVM'
	#printf '\r%s\r' 'AT$GPSNVRAM=15,0' > /dev/ttyUSB2
	#sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n' 'Saving the current GNSS parameters to the NVM'
	printf '\r%s\r' 'AT$GPSSAV' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2