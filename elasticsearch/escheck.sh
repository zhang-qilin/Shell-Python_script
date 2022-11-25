#!/bin/bash

if [ -f /tmp/.escheck ] ; then
    exit 0
fi
source /etc/profile

touch /tmp/.escheck
count=`ps aux | grep elasticsearch-6.6.1 | grep -v grep | wc -l`
if [ $count -eq 0 ] ; then
    cd /opt/elasticsearch-6.6.1/
    ./bin/elasticsearch -d
fi
rm -rf /tmp/.escheck