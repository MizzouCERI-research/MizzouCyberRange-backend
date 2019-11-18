    
from datetime import datetime
import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
from random import randint
from time import time
import csv


server_down = randint(20,40)
count = 0
start = 0


def my_response(incomming_packet):
    print incomming_packet.show()
    server_ip = "10.0.0.102"
    global start
    if start == 0:
        start = time()
    current_seconds, current_minutes, current_hours = get_age(start)
    print ("time since attack started: ", current_hours, "h", current_minutes, "m", current_seconds, "s")
    if current_seconds < server_down and current_minutes < 1 and current_hours < 1:
        print ("No more packets should be sent after: ", server_down - current_seconds, "s")
        response_packet_ip = IP(dst=incomming_packet[IP].src, src = server_ip, id=1, ttl=64, proto="icmp", version = 4L, ihl = incomming_packet[IP].ihl, frag = incomming_packet[IP].frag, len = incomming_packet[IP].len)
        response_packet_icmp = ICMP(type=0, code=0, seq=0x0, id=0x0, chksum=0x542b)
        load = "Blah"
        packet = response_packet_ip/response_packet_icmp/load
        send(packet)
        #sendp(Ether()/IP(dst="10.0.0.108",ttl=(1,4)),iface="eth1")
        print packet[IP].dst

    elif (current_seconds >= server_down and current_minutes < 1 and current_hours < 1):
        print ("Tricking the attacker into thinking their attack was successful")

def get_age(start):
        current_time = time()
        difference = current_time - start
        hours = difference // 3600
        difference = difference % 3600
        mins = difference // 60
        seconds = difference % 60
        return int(seconds), int(mins), int(hours)


def main():
    sniff(filter="icmp and src 10.0.0.108", iface="eth1", prn=my_response)
main()

