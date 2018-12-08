#!/bin/sh

temp=$(cat temp) 
count=$((temp + 1))
echo "$count" > temp

COUNTER=1

if [ $count = 1 ]; then
	mkdir contents
	while read -r Addresses; do       
		echo "site" $COUNTER
	        echo $Addresses "INIT"	
		wget -O contents/site.$COUNTER $Addresses || echo $Addresses "INIT FAILED"
		COUNTER=$[$COUNTER +1]
	done < <(egrep 'http[s]?:\/\/.+$' "$1")
else
	mkdir NEWcontents
	while read -r Addresses; do
		echo "TESTING CHANGES IN SITE" $COUNTER
		wget -O NEWcontents/NEWsite.$COUNTER $Addresses || echo $Addresses "FAILED"
		if diff ./contents/site.$COUNTER ./NEWcontents/NEWsite.$COUNTER >/dev/null ; then
			echo "Nothing new in address : " $Addresses 
		else
			echo "Site updated : " $Addresses 
			echo $Addresses 
			rm -rf contents/site.$COUNTER
			touch contents/site.$COUNTER
			wget -O contents/site.$COUNTER $Addresses || echo $Addresses "UPDATE FAILED"
		fi
		COUNTER=$[$COUNTER +1] 
	done < <(egrep 'http[s]?:\/\/.+$' "$1")
fi

