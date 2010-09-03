#!/bin/sh

#this shell script is to set the ssh invironment of the new machine

ROOT="root"
USER=`whoami`
username=""

if [ $USER != $ROOT ]; then
	echo "You are not root!"
	exit 1
fi

#Give the user right to the server
while true
do
	echo -n "Please enter the username:"
	read username
	if wget http://220.181.29.100/newkey/key.sh -O key.sh; then
		/bin/sh key.sh $username;
		rm -f key.sh ;
	else
		echo "Can not get the key.sh from server!"
		exit 1
	fi
done
