#!/bin/bash
# $1 is slice name, $2 is lab module name

aggregate[0]="illinois-ig"
aggregate[1]="cornell-ig"
aggregate[2]="umkc-ig"
aggregate[3]="kansas-ig"

size=${#aggregate[@]}
index=$(($RANDOM % $size))
echo ${aggregate[$index]}

#check to see if there are 2 arguments attached to omni command
if [ "$#" -lt 2 ]; then
    echo -e "Not enough arguments supplied, please provide 2 arguments. Exiting..."
    exit
fi

#check to see if omni command has succeeded or not
function checkErr() {
    #echo -e "$1 failed\". Exiting...">&2; exit;
    echo -e "{\"status\":\"fail\"}">&2; exit;
}

omni -a ${aggregate[$index]} createsliver $1 /data/rspecs/CyberRange_$2_rspec_${aggregate[$index]}.xml || checkErr "create sliver "
