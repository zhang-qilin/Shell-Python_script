#!/bin/env python
import json
import os
import time

def get_filelist(path):
    result = []
    for file in os.listdir(path):
        filename = path + "/" + file
        result.append(filename)
    result.sort()
    return result


def analyse(filelist):
    result = {}
    for f in filelist:
        t = f.split("/")[-1].split(".")[0]
        mtime = int(time.mktime(time.strptime(str(t), '%Y%m%d%H%M%S')))
        with open(f,"r") as fp:
            data = json.load(fp)
        for i in data:
            for consumer in i:
                for topic in i[consumer]['offset']:
                    offset = i[consumer]['offset'][topic]['offset']
                    lat = i[consumer]['offset'][topic]['lag']
                    high = i[consumer]['offset'][topic]['high']   
                    if result.get(consumer,0) == 0:
                        result[consumer] = {}
                    if result[consumer].get(topic,0) == 0:
                        result[consumer][topic] = {}
                    if result[consumer][topic].get('high',0) == 0:
                        result[consumer][topic]['high'] = []
                        result[consumer][topic]['offset'] = []
                        result[consumer][topic]['time'] = []
                    result[consumer][topic]['high'].append(high)
                    result[consumer][topic]['offset'].append(offset)
                    result[consumer][topic]['time'].append(mtime)
    return result


def analyse_increase(data):
    result = {}
    for consumer in data:
        for topic in data[consumer]:
            high_temp = 0
            offset_temp = 0
            t_temp = 0
            for i in range(len(data[consumer][topic]['offset'])): 
                offset = data[consumer][topic]['offset'][i]
                high = data[consumer][topic]['high'][i]
                t = data[consumer][topic]['time'][i]
                if t_temp == 0:
                    high_temp = high
                    offset_temp = offset
                    t_temp = t
                    continue
                t_increase = t - t_temp
                offset_increase = (offset - offset_temp) / t_increase
                high_increase = (high - high_temp) / t_increase              
                high_temp = high
                offset_temp = offset
                t_temp = t
                if result.get(consumer,0) == 0:
                    result[consumer] = {}
                if result[consumer].get(topic,0) == 0:
                    result[consumer][topic] = {}
                if result[consumer][topic].get('high',0) == 0:
                    result[consumer][topic]['high'] = []
                    result[consumer][topic]['offset'] = []
                    result[consumer][topic]['time'] = []
                result[consumer][topic]['high'].append('%.2f' % high_increase)
                result[consumer][topic]['offset'].append('%.2f' % offset_increase)
                result[consumer][topic]['time'].append(time.strftime("%m-%d_%H:%M",time.localtime(t)))
    return result
        


def main(path,file):
    fp = open(file,"w")
    data = analyse(get_filelist(path))  
    i = analyse_increase(data)
    for consumer in i:
        for topic in i[consumer]:
            row = 'consumer'+ ',' + 'topic' + ',' + 'type' + ',' + ','.join(i[consumer][topic]['time']) + '\r\n'
            fp.writelines(row)
            break
        break
    for consumer in i:
        for topic in i[consumer]:
            row1 = consumer + ',' + topic + ',' + 'production' + ',' + ','.join(i[consumer][topic]['high']) + '\r\n'
            row2 = consumer + ',' + topic + ',' + 'consumption' + ',' + ','.join(i[consumer][topic]['offset']) + '\r\n'
            fp.writelines(row1)
            fp.writelines(row2)
    fp.close()

    

if __name__ == "__main__":
    path = "/home/honya/mr.zhang/each_day/result"
    file = "kafka.csv"
    main(path, file)
