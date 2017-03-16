> * 原文地址：[Detecting Bots in Apache & Nginx Logs](http://tech.marksblogg.com/detect-bots-apache-nginx-logs.html)
>* 原文作者：[Mark Litwintschik](http://tech.marksblogg.com/)
>* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
>* 译者： 
>* 校对者：

# Detecting Bots in Apache & Nginx Logs

As browser plugins that block JavaScript-based tracking beacons now enjoy a 9-figure user base, web traffic logs can be a good place to get a better feel for how many people are visiting your website. But anyone that has monitored a web traffic log for more than a few minutes is aware there is an army of bots crawling websites. But being able to separate bot and human-generated traffic in web server logs can be challenging.

In this blog I'll walk through the steps I went through to build an IPv4 ownership and browser string-based bot detection script.

The code used in this blog can be found in this [gist](https://gist.github.com/marklit/80b875ccab8b215bfa0ecdfaa5000e7b).

## IP Address Ownership Databases

I'll first install Python and some dependencies. The following was run on a fresh Ubuntu 14.04.3 LTS installation.

    $ sudo apt-get update
    $ sudo apt-get install \
        python-dev \
        python-pip \
        python-virtualenv
    

I'll then create a Python virtual environment and activate it. This should ease any issues with permissions when installing libraries via pip.

    $ virtualenv findbots
    $ source findbots/bin/activate
    

MaxMind offer a free database of country and city registration information for IPv4 addresses. Along with this dataset they've released a Python-based library called "geoip2" that can map their datasets to memory-mapped files and use a C-based Python extension to perform very fast lookups.

The following will install their library and download and unpack their city-level dataset.

    $ pip install geoip2
    $ curl -O http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    $ gunzip GeoLite2-City.mmdb.gz
    

I had a look at some web traffic logs and grep'ed out hits where "robots.txt" was being requested. From that list I spot-checked some of the more frequently-appearing IP addresses and found a number of hosting and cloud providers being listed as the owners of these IPs. I wanted to see if it was possible to put together a list, however incomplete, of IPv4 addresses under these providers' ownership.

Google have a DNS-based mechanism for collecting a list of their IP addresses they use for their cloud offering. This first call will give you a list of hosts to query.

    $ dig -t txt _cloud-netblocks.googleusercontent.com | grep spf
    
```
 _cloud-netblocks.googleusercontent.com. 5 IN TXT "v=spf1 include:_cloud-netblocks1.googleusercontent.com include:_cloud-netblocks2.googleusercontent.com include:_cloud-netblocks3.googleusercontent.com include:_cloud-netblocks4.googleusercontent.com include:_cloud-netblocks5.googleusercontent.com ?all"
```
    

The above states that _cloud-netblocks[1-5].googleusercontent.com will contain SPF records that contain IPv4 and IPv6 CIDR addresses they use. Querying all five addresses like the following should give you an up-to-date listing.

    $ dig -t txt _cloud-netblocks1.googleusercontent.com | grep spf
    
```
_cloud-netblocks1.googleusercontent.com. 5 IN TXT "v=spf1 ip4:8.34.208.0/20 ip4:8.35.192.0/21 ip4:8.35.200.0/23 ip4:108.59.80.0/20 ip4:108.170.192.0/20 ip4:108.170.208.0/21 ip4:108.170.216.0/22 ip4:108.170.220.0/23 ip4:108.170.222.0/24 ?all"
```

I published a [blog post](bulk-ip-address-whois-python-hadoop.html#ipv4-whois-mapreduce-job) last March where I attempted to scrape WHOIS details for the entirety of the IPv4 address space using a Hadoop-based MapReduce job. The job itself ran for about two hours before terminating prematurely. I was left with an incomplete but still sizeable dataset of 235,532 WHOIS records. The dataset is a year old now but should still prove valuable, if not somewhat dated.

    $ ls -l
    
```
-rw-rw-r-- 1 mark mark  5946203 Mar 31  2016 part-00001
-rw-rw-r-- 1 mark mark  5887326 Mar 31  2016 part-00002
...
-rw-rw-r-- 1 mark mark  6187219 Mar 31  2016 part-00154
-rw-rw-r-- 1 mark mark  5961162 Mar 31  2016 part-00155
```    

When I spot-checked the IP ownership of bots hitting "robots.txt", in addition to Google, six firms came up a lot: Amazon, Baidu, Digital Ocean, Hetzner, Linode and New Dream Network. I ran the following commands to try and pick out their IPv4 WHOIS records.

    $ grep -i 'amazon'            part-00* > amzn
    $ grep -i 'baidu'             part-00* > baidu
    $ grep -i 'digital ocean'     part-00* > digital_ocean
    $ grep -i 'hetzner'           part-00* > hetzner
    $ grep -i 'linode'            part-00* > linode
    $ grep -i 'new dream network' part-00* > dream
    

I had to parse out double-encoded JSON strings that were embedded with file name and frequency count information from the above six files. I use the following code in iPython to get the distinctive CIDR blocks.

```
import json


def parse_cidrs(filename):
    lines = open(filename, 'r+b').read().split('\n')

    recs = []

    for line in lines:
        try:
            recs.append(
                json.loads(
                    json.loads(':'.join(line.split('\t')[0].split(':')[1:]))))
        except ValueError:
            continue

    return set([str(rec.get('network', {}).get('cidr', None))
                for rec in recs])


for _name in ['amzn', 'baidu', 'digital_ocean',
              'hetzner', 'linode', 'dream']:
    print _name, parse_cidrs(_name)
```

Here is an example WHOIS record once it's been cleaned up. I've truncated out the contact information.

```
{
    "asn": "38365",
    "asn_cidr": "182.61.0.0/18",
    "asn_country_code": "CN",
    "asn_date": "2010-02-25",
    "asn_registry": "apnic",
    "entities": [
        "IRT-CNNIC-CN",
        "SD753-AP"
    ],
    "network": {
        "cidr": "182.61.0.0/16",
        "country": "CN",
        "end_address": "182.61.255.255",
        "events": [
            {
                "action": "last changed",
                "actor": null,
                "timestamp": "2014-09-28T05:44:22Z"
            }
        ],
        "handle": "182.61.0.0 - 182.61.255.255",
        "ip_version": "v4",
        "links": [
            "http://rdap.apnic.net/ip/182.0.0.0/8",
            "http://rdap.apnic.net/ip/182.61.0.0/16"
        ],
        "name": "Baidu",
        "parent_handle": "182.0.0.0 - 182.255.255.255",
        "raw": null,
        "remarks": [
            {
                "description": "Beijing Baidu Netcom Science and Technology Co., Ltd...",
                "links": null,
                "title": "description"
            }
        ],
        "start_address": "182.61.0.0",
        "status": null,
        "type": "ALLOCATED PORTABLE"
    },
    "query": "182.61.48.129",
    "raw": null
}
```

The list of seven firms isn't an exhaustive list of where bot traffic originates from. I found a lot of bot traffic from residential IPs in the Ukraine, Chinese IPs where the originating organisation is difficult to distinguish in addition to a distributed army of bots connecting from all around the world. If I wanted an exhaustive list of IPs used by bots I could look into [HTTP header order](http://geocar.sdf1.org/browser-verification.html), examine TCP/IP behaviour, hunt down [forged IP registrations](http://go.whiteops.com/rs/179-SQE-823/images/WO_Methbot_Operation_WP.pdf) (see page 28), the list goes on and it's a bit of a cat-and-mouse game to be honest.

## Installing Libraries

For this project I'll be using a number of well-written libraries. [Apache Log Parser](https://github.com/rory/apache-log-parser) can parse lines in Apache and Nginx-generated traffic logs. The library supports parsing over 30 different types of information from log files and I've found it remarkably flexible and reliable. [Python User Agents](https://github.com/selwin/python-user-agents) can parse user agent strings as well as perform some basic classification of the agent being used. [Colorama](https://github.com/tartley/colorama) assists in creating colourful ANSI output. [Netaddr](https://github.com/drkjam/netaddr/) is a mature and well-maintained network address manipulation library.

    $ pip install -e git+https://github.com/rory/apache-log-parser.git#egg=apache-log-parser \
                  -e git+https://github.com/selwin/python-user-agents.git#egg=python-user-agents \
                  colorama \
                  netaddr
    

## The Bot Monitoring Script

The following walks through the contents of monitor.py. This script accepts web traffic logs piped in from stdin. This means you can tail a log on a remote server via ssh and run this script locally.

I'll first import two libraries from the Python Standard Library and the five external libraries installed via pip.

```
import sys
from urlparse import urlparse

import apache_log_parser
from colorama import Back, Style
import geoip2.database
from netaddr import IPNetwork, IPAddress
from user_agents import parse
```

In the following I've setup MaxMind's geoip2 library to use the "GeoLite2-City.mmdb" city-level library.

I've also setup apache_log_parser to work with the format my web logs are being stored in. Your log format may vary so please take the time to compare your web server's traffic logging configuration against the library's [format documentation](https://github.com/rory/apache-log-parser#supported-values).

Finally, I have a dictionary of the CIDR blocks I found being owned by the seven firms. Included in this list is Baidu, which isn't a hosting or cloud provider per-se but nonetheless run bots that haven't always identified themselves by their user agent.

```
reader = geoip2.database.Reader('GeoLite2-City.mmdb')

_format = "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""
line_parser = apache_log_parser.make_parser(_format)

CIDRS = {
    'Amazon': ['107.20.0.0/14', '122.248.192.0/19', '122.248.224.0/19',
               '172.96.96.0/20', '174.129.0.0/16', '175.41.128.0/19',
               '175.41.160.0/19', '175.41.192.0/19', '175.41.224.0/19',
               '176.32.120.0/22', '176.32.72.0/21', '176.34.0.0/16',
               '176.34.144.0/21', '176.34.224.0/21', '184.169.128.0/17',
               '184.72.0.0/15', '185.48.120.0/26', '207.171.160.0/19',
               '213.71.132.192/28', '216.182.224.0/20', '23.20.0.0/14',
               '46.137.0.0/17', '46.137.128.0/18', '46.51.128.0/18',
               '46.51.192.0/20', '50.112.0.0/16', '50.16.0.0/14', '52.0.0.0/11',
               '52.192.0.0/11', '52.192.0.0/15', '52.196.0.0/14',
               '52.208.0.0/13', '52.220.0.0/15', '52.28.0.0/16', '52.32.0.0/11',
               '52.48.0.0/14', '52.64.0.0/12', '52.67.0.0/16', '52.68.0.0/15',
               '52.79.0.0/16', '52.80.0.0/14', '52.84.0.0/14', '52.88.0.0/13',
               '54.144.0.0/12', '54.160.0.0/12', '54.176.0.0/12',
               '54.184.0.0/14', '54.188.0.0/14', '54.192.0.0/16',
               '54.193.0.0/16', '54.194.0.0/15', '54.196.0.0/15',
               '54.198.0.0/16', '54.199.0.0/16', '54.200.0.0/14',
               '54.204.0.0/15', '54.206.0.0/16', '54.207.0.0/16',
               '54.208.0.0/15', '54.210.0.0/15', '54.212.0.0/15',
               '54.214.0.0/16', '54.215.0.0/16', '54.216.0.0/15',
               '54.218.0.0/16', '54.219.0.0/16', '54.220.0.0/16',
               '54.221.0.0/16', '54.224.0.0/12', '54.228.0.0/15',
               '54.230.0.0/15', '54.232.0.0/16', '54.234.0.0/15',
               '54.236.0.0/15', '54.238.0.0/16', '54.239.0.0/17',
               '54.240.0.0/12', '54.242.0.0/15', '54.244.0.0/16',
               '54.245.0.0/16', '54.247.0.0/16', '54.248.0.0/15',
               '54.250.0.0/16', '54.251.0.0/16', '54.252.0.0/16',
               '54.253.0.0/16', '54.254.0.0/16', '54.255.0.0/16',
               '54.64.0.0/13', '54.72.0.0/13', '54.80.0.0/12', '54.72.0.0/15',
               '54.79.0.0/16', '54.88.0.0/16', '54.93.0.0/16', '54.94.0.0/16',
               '63.173.96.0/24', '72.21.192.0/19', '75.101.128.0/17',
               '79.125.64.0/18', '96.127.0.0/17'],
    'Baidu': ['180.76.0.0/16', '119.63.192.0/21', '106.12.0.0/15',
              '182.61.0.0/16'],
    'DO': ['104.131.0.0/16', '104.236.0.0/16', '107.170.0.0/16',
           '128.199.0.0/16', '138.197.0.0/16', '138.68.0.0/16',
           '139.59.0.0/16', '146.185.128.0/21', '159.203.0.0/16',
           '162.243.0.0/16', '178.62.0.0/17', '178.62.128.0/17',
           '188.166.0.0/16', '188.166.0.0/17', '188.226.128.0/18',
           '188.226.192.0/18', '45.55.0.0/16', '46.101.0.0/17',
           '46.101.128.0/17', '82.196.8.0/21', '95.85.0.0/21', '95.85.32.0/21'],
    'Dream': ['173.236.128.0/17', '205.196.208.0/20', '208.113.128.0/17',
              '208.97.128.0/18', '67.205.0.0/18'],
    'Google': ['104.154.0.0/15', '104.196.0.0/14', '107.167.160.0/19',
               '107.178.192.0/18', '108.170.192.0/20', '108.170.208.0/21',
               '108.170.216.0/22', '108.170.220.0/23', '108.170.222.0/24',
               '108.59.80.0/20', '130.211.128.0/17', '130.211.16.0/20',
               '130.211.32.0/19', '130.211.4.0/22', '130.211.64.0/18',
               '130.211.8.0/21', '146.148.16.0/20', '146.148.2.0/23',
               '146.148.32.0/19', '146.148.4.0/22', '146.148.64.0/18',
               '146.148.8.0/21', '162.216.148.0/22', '162.222.176.0/21',
               '173.255.112.0/20', '192.158.28.0/22', '199.192.112.0/22',
               '199.223.232.0/22', '199.223.236.0/23', '208.68.108.0/23',
               '23.236.48.0/20', '23.251.128.0/19', '35.184.0.0/14',
               '35.188.0.0/15', '35.190.0.0/17', '35.190.128.0/18',
               '35.190.192.0/19', '35.190.224.0/20', '8.34.208.0/20',
               '8.35.192.0/21', '8.35.200.0/23',],
    'Hetzner': ['129.232.128.0/17', '129.232.156.128/28', '136.243.0.0/16',
                '138.201.0.0/16', '144.76.0.0/16', '148.251.0.0/16',
                '176.9.12.192/28', '176.9.168.0/29', '176.9.24.0/27',
                '176.9.72.128/27', '178.63.0.0/16', '178.63.120.64/27',
                '178.63.156.0/28', '178.63.216.0/29', '178.63.216.128/29',
                '178.63.48.0/26', '188.40.0.0/16', '188.40.108.64/26',
                '188.40.132.128/26', '188.40.144.0/24', '188.40.48.0/26',
                '188.40.48.128/26', '188.40.72.0/26', '196.40.108.64/29',
                '213.133.96.0/20', '213.239.192.0/18', '41.203.0.128/27',
                '41.72.144.192/29', '46.4.0.128/28', '46.4.192.192/29',
                '46.4.84.128/27', '46.4.84.64/27', '5.9.144.0/27',
                '5.9.192.128/27', '5.9.240.192/27', '5.9.252.64/28',
                '78.46.0.0/15', '78.46.24.192/29', '78.46.64.0/19',
                '85.10.192.0/20', '85.10.228.128/29', '88.198.0.0/16',
                '88.198.0.0/20'],
    'Linode': ['104.200.16.0/20', '109.237.24.0/22', '139.162.0.0/16',
               '172.104.0.0/15', '173.255.192.0/18', '178.79.128.0/21',
               '198.58.96.0/19', '23.92.16.0/20', '45.33.0.0/17',
               '45.56.64.0/18', '45.79.0.0/16', '50.116.0.0/18',
               '80.85.84.0/23', '96.126.96.0/19'],
}
```

I've created a utility function where I can pass in an IPv4 address and a list of CIDR blocks and it'll tell me if the IP address belongs to any of the given CIDR blocks.

```
def in_block(ip, block):
    _ip = IPAddress(ip)
    return any([True
                for cidr in block
                if _ip in IPNetwork(cidr)])
```

The following function takes objects of a request and the browser agent used and tries to determine if the source of traffic and/or the browser agent are that of a bot. The browser agent object is put together by the Python User Agents library and it already has some tests for determining if a user agent string is that of a known bot. I've further expanded these tests with a number of tokens I saw slip through the library's classification system. I also iterate through the CIDR blocks to see if the the remote host's IPv4 address is within any of them.

```
def bot_test(req, agent):
    ua_tokens = ['daum/', # Daum Communications Corp.
                 'gigablastopensource',
                 'go-http-client',
                 'http://',
                 'httpclient',
                 'https://',
                 'libwww-perl',
                 'phantomjs',
                 'proxy',
                 'python',
                 'sitesucker',
                 'wada.vn',
                 'webindex',
                 'wget']

    is_bot = agent.is_bot or \
             any([True
                  for cidr in CIDRS.values()
                  if in_block(req['remote_host'], cidr)]) or \
             any([True
                  for token in ua_tokens
                  if token in agent.ua_string.lower()])

    return is_bot
```

The following is the main section of the script. Here web traffic logs are read in from stdin line by line. Each line of content is parsed for a tokenised version of the request, user agent and URI being requested. These objects make it easier to work with the data without the complexity of having to parse them on the fly.

I attempt to look up the city and country associated with the IPv4 address using MaxMind's library. If there is any sort of failure these are simply set to None.

After the bot test I prepare the output. If the request is seen to be that of a bot it'll highlight the output with a red background.

```
if __name__ == '__main__':
    while True:
        try:
            line = sys.stdin.readline()
        except KeyboardInterrupt:
            break

        if not line:
            break

        req = line_parser(line)
        agent = parse(req['request_header_user_agent'])
        uri = urlparse(req['request_url'])

        try:
            response = reader.city(req['remote_host'])
            country, city = response.country.iso_code, response.city.name
        except:
            country, city = None, None

        is_bot = bot_test(req, agent)

        agent_str = ', '.join([item
                               for item in agent.browser[0:3] +
                                           agent.device[0:3] +
                                           agent.os[0:3]
                               if item is not None and
                                  type(item) is not tuple and
                                  len(item.strip()) and
                                  item != 'Other'])

        ip_owner_str = ' '.join([network + ' IP'
                                  for network, cidr in CIDRS.iteritems()
                                  if in_block(req['remote_host'], cidr)])

        print Back.RED + 'b' if is_bot else 'h', \
              country, \
              city, \
              uri.path, \
              agent_str, \
              ip_owner_str, \
              Style.RESET_ALL
```

## Bot Detection in Action

Below is an example where I concatenate out the last 100 lines of a web traffic log while continuing to follow it and pipe the contents into the monitoring script.

```
$ ssh server \
    'tail -n100 -f access.log' \
    | python monitor.py
```
    

Requests suspected to have originated from bots will be highlighted with a red background and a "b" prefix. Non-bot traffic will be prefixed with "h" for human. The following is an example output from the script sans the ANSI background colours.

    ...
    b US Indianapolis /robots.txt Python Requests 2.2 Linux 3.2.0
    h DE Hamburg /tensorflow-vizdoom-bots.html Firefox 45.0 Windows 7
    h DE Hamburg /theme/css/style.css Firefox 45.0 Windows 7
    h DE Hamburg /theme/css/syntax.css Firefox 45.0 Windows 7
    h DE Hamburg /theme/images/mark.jpg Firefox 45.0 Windows 7
    b US Indianapolis /feeds/all.atom.xml rogerbot 1.0 Spider Spider Desktop
    b US Mountain View /billion-nyc-taxi-kdb.html  Google IP
    h CH Zurich /billion-nyc-taxi-rides-s3-vs-hdfs.html Chrome 56.0.2924 Windows 7
    h IE Dublin /tensorflow-vizdoom-bots.html Chrome 56.0.2924 Mac OS X 10.12.0
    h IE Dublin /theme/css/style.css Chrome 56.0.2924 Mac OS X 10.12.0
    h IE Dublin /theme/css/syntax.css Chrome 56.0.2924 Mac OS X 10.12.0
    h IE Dublin /theme/images/mark.jpg Chrome 56.0.2924 Mac OS X 10.12.0
    b SG Singapore /./theme/images/mark.jpg Slack-ImgProxy Spider Spider Desktop Amazon IP
  