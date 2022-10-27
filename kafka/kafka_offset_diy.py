#!/bin/env python3
from kafka import KafkaAdminClient
from kafka import KafkaConsumer
import threading
import sys



class myThread(threading.Thread):
    def __init__(self, group_id):
        threading.Thread.__init__(self)
        self.group_id = group_id

    def run(self):
        get_lag(self.group_id)


def get_lag(group_id):
    result = {}
    try:
        info = admin.list_consumer_group_offsets(group_id=group_id)
        for i in info:
            end_offset = consumer.end_offsets([i])
            lag = end_offset.get(i) - info[i].offset
            if result.get(i.topic) is None:
                result[i.topic] = {"high": end_offset.get(i), "offset": info[i].offset, "lag": lag}
            else:
                result[i.topic]["high"] = result[i.topic]["high"] + end_offset.get(i)
                result[i.topic]["offset"] = result[i.topic]["offset"] + info[i].offset
                result[i.topic]["lag"] = result[i.topic]["lag"] + lag
        group_offset.append({group_id: result})
    except Exception as e:
        print(group_id, e)


def main():
    threads = []
    consumers = admin.list_consumer_groups()
    for i in consumers:
        if i[1] == 'consumer':
            th = myThread(i[0])
            th.start()
            threads.append(th)
    for t in threads:
        t.join()

if __name__ == "__main__":
    try:
        if len(sys.argv) == 1:
            select_lag_num = 100
        else:
            select_lag_num = int(sys.argv[1])
        alarm = []
        consumer = KafkaConsumer(bootstrap_servers='kafka:9092')
        admin = KafkaAdminClient(bootstrap_servers='kafka:9092')
        group_offset = []
        main()
        for i in group_offset:
            for cons in i:
                for topic in i[cons]:
                    if (i[cons][topic]['lag']) >= select_lag_num:
                        print(cons, topic, i[cons][topic]['high'],i[cons][topic]['offset'],i[cons][topic]['lag'])

    except Exception as e:
        print(e)
