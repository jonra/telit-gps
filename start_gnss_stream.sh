#!/bin/sh

	printf '%s\n' 'Initiating the script that starts the GNSS stream'
	sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n' 'Switching off/on the module and restoring the default GNSS parameters in order to start from known GNSS settings'
	printf '\r%s\r' 'AT$GPSRST' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2

	#printf '%s\n' 'Deleting the GPS information (history buffer) stored in the NVM'
	#printf '\r%s\r' 'AT$GPSNVRAM=15,0' > /dev/ttyUSB2
	#sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n' 'Activating the unsolicited streaming of the GPS NMEA data (RMC sentence only)'
	printf '\r%s\r' 'AT$GPSNMUN=2,0,0,0,0,1,0' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n' 'Powering up the GNSS controller'
	printf '\r%s\r' 'AT$GPSP=1' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2

	printf '%s\n\n' 'Saving the current GNSS parameters to the NVM'
	printf '\r%s\r' 'AT$GPSSAV' > /dev/ttyUSB2
	sleep 5 # 25 is the minimum. Safety factor of 2