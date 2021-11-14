#!/usr/bin/bash




	sleep 5 # 25 is the minimum. Safety factor of 2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	sleep 5 # 25 is the minimum. Safety factor of 2
	echo -ne '\rAT$GPSRST\r' > /dev/ttyUSB2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	sleep 5 # 25 is the minimum. Safety factor of 2
	echo -ne '\rAT$GPSNVRAM=15,0\r' > /dev/ttyUSB2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	sleep 5 # 25 is the minimum. Safety factor of 2
	echo -ne '\rAT$GPSACP\r' > /dev/ttyUSB2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	sleep 5 # 25 is the minimum. Safety factor of 2
	echo -ne '\r$GPSACP:\r' > /dev/ttyUSB2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	sleep 5 # 25 is the minimum. Safety factor of 2
	echo -ne '\rAT$GPSNMUN=2,1,1,1,1,1,1\r' > /dev/ttyUSB2
	stty -F /dev/ttyUSB2 115200 raw -echo -echoe -echok -echoctl -echoke 2> /dev/null
	echo -ne '\rAT$GPSP=1\r' > /dev/ttyUSB2
