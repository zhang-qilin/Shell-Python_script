#!/bin/bash

zookeeper_list=zookeeper:2181

if [ "$1" = "desc" ]; then
	if [ "$#" -ge "2" ]; then
		./bin/kafka-topics.sh --zookeeper $zookeeper_list --describe --topic $2
	else
		./bin/kafka-topics.sh --zookeeper $zookeeper_list --describe
	fi
elif [ "$1" = "list" ]; then
	./bin/kafka-topics.sh --zookeeper $zookeeper_list --list
elif [ "$1" = "create" -a "$#" -ge "4" ]; then
	./bin/kafka-topics.sh --create --zookeeper $zookeeper_list --topic $2 --partitions $3 --replication-factor $4
elif [ "$1" = "delete" -a "$#" -ge "2" ]; then
	./bin/kafka-topics.sh --delete --zookeeper $zookeeper_list --topic $2 
else 
	echo "usage: ./run_topic.sh [cmd] [...]"
	echo "     ./run_topic.sh list"
	echo "     ./run_topic.sh desc"
	echo "     ./run_topic.sh desc [topic name, 多个topic以逗号分隔]"
	echo "     ./run_topic.sh create [topic name] [partition count] [replication factor count]"
	echo "     ./run_topic.sh delete [topic name, 多个topic以逗号分隔]"
fi

