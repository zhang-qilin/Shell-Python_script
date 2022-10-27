#!/bin/env python3
import requests


def main(hosts,user="julichina",passwd="julichina"):
    print("%-56s%-10s%-10s%-10s" % ("name","total","get","deliver"))
    url = "http://%s:15672/api/queues/ncbd" % hosts
    r = requests.get(url,auth=(user,passwd))
    for i in r.json():
        try:
            print("%-56s%-10s%-10s%-10s" %(i['name'],i['messages'],i['message_stats']['publish_details']['rate'],i['message_stats']['deliver_get_details']['rate']))
        except Exception as e:
            pass


if __name__ == "__main__":
    main("44.64.6.218")
