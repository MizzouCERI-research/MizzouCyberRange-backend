#!/bin/bash

#Written by Andrew Krall, 11-08-2018
#Revised by Songjie Wang on 07-11-2019
#This script will perform the configuration of the root switch for the DDoS Lab 2.

#Color declarations
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color

#Send the IP address of the controller as a parameter.

#Ignore the weird spacing. I promise it looks good when it's echoed out to the screen.
echo -e ${LIGHTBLUE}"#################################################################"
echo "# DDoS Lab 2 Root Switch Installation and Configuration Script  #"
echo "#                                                               #"
echo -e "# ${LIGHTGREEN}Syntax: sudo ./root_switch_install.sh controller_ip${LIGHTBLUE}           #"
echo "#                                                               #"
echo "# This script will take in the IP address of the controller as  #"
echo "# an argument. It will install all of the required software     #"
echo "# packages for the root switch, and ensure that it              #"
echo "# is configured properly.                                       #"
echo -e "#################################################################"${NC}
echo "" #Acts as a newline by outputting nothing.

#Check to see if the script is run as root/sudo. If not, warn the user and exit.
if [[ $EUID -ne 0 ]] ; then
    echo -e "${RED}This script needs to be run as root. Please run this script again as root. Exiting.${NC}"
    exit
fi

#Check to see if an argument has been supplied. If not, exit the script.
if [ -z "$1" ] ; then
    echo -e "${RED}No arguments supplied. Please supply the IP address of the controller as an argument. Exiting.${NC}"
    exit
fi

function checkErr() {
    echo -e "${RED}$1 failed. Exiting.${NC}" >&2; exit;
}

#This function tests to see if an IP address is valid or not.
#Taken from https://www.linuxjournal.com/content/validating-ip-address-bash-script
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

#Check if IP address is passed as a parameter. 
if ! valid_ip $1 ; then
    echo -e "${RED}You entered an invalid IP address. Please enter a valid IP address as the first parameter. Exiting.${NC}"
    exit
else
    ipAddress="$1"
fi

#Configure the controller on bridge b0 for the root switch.
sudo ovs-vsctl set-controller br0 tcp:$ipAddress:6633 || checkErr "Networking configuration"

echo -e "\n${GREEN}Configuration of the root switch has been completed. Please go back to the controller and take note of the DPID number displayed on the switch. It should be a 14-digit number that will be used to identify the root switch later.${NC}"
