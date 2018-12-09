#!/bin/sh

mkdir repos
tar -xf "$1" -C repos 

find ./repos -type f -name "*.txt" -exec grep -ri -m1 'https://' {} \; | cat > repositories

mkdir assignments
flag=0

while read line; do  
	cd ~/Desktop/assignments 
	git clone --quiet $line && echo $line ": Cloning OK" || echo $line": Cloning FAILED"
done <repositories

cd ~/Desktop/assignments
for d in */ ;do
	echo "$d"
	res1=$(find ./ -mindepth 2 -maxdepth 2 -type d | wc -l)
	res1=$[$res1 -1]
	res2=$(find ./ -maxdepth 2 -type f -name "*.txt" | wc -l)
	res3=$(find ./ -maxdepth 3 -type f ! -name "*.txt" | wc -l)
	res3=$[$res3 -5]
	echo "Number of directories: "$res1
	echo "Number of txt files: " $res2 
	echo "Number of other files: " $res3
	for d in */ ;do
		res4=$(find ./ -mindepth 3 -maxdepth 3 -type f -name "*.txt" | wc -l)
	done
	res4=$[$res4 -5]
	if [ $res1 = 1 ] && [ $res2 = 3 ] && [ $res3 = 0 ] && [ $res4 = 2 ];then
		echo "Directory structure is OK"
	else
		echo "Directory structure is NOT OK"
	fi
done	

