# Hardware
https://docs.sixfab.com/docs/raspberry-pi-4g-lte-cellular-modem-kit-intoduction

# Software

The program consists of several scripts:

`init_environment.sh`
Shell script that sets up the environment and dependencies required for the other scripts to function properly.

`set_up_data_over_qmi.sh`
Shell script that sets up a data connection over QMI interface so that RPi can connect to the internet using a SIM card.

`start_gnss_stream.py`
Python3 script that sends the required AT commands to the Telit module in order to configure and start the GNSS stream.

`stop_gnss_stream.py`
Python3 script that sends the required AT commands to the module in order to stop the GNSS stream and reset GNSS parameters.

`gnss_to_mqtt.py`
Python3 script that reads GNSS data from the ttyUSB1 serial port, parses the raw values and publishes the extracted information to the MQTT broker.

`add_startup_job.sh`
Shell script that sets up the cron job which automates script execution on RPi startup for headless GNSS data streaming to the MQTT broker.

`remove_startup_job.sh`
Shell script that cancels the cron job so that the scripts are not run on RPi startup and stops GNSS data streaming.

`clear_log.sh`
Helper script which clears the `telit.log` file located in the RPi user home directory.

# How to use

All the scripts should be run as current user (without `sudo`). There is no need to invoke `sh` or `python3` when running them, since they all contain the appropriate shebang (`#!/bin/sh` for shell scripts and `#!/usr/bin/env python3` for Python3 scripts).

### Setting up a new RPi:

To set up a new RPi environment for GNSS data streaming:

1. Run the `init_environment.sh` script.
2. Check the APN parameters in the `apn_params.json` file (currently set to T-Mobile Internet) and after that run the `set_up_data_over_qmi.sh` script.
3. Check the MQTT parameters in the `mqtt_params.json` file and device parameters in the `device_params.json` file before proceeding. 

### Manual execution:

To start the GNSS data streaming:

1. Run the `start_gnss_stream.py` script.
2. Run the `gnss_to_mqtt.py` script.

To stop the GNSS data streaming:

1. Stop the execution of `gnss_to_mqtt.py` with `Ctrl+C`.
2. Run the `stop_gnss_stream.py` script.

### Automated execution on the Raspberry Pi startup:

To set up the cron job which starts the GNSS data streaming when the RPi is powered up:

1. Run the `add_startup_job.sh` script.
1. Restart the RPi for the scripts to start executing.

To cancel the cron job and stop GNSS data streaming:

1. Run the `remove_startup_job.sh` script.

In the automated execution mode, all the script outputs (stdout and stderr) are logged to `telit.log` file which is located in the RPi user home directory. The log is cleared on restart.
