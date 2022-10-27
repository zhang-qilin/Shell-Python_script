#!/bin/bash

zookeeper_list=zookeeper:2181

create_topic()
{
	./bin/kafka-topics.sh --create --zookeeper $zookeeper_list --topic $1 --partitions $2 --replication-factor $3
}

if [ "$#" -ge "2" ]; then
	create_topic "log.Terminal" $1 $2
	create_topic "log.RawFace" $1 $2
	create_topic "log.Face" $1 $2
	create_topic "log.Licenseplate" $1 $2
	create_topic "log.Cellphone" $1 $2
	create_topic "log.Hotspot" $1 $2
	create_topic "log.Internet" $1 $2
	create_topic "log.Auth" $1 $2
	create_topic "log.Bluetooth" $1 $2
	create_topic "log.Clientsession" $1 $2
	create_topic "log.Devicetrack" $1 $2
	create_topic "base.Device" $1 $2
	create_topic "base.DeviceState" $1 $2
	create_topic "base.InternetBarDevice" $1 $2
	create_topic "base.InternetBarDeviceChannel" $1 $2
	create_topic "base.InternetBarInfo" $1 $2
	create_topic "base.Place" $1 $2
else 
	echo "     ./create_log_topics.sh [partition count: 分区数] [replication factor count: 副本数]"
fi

