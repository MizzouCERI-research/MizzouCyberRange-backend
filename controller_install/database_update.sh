#!/bin/bash

#Written by Andrew Krall, 11-02-2018
#Revised by Songjie Wang on 07-11-2019
#This script is used to install and configure AdminUI on the controller for the DDoS Lab 2.

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

#Check to see if an argument has been supplied. If not, exit the script.
if [ -z "$2" ] ; then
    echo -e "${RED}Incorrect number of arguments supplied. Please supply the DPID numbers of the root switch and the slave switch as arguments. Exiting.${NC}"
    exit
fi

regex='^[0-9]+$'

if ! { [[ "$1" =~ $regex ]] && [[ "$2" =~ $regex ]]; } ; then
    echo -e "${RED}One or multiple of the DPID numbers you entered was not an integer. Please ensure both DPID numbers are integers when entering them as arguments. Exiting.${NC}"
    exit
fi

rootDPID=$1
slaveDPID=$2

#Change the DPID numbers for the first three instances of switchID to the root switch's DPID number.
awk -v rootDPID="$rootDPID" 'BEGIN {matches=0}
     matches < 3 && /.*switchID.*/ { sub(/switchID=.[0-9]+./,"switchID=\""rootDPID"\""); matches++ }
     { print $0 }' /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py > /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py.1

#Change the DPID numbers for the next six instances of switchID to the slave switch's DPID number.
awk -v slaveDPID="$slaveDPID" 'BEGIN {matches=0}
    matches >= 3 && matches < 9 && /.*switchID.*/ { sub(/switchID=.[0-9]+./,"switchID=\""slaveDPID"\"") }
    /.*switchID.*/ { matches++ }
    { print $0 }' /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py.1 > /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py

#Now, change the root switch's DPID number in the Switches objects array.
awk -v rootDPID="$rootDPID" ' /.*root-switch.*/ { sub(/switchID=.[0-9]+./,"switchID=\""rootDPID"\"")}
     { print $0 }' /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py > /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py.1

#Do the same for the slave switch's DPID number.
awk -v slaveDPID="$slaveDPID" ' /.*slave-switch.*/ { sub(/switchID=.[0-9]+./,"switchID=\""slaveDPID"\"")}
     { print $0 }' /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py.1 > /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py

rm -f /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py.1

python /var/www/public_html/Dolus_DDos/app/Python/defaultDataInsertion.py || checkErr "Running app/Python/defaultDataInsertion.py"
echo -e "${GREEN}The AdminUI webpage has been configured properly!"

echo -e "\n${GREEN}The AdminUI installation has been completed!"
echo -e "You can now complete the rest of the lab!${NC}"
