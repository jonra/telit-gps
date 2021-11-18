#!/usr/bin/env python3

import serial
from time import sleep

port = '/dev/ttyUSB2'

print('Initiating the script that starts the GNSS stream')
sleep(1)

print('Initializing the serial port', flush = True)
sleep(1)
while True:
    try:
        ser = serial.Serial(port, baudrate = 115200, timeout = 2, rtscts=True, dsrdtr=True)
        break
    except:
        print('Failed to initialize the serial port, retrying..', flush = True)
    sleep(5)

at_commands = {'AT$GPSRST': 'Switching off/on the module and restoring the default GNSS parameters',
               'AT$GPSNMUN=2,0,0,0,0,1,0': 'Activating the unsolicited streaming of the GPS NMEA data (RMC sentence only)',
               'AT$GPSP=1': 'Powering up the GNSS controller',
               'AT$GPSSAV': 'Saving the current GNSS parameters to the NVM'}

for cmd in at_commands:
    if ser.in_waiting > 0:
        ser.reset_input_buffer()
    print(at_commands[cmd], flush = True)
    while True:
        try:
            ser.write(('\r'+cmd+'\r').encode())
            sleep(5) # 2.5 is the minimum. Safety factor of 2
            response = ser.read(ser.in_waiting).decode('utf-8')
            if 'OK' in response and 'ERROR' not in response:
                break
        except:
            print('Failed to send the AT command ' + cmd + ' to the serial port, retrying..', flush = True)
print()