#!/bin/bash

usage()
{
	echo "usage: ./run.sh [start|stop]"	
}

if [ "$#" -lt "1" ]; then
	usage
elif [ "$1" = "start" ]; then
	./bin/zookeeper-server-start.sh ./config/zookeeper.properties
elif [ "$1" = "stop" ]; then
	./bin/zookeeper-server-stop.sh config/zookeeper.properties
else
	usage
fi
