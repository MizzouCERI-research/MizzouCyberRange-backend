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

echo -e "${GREEN}Running controller docker container.${NC}"
sudo docker pull wangso/controller || checkErr "controller image pulling"
sudo docker run -dit --cap-add=NET_ADMIN -p 80:80 -p 6633:6633 -p 3306:3306 -p 33060:33060 wangso/controller  || checkErr "starting controller container"
echo -e "${GREEN}controller container started.${NC}"
