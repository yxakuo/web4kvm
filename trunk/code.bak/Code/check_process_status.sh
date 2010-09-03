#!/bin/sh

if [ $# -ne 1 ] ; then
	echo "Please enter the ps name"
	exit 2
fi

psnum="$(ps aux | awk '{print $11}' | grep -e "$1" | wc -w)"

if [ $psnum -ge 1 ]; then
		echo "OK, The $1 is running"
		exit 0
fi

if [ $psnum -eq 0 ]; then
		echo "Warning, There is no $1 running"
		exit 
fi


