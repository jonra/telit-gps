#!/bin/sh

	printf '%s\n' 'Setting up the SIM data connection over QMI interface'
	
	printf '%s\n' 'Checking the compatibility of the module'
	i=0
	while ! lsusb -t | grep -q 'qmi_wwan' && [ $i -lt 5 ]; do
		i=$(expr $i+1)
		printf '\r%s\r' 'AT#USBCFG=0' > /dev/ttyUSB3
		sleep 10
		printf '\r%s\r' 'AT#REBOOT' > /dev/ttyUSB3
		sleep 5
	done
	if [ $i -ge 5 ] ; then
		printf '%s\n\n' "Module doesn't support QMI interface, terminating"
		exit 1
	fi
	
	printf '%s\n' 'Making sure the module is ready'
	if ! sudo qmicli -d /dev/cdc-wdm0 --dms-get-operating-mode | grep -q 'online'; then
		sudo qmicli -d /dev/cdc-wdm0 --dms-set-operating-mode='online'
	fi
	
	printf '%s\n' 'Configuring the network interface for the raw-ip protocol'
	sudo ip link set wwan0 down
	printf '%c\n' 'Y' | sudo tee /sys/class/net/wwan0/qmi/raw_ip > /dev/null
	sudo ip link set wwan0 up
	
	printf '%s\n' 'Connecting to the mobile network'
	# Change the apn='...', or add username='...' and password='...' after apn='...' according to the information provided by your SIM operator
	DIR="$(dirname "$(realpath "$0")")"
	apn=cat ${DIR}/apn_params.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["apn"])'
	un=cat ${DIR}/apn_params.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["username"])'
	pw=cat ${DIR}/apn_params.json | python3 -c 'import json,sys;obj=json.load(sys.stdin);print(obj["password"])'
	params="apn='${apn}'"
	if [ ! -z "$un" ]; then
		params="${params},username='${un}'"
	fi
	if [ ! -z "$pw" ]; then
		params="${params},password='${pw}'"
	fi
	sudo qmicli -p -d /dev/cdc-wdm0 --device-open-net='net-raw-ip|net-no-qos-header' --wds-start-network="${params},ip-type=4" --client-no-release-cid
	
	printf '%s\n' 'Configuring the IP address and the default route'
	sudo udhcpc -q -f -i wwan0
	printf '\n'