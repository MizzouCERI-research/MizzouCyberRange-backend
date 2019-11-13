#!/bin/bash
# $1 is user name, $2 is slice name

#check to see if there are 2 arguments attached to omni command
if [ "$#" -lt 2 ]
then
    echo -e "Not enough arguments supplied, please provide 2 arguments. Exiting..."
    exit
fi

#check to see if omni command has succeeded or not
function checkErr() {
   # echo -e "$1 failed\". Exiting...">&2; exit;
    echo -e "{\"status\":\"fail\"}">&2; exit;
        
}

omni createslice $2 ||  checkErr "creating slice"
omni addslicemember $2 $1 MEMBER  ||  checkErr "adding slice member"
