# Hardware
https://docs.sixfab.com/docs/raspberry-pi-4g-lte-cellular-modem-kit-intoduction

# Software

The program consists of several scripts:

`init_environment.sh`
Script that sets up the environment and dependencies required for the other scripts to function properly.

`start_gnss_stream.sh`
Script that sends the required AT commands to the Telit module in order to configure and start the GNSS stream.

`stop_gnss_stream.sh`
Script that sends the required AT commands to the module in order to stop the GNSS stream and reset GNSS parameters.

`GNSS_to_MQTT.py`
Python3 script that reads GNSS data from the ttyUSB1 serial port, parses the raw values and publishes the extracted information to the MQTT broker.

`set_up_startup_job.sh`
Script that sets up the cron job which automates script execution on RPi startup for headless GNSS data streaming to the MQTT broker.

`cancel_startup_job.sh`
Script that cancels the cron job so that the scripts are not run on RPi startup.

# How to use

All scripts should be run as current user (without `sudo`). First run the `init_environment.sh` script once when setting up a new Raspberry Pi. Check the MQTT parameters in the `mqtt_params.json` file before proceeding.

### Manual execution:

To start the GNSS data streaming:

1. Run the `start_gnss_stream.sh` script.
2. Run the `GNSS_to_MQTT.py` program with `python3`.

To stop the GNSS data streaming:

1. Stop the execution of `GNSS_to_MQTT.py` with `Ctrl+C`.
2. Run the `stop_gnss_stream.sh` script.

### Automated execution on the Raspberry Pi startup:

To set up the cron job which starts the GNSS data streaming when the RPi is powered up:

1. Run the `set_up_startup_job.sh` script.
1. Restart the RPi for the scripts to start.

To cancel the cron job and stop the automatic execution of the scripts on startup:

1. Run the `cancel_startup_job.sh` script.
1. Restart the RPi to stop the `GNSS_to_MQTT.py` execution.

All the script outputs (stdout and stderr) are logged to `telit.log` file which is located in the RPi user home directory. The log is cleared on restart.
