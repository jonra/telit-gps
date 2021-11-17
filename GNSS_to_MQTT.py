#!/usr/bin/python3

from time import sleep
import serial
from paho.mqtt import client as mqtt_client

# Serial params
portread = '/dev/ttyUSB1'
portwrite = '/dev/ttyUSB2'

# MQTT params
broker = 'broker.hivemq.com'
port = 1883
client_id = 'rpi-mqtt-client'
username = 'iaajmmzt'
password = 'JFJyEDIadkIO'
topic = 'testtopic/a6'

def parseGNSSdata(data):
    # print(data, end='') #prints raw data
    if data[0:6] == '$GPRMC':
        sdata = data.split(',')
        if sdata[2] == 'V':
            return 'No satellite data available'
        
        time = sdata[1][0:2] + ":" + sdata[1][2:4] + ":" + sdata[1][4:6]
        lat = decode(sdata[3]) #latitude
        dirLat = sdata[4]      #latitude direction N/S
        lon = decode(sdata[5]) #longitute
        dirLon = sdata[6]      #longitude direction E/W
        speed = sdata[7]       #Speed in knots
        trCourse = sdata[8]    #True course
        date = sdata[9][0:2] + "/" + sdata[9][2:4] + "/" + sdata[9][4:6] #date
        variation = sdata[10]  #variation
        degreeChecksum = sdata[13] #Checksum
        dc = degreeChecksum.split("*")
        degree = dc[0]        #degree
        checksum = dc[1]      #checksum

        latitude = lat.split() # parsing latitude
        longitute = lon.split() # parsing longitute
        
        return 'Latitude: ' + str(int(latitude[0]) + (float(latitude[2])/60)) + dirLat + '\n' + \
               'Longitute: ' + str(int(longitute[0]) + (float(longitute[2])/60)) + dirLon + '\n' + \
               'Time: %s, Lat: %s(%s), Lon: %s(%s), Speed: %s, True course: %s, Date: %s, Magnetic variation: %s(%s), Checksum: %s\n' % (time,lat.replace(' deg', '°').replace(' min', '\''),dirLat,lon.replace(' deg', '°').replace(' min', '\''),dirLon,speed,trCourse,date,variation,degree,checksum)


def decode(coord):
    #Converts DDDMM.MMMMM -> DD deg MM.MMMMM min
    x = coord.split(".")
    head = x[0]
    tail = x[1]
    deg = head[0:-2]
    min = head[-2:]
    return deg + ' deg ' + min + '.' + tail + ' min'

def connect_mqtt(broker, port, client_id, username = None, password = None):
    def on_connect(client, userdata, flags, rc):
        print(f'CONNACK received with code {rc}')
    client = mqtt_client.Client(client_id)
    client.on_connect = on_connect
    client.username_pw_set(username, password)
    client.connect(broker, port)
    return client

def publish_mqtt(client, topic, message):
    ret = client.publish(topic, message)
    return ret[0]

while True:
    try:
        ser = serial.Serial(portread, baudrate = 115200, timeout = 3, rtscts=True, dsrdtr=True)
        break
    except:
        print('Failed to initiate the serial port')
    sleep(5)

while True:
    try:
        cli = connect_mqtt(broker, port, client_id, username, password)
        break
    except:
        print('Failed to connect to the MQTT broker')
    sleep(5)

while True:
    #data = '$GPRMC,182144.00,A,3757.595246,N,01115.606721,E,0.0,0.0,240321,4.0,E,A,V*49'
    data_valid = False
    try:
        ser.reset_input_buffer()
        data = ser.readline().decode('utf-8')
        data_valid = True
    except:
        print('Failed to acquire data from the serial port')
    
    if(data_valid):
        decoded = parseGNSSdata(data)
        print(decoded)
        publish_mqtt(cli, topic, decoded)
        
    # Frequency of reading
    sleep(5)