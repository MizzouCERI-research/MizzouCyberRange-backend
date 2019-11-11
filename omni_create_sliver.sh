#!/bin/bash
# $1 is slice name, 
# $2 is lab module name
# $3 is user_id
# $4 is output file


aggregate[0]="illinois-ig"
aggregate[1]="cornell-ig"
aggregate[2]="umkc-ig"
aggregate[3]="kansas-ig"

size=${#aggregate[@]}
index=$(($RANDOM % $size))
echo ${aggregate[$index]}

#check to see if there are 2 arguments attached to omni command
if [ "$#" -lt 2 ]
then
    echo -e "Not enough arguments supplied, please provide 2 arguments. Exiting..."
    exit
fi

#check to see if omni command has succeeded or not
function checkErr() {
   # echo -e "$1 failed\". Exiting...">&2; exit;
    echo -e "{\"status\":\"fail\"}">&2; exit 1;
}

if sudo omni -a ${aggregate[$index]} createsliver $1 /data/rspecs/CyberRange_$2_${aggregate[$index]}.xml output_file 2>&1; then   
   ## update database from here
   source ../db_credential
   user_id = $3
   slice_name =  $1
   module_id = $2
   sh_name = "create sliver"
   output = read -r output_file

   mysql -u$USERNAME -p$PASSWORD -h$SERVER "cyberrange" -e "INSERT INTO `cyberrange`.`geni_output` \
         (`id`,`slice_name`,`output`,`status`,`user_id`,`module_id`,`sh_name`) \
         VALUES (<{id: }>, "$1" , "$output", "success", "$3" , "$2", "create sliver");" \
         || checkErr "Sql update"

else 
   checkErr "create sliver "
      ## update database from here
   source ../db_credential
   user_id = $3
   slice_name =  $1
   module_id = $2
   sh_name = "create sliver"
    
   mysql -u$USERNAME -p$PASSWORD -h$SERVER "cyberrange" -e "INSERT INTO `cyberrange`.`geni_output` \
         (`id`,`slice_name`,`output`,`status`,`user_id`,`module_id`,`sh_name`) \        
         VALUES (<{id: }>, "$1" , "$output", "success", "$3" , "$2", "create sliver");"\
	 || checkErr "Sql update"
fi
