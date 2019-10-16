#!/bin/bash

#Color declarations
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
LIGHTGREEN='\033[1;32m'
NC='\033[0m' # No Color

function checkErr() {
    echo -e "${RED}$1 failed. Exiting.${NC}" >&2; exit;
}

#Check to see if the script is run as root/sudo. If not, warn the user and exit.
if [[ $EUID -ne 0 ]] ; then
    echo -e "${RED}This script needs to be run as root. Please run this script again as root. Exiting.${NC}"
    exit
fi

# Update the system's available list of packages and their versions.
echo -e "${BLUE}Updating the system's available list of packages...${NC}"
apt-get -y update || checkErr "Package list installation"

echo -e "${GREEN}Packages updated properly!${NC}"

echo -e "${BLUE}\n Updating system. ${NC}"
sudo apt-get update
echo -e "${BLUE}\n Installing essential utilities. ${NC}" || checkErr "Package installation"
sudo apt-get -y install curl vim nano wget
echo -e "${GREEN}The essential utilities were installed properly!${NC}"

echo -e "${BLUE}\n Installing Docker CE. ${NC}"
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common || checkErr "Docker installation"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - || checkErr "Docker installation"
sudo apt-key fingerprint 0EBFCD88 || checkErr "Docker installation"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" || checkErr "Docker installation"
sudo apt-get update || checkErr "Docker installation"
sudo apt-get -y install docker-ce || checkErr "Docker installation"
echo -e "${GREEN}Docker was installed properly.${NC}"
