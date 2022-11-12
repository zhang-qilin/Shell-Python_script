#!/bin/bash

usage()
{
	echo "usage: ./run.sh [start|stop]"	
}

if [ "$#" -lt "1" ]; then
	usage
elif [ "$1" = "start" ]; then
	bin/kafka-server-start.sh -daemon config/server.properties
elif [ "$1" = "stop" ]; then
	bin/kafka-server-stop.sh
else
	usage
fi
