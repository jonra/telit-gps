# Hardware
https://docs.sixfab.com/docs/raspberry-pi-4g-lte-cellular-modem-kit-intoduction

# Software

The program consists of several scripts:

`setup_environment.sh`
Script that sets up the environment and dependencies required for other scripts to function properly. Should be run once before invoking other scripts .

`start_gnss_stream.sh`

Script that sends the required AT commands to the module in order to configure and start the GNSS stream.

`stop_gnss_stream.sh`

Script that sends the required AT commands to the module in order to stop the GNSS stream and reset GNSS parameters and data stored in the module's NVM.

`GNSS_to_MQTT.py`
Python3 script that reads GNSS data from the ttyUSB1 serial port, parses the raw values and publishes the extracted information to the MQTT broker.
