#!/usr/bin/python3

import serial
from time import time, sleep
from paho.mqtt import client as mqtt_client

# Serial params
portread = '/dev/ttyUSB1'
portwrite = '/dev/ttyUSB2'

# MQTT params
broker = 'hairdresser.cloudmqtt.com'
port = 16350
topic = 'bikemovedevent-topic'
username = 'iaajmmzt'
password = 'JFJyEDIadkIO'

# Fixed data
assetId = 'telit-1'
name = 'Telit1'
description = 'RPI device'
assistLevel = 99
assetType = 'CAR'
isRestricted = False

def parse_GNSS_data(data):
    # print(data, end='') #prints raw data
    if data[0:6] == '$GPRMC':
        sdata = data.split(',')
        if sdata[2] == 'V':
            return
        
        timestamp = str(int(time()*1000))
        lat = decode(sdata[3]) #latitude
        lng = decode(sdata[5]) #longitute
        speed = sdata[7]       #Speed in knots
        
        return '    "speed": "%s",\n    "lat": "%s",\n    "lng": "%s",\n    "timestamp": "%s",\n' % (speed,lat,lng,timestamp)

def decode(coord):
    #Converts DDDMM.MMMMM -> DD.DDDDD
    x = coord.split(".")
    head = x[0]
    tail = x[1]
    deg = int(head[0:-2])
    min = float(head[-2:] + '.' + tail)
    return str(deg + min/60)
    
def create_message(assetId, name, description, gnss_data_decoded, assistLevel, assetType, isRestricted):
    return '{\n    "assetId": "%s",\n    "name": "%s",\n    "description": "%s",\n' % (assetId,name,description) + \
           gnss_data_decoded + \
           '    "assistLevel": %s,\n    "assetType": "%s",\n    "isRestricted": %s\n}' % (str(assistLevel),assetType,str(isRestricted).lower())

def connect_MQTT(broker, port, client_id, username = None, password = None):
    def on_connect(client, userdata, flags, rc):
        print(f'CONNACK received with code {rc}', flush = True)
    client = mqtt_client.Client(client_id)
    client.on_connect = on_connect
    client.username_pw_set(username, password)
    client.connect(broker, port)
    return client

def publish_MQTT(client, topic, message):
    ret = client.publish(topic, message)
    return ret[0]


while True:
    try:
        ser = serial.Serial(portread, baudrate = 115200, timeout = 2, rtscts=True, dsrdtr=True)
        break
    except:
        print('Failed to initialize the serial port, retrying..', flush = True)
    sleep(5)

while True:
    try:
        cli = connect_MQTT(broker, port, assetId, username, password)
        break
    except:
        print('Failed to connect to the MQTT broker, retrying..', flush = True)
    sleep(5)

while True:
    #data = '$GPRMC,182144.00,A,3757.595246,N,01115.606721,E,0.0,0.0,240321,4.0,E,A,V*49'
    data = None
    try:
        ser.reset_input_buffer()
        data = ser.readline().decode('utf-8')
        if data is None:
            print('No data available on the serial port', flush = True)
        else:
            print('data = ' + data)
            decoded = parse_GNSS_data(data)
            if decoded is not None:
                msg = create_message(assetId, name, description, decoded, assistLevel, assetType, isRestricted)
                rc = publish_MQTT(cli, topic, msg)
                if rc == 0:
                    print('\nSuccessfully published the message to the MQTT broker\n' + msg, flush = True)
                else:
                    print('\nCould not publish the message to the MQTT broker', flush = True)
            else:
                print('No satellite data available', flush = True)
    except:
        print('Failed to acquire data from the serial port', flush = True)
    
    # Frequency of reading
    sleep(5)