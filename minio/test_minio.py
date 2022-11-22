#!/bin/env python3
import sys
import threading
import time

import requests

from juliface import ziyan
import random

timelist = []
suc = []
fail = []


class myThread(threading.Thread):
    def __init__(self, piclist):
        threading.Thread.__init__(self)
        self.piclist = piclist

    def run(self):
        run_fun(self.piclist)


def run_fun(piclist):
    for pic in piclist:
        try:
            time1 = int(time.time() * 1000)
            r = requests.get(pic)
            time2 = int(time.time() * 1000)
            if r.status_code == 200:
                suc.append("1")
            else:
                fail.append("1")
            t = time2 - time1
            timelist.append(t)
        except Exception as e:
            print(e)
    return 0


def split_list(list, num):
    result = []
    if len(list) < num:
        num = len(list)
    for i in range(num):
        result.append([])
    for i in range(len(list)):
        result[i % num].append(list[i])
    return result


def main(piclists, Threadnum=16):
    global timelist, suc, fail
    timelist = []
    suc = []
    fail = []
    threads = []
    b_time = int(time.time() * 1000)
    piclist = split_list(piclists, Threadnum)
    for i in range(len(piclist)):
        th = myThread(piclist[0])
        th.start()
        threads.append(th)
    for t in threads:
        t.join()
    e_time = int(time.time() * 1000)
    t = (e_time - b_time) / 1000
    print("%d线程调用, %d 次成功, %d次失败 , 最大耗时%d ms , 最小耗时%d ms, 平均耗时%.2fms, 总耗时%.2f秒" % (
        Threadnum, len(suc), len(fail),  max(timelist), min(timelist), sum(timelist) / len(timelist), t))


if __name__ == '__main__':
    piclist = []
    file = "miniofile.list"
    with open(file, "r") as fp:
        data = fp.readlines()
    for row in data:
        picurl = "http://192.168.3.13:10080/ncda-common-web/resource/getImage?path=" + row.strip()
        piclist.append(picurl)
    Threadnum = 8
    main(piclist, Threadnum)


