#!/bin/bash

#Written by Andrew Krall, 11-08-2018
#Revised by Songjie Wang on 07-11-2019
#This script will perform the configuration of the slave switch for the DDoS Lab 2.

#Color declarations
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color

#Ignore the weird spacing. I promise it looks good when it's echoed out to the screen.
echo -e ${LIGHTBLUE}"##################################################################"
echo "# DDoS Lab 2 Slave Switch Installation and Configuration Script  #"
echo "#                                                                #"
echo -e "# ${LIGHTGREEN}Syntax: sudo ./root_switch_install.sh controller_ip${LIGHTBLUE}            #"
echo "#                                                                #"
echo "# This script will take in the IP address of the controller as   #"
echo "# an argument. It will install all of the required software      #"
echo "# packages for the root switch, and ensure that it               #"
echo "# is configured properly.                                        #"
echo -e "##################################################################"${NC}
echo "" #Acts as a newline by outputting nothing.

#Check to see if the script is run as root/sudo. If not, warn the user and exit.
if [[ $EUID -ne 0 ]] ; then
    echo -e "${RED}This script needs to be run as root. Please run this script again as root. Exiting.${NC}"
    exit
fi

function checkErr() {
    echo -e "${RED}$1 failed. Exiting.${NC}" >&2; exit;
}

#Update the package lists on the slave switch.
echo -e "${BLUE}Updating the package lists on the slave switch.${NC}"
sudo apt-get update

#Check to see if the package lists were updated properly.
if [[ $? != 0 ]] ; then
    echo -e "${RED}The package lists were not installed properly. Exiting.${NC}"
    exit
else
    echo -e "${GREEN}Packages updated properly!${NC}"
fi

#Set Wireshark to not prompt user to choose if a non-root user should capture packets or not during installation, and
# install Tshark to capture the OpenFlow packets.
echo -e "\n${BLUE}Configuring Tshark preinstallation and installing Tshark...${NC}"
sudo apt-get -y install debconf-utils
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install tshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure wireshark-common || checkErr "Wireshark preinstallation configuration"
echo -e "${GREEN}Tshark was installed properly!${NC}"

#install mysql and bwm
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server || checkErr "MySql install"
echo -e "${GREEN} MySql was installed properly!${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python-mysql.connector || checkErr "python-mysql.connector install"  
echo -e "${GREEN} python-mysql.connector was installed properly!${NC}"
sudo apt-get -y install bwm-ng || checkErr "bwm-ng "
echo -e "${GREEN} bwm-ng was installed properly!${NC}"

#Install openvswitch-switch
echo -e "${BLUE}\nInstalling openvswitch...${NC}"
sudo apt-get install -y openvswitch-switch tshark

#Check to see if Tshark was installed properly.
if [[ $? != 0 ]] ; then
    echo -e "${RED}The package openvswitch was not installed properly. Exiting.${NC}"
    exit
else
    echo -e "${GREEN}The package openvswitch was installed successfully!"
fi

#Configure the network bridge on the slave switch.
echo -e "${BLUE}\nConfiguring the network bridge on the slave switch.${NC}"
#Create the bridge b0.
sudo ovs-vsctl add-br br0 || checkErr "Networking configuration"
#Activate the network interfaces connected to the slave switch, and add the network interface ports to b0.
sudo ifconfig eth1 0
sudo ifconfig eth2 0
sudo ifconfig eth3 0
sudo ifconfig eth4 0
sudo ifconfig eth5 0
sudo ifconfig eth6 0
sudo ifconfig eth7 0
sudo ovs-vsctl add-port br0 eth1
sudo ovs-vsctl add-port br0 eth2
sudo ovs-vsctl add-port br0 eth3
sudo ovs-vsctl add-port br0 eth4
sudo ovs-vsctl add-port br0 eth5
sudo ovs-vsctl add-port br0 eth6
sudo ovs-vsctl add-port br0 eth7
echo -e "\n${GREEN}Network bridge configuration successful!${NC}"

echo -e "\n${GREEN}Slave switch library install completed, please set controller with the controller's IP address.${NC}"
