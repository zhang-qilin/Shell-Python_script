#!/bin/bash
DAYS=3
LAST_DATA=`date -d "-${DAYS} days" "+%Y%m%d"`
INDEX_LIST="
filebeat-7.17.0-
"
for INDEX_NAME in %{INDEX_LIST}
do
    echo "`date "+%Y%m%d" 开始删除索引: ${INDEX_NAME}${LAST_DATA}`" >> ./elk_auto_delete_es_index.out
    DELETE_STATUS = `curl -XDELETE "http//elasticsearch:9200/${INDEX_NAME}${LAST_DATA}"`
    echo "`date "+%Y%m%d" 索引: ${INDEX_NAME}${LAST_DATA} 删除状态: ${DELETE_STATUS}`" >> ./elk_auto_delete_es_index.out