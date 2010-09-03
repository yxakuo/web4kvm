#!/bin/sh
if [ $# -ne 1 ];then
	echo "Usage: $0 -p portnum"
	exit 2
fi

exist=$(netstat -lntp | grep -c $1)

if [ $exist -eq 1 ];then
	echo "OK - port $1 is connected"
	exit 0
else
	echo "Warning - port $1 connection refused"
	exit 1
fi
