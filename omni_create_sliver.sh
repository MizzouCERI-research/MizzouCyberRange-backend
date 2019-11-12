#!/bin/bash
# $1 is slice name, 
# $2 is lab module name
# $3 is user_id
# $4 is module id

aggregate[0]="illinois-ig"
aggregate[1]="cornell-ig"
aggregate[2]="umkc-ig"
aggregate[3]="kansas-ig"

size=${#aggregate[@]}
index=$(($RANDOM % $size))
echo ${aggregate[$index]}

#check to see if there are 2 arguments attached to omni command
if [ "$#" -lt 4 ]
then
    echo -e "Not enough arguments supplied, please provide 3 arguments. Exiting..."
    exit
fi

#check to see if omni command has succeeded or not
function checkErr() {
   # echo -e "$1 failed\". Exiting...">&2; exit;
    echo -e "{\"status\":\"fail\"} at $1 ">&2; exit 1;
}

output=$(sudo omni -a ${aggregate[$index]} createsliver $1 /data/rspecs/CyberRange_$2_${aggregate[$index]}.xml 2>&1) && grep Failed <<< "$output"
echo $output
echo $?

if [ $? -eq 1 ]; then
   ## update database from here
   source ../db_credential
   user_id=$3
   slice_name=$1
   module_id=$4
   sh_name="create sliver"

   echo $user_id
   echo $slice_name
   echo $module_id
   echo $sh_name

   mysql -u$USERNAME -p$PASSWORD -h$SERVER cyberrange -e "INSERT INTO `geni_output` (`slice_name`,`output`,`status`,`user_id`,`module_id`,`sh_name`) VALUES($1,$output,'Success',$user_id,$module_id,'create sliver');" || checkErr "Sql success update"
   echo "database updated with successful status..."

else 
   ## update database from here
   source ../db_credential
   user_id=$3
   slice_name=$1
   module_id=$4
   sh_name="create sliver"

   echo $user_id
   echo $slice_name
   echo $module_id
   echo $sh_name


   mysql -u$USERNAME -p$PASSWORD -h$SERVER cyberrange -e "INSERT INTO `geni_output` (`slice_name`,`output`,`status`,`user_id`,`module_id`,`sh_name`) VALUES($1,$output,'Failed',$user_id,$module_id,'create sliver');" || checkErr "Sql failed update"

   echo "database updated with fail status..."
fi
