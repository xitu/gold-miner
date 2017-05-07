> * 原文地址：[Detecting Bots in Apache & Nginx Logs](http://tech.marksblogg.com/detect-bots-apache-nginx-logs.html)
> * 原文作者：[Mark Litwintschik](http://tech.marksblogg.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[luoyaqifei](http://www.zengmingxia.com)
> * 校对者：[forezp](https://github.com/forezp)，[1992chenlu](https://github.com/1992chenlu)

# 在 Apache 和 Nginx 日志里检测爬虫机器人

现在阻止基于 JavaScript 追踪的浏览器插件享有九位数的用户量，从这一事实可以看出，web 流量日志可以成为一个很好的、能够感知有多少人在访问你的网站的地方。但是任何监测过 web 流量日志一段时间的人都知道，有成群结队的爬虫机器人在爬网站。然而，在 web 服务器日志里分辨出机器人和人为产生的流量是一个难题。

在这篇博文中，我将带你们重现那些我在创建一个基于 IPv4 所属和浏览器字串（browser string）的机器人检测脚本时用过的步骤。  

本文中用到的代码在这个 [代码片段](https://gist.github.com/marklit/80b875ccab8b215bfa0ecdfaa5000e7b) 里。

## IP 地址所属数据库

首先，我会安装 Python 和一些依赖包。接下来的指令会在一个新的 Ubuntu 14.04.3 LTS 安装过程中执行。

    $ sudo apt-get update
    $ sudo apt-get install \
        python-dev \
        python-pip \
        python-virtualenv


接下来我要创建一个 Python 虚拟环境，并且激活它。通过 pip 安装库时，容易遇到权限问题，这样可以缓解这种问题。

    $ virtualenv findbots
    $ source findbots/bin/activate


MaxMind 提供了一个免费的数据库，数据库里有 IPv4 地址对应的国家和城市注册信息。和这些数据集一起，他们还发布了一个基于 Python 的库，叫 “geoip2”，这个库可以将他们的数据集映射到内存映射的文件里，并且用基于 C 的 Python 扩展来执行非常快的查询。

下面的命令会安装它们的包，下载、解压它们在城市那一层的数据集。

    $ pip install geoip2
    $ curl -O http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    $ gunzip GeoLite2-City.mmdb.gz


我看过一些 web 流量日志，并且抓取出来一些恰好请求了「robots.txt」的流量。从那个列表里，我重点检查了经常出现的 IP 地址中的一些，发现不少 IP 其实是属于主机和云服务提供商的。我想知道是不是有可能攒出来一个列表，无论完不完整，包括了这些提供商所有的 IPv4 地址。

Google 有一个基于 DNS 的机制，用于收集它们用于提供云的 IP 地址列表。这个最初的调用将给你一系列可以查询的主机。

    $ dig -t txt _cloud-netblocks.googleusercontent.com | grep spf

```
 _cloud-netblocks.googleusercontent.com. 5 IN TXT "v=spf1 include:_cloud-netblocks1.googleusercontent.com include:_cloud-netblocks2.googleusercontent.com include:_cloud-netblocks3.googleusercontent.com include:_cloud-netblocks4.googleusercontent.com include:_cloud-netblocks5.googleusercontent.com ?all"
```


以上阐明了 _cloud-netblocks[1-5].googleusercontent.com 将包含 SPF 记录，这些记录里包括他们实用的 IPv4 和 IPv6 CIDR 地址。像如下这样查询所有的五个地址，应当会给你一个最新的列表。

    $ dig -t txt _cloud-netblocks1.googleusercontent.com | grep spf

```
_cloud-netblocks1.googleusercontent.com. 5 IN TXT "v=spf1 ip4:8.34.208.0/20 ip4:8.35.192.0/21 ip4:8.35.200.0/23 ip4:108.59.80.0/20 ip4:108.170.192.0/20 ip4:108.170.208.0/21 ip4:108.170.216.0/22 ip4:108.170.220.0/23 ip4:108.170.222.0/24 ?all"
```

去年三月，基于 Hadoop 的 MapReduce 任务，我尝试着抓取了整个 IPv4 地址空间的 WHOIS 细节，并且发布了一篇 [博客文章](http://tech.marksblogg.com/bulk-ip-address-whois-python-hadoop.html#ipv4-whois-mapreduce-job)。这个任务在过早结束之前，跑了接近两个小时，留给了我一份虽然不完整，但是大小可观的数据集，里面有 235,532 个 WHOIS 记录。这个数据集已经存在一年之久了，除了有点过时，应该还是有价值的。

    $ ls -l

```
-rw-rw-r-- 1 mark mark  5946203 Mar 31  2016 part-00001
-rw-rw-r-- 1 mark mark  5887326 Mar 31  2016 part-00002
...
-rw-rw-r-- 1 mark mark  6187219 Mar 31  2016 part-00154
-rw-rw-r-- 1 mark mark  5961162 Mar 31  2016 part-00155
```    

当我重点检查那些爬到「robots.txt」的爬虫机器人的 IP 所属时，除了 Google，这六家公司也出现了很多次：Amazon、百度、Digital Ocean、Hetzner、Linode 和 New Dream Network。我跑了以下的命令，尝试去取出它们的 IPv4 WHOIS 记录。

    $ grep -i 'amazon'            part-00* > amzn
    $ grep -i 'baidu'             part-00* > baidu
    $ grep -i 'digital ocean'     part-00* > digital_ocean
    $ grep -i 'hetzner'           part-00* > hetzner
    $ grep -i 'linode'            part-00* > linode
    $ grep -i 'new dream network' part-00* > dream


我需要从以上六个文件中，解析二次编码的 JSON 字符串，这些字符串包含了文件名和频率次数信息。我使用了 iPython 代码来获得不同的 CIDR 块，代码如下：

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

下面是一份清理完毕的 WHOIS 记录实例，我已经去掉了联系信息。

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

这份七个公司的列表不是一个关于爬虫机器人来源的全面的列表。我发现，除了一个从世界各地连接的分布式爬虫战队，很多爬虫流量来源于一些在乌克兰、中国的住宅 IP，源头很难分辨。说实话，如果我想要一个全面的爬虫机器人实用的 IP 列表，我只需要看看 [HTTP 头的顺序](http://geocar.sdf1.org/browser-verification.html)，检查下 TCP/IP 的行为，搜寻 [伪造 IP 注册](http://go.whiteops.com/rs/179-SQE-823/images/WO_Methbot_Operation_WP.pdf)（请看 28 页），列表就出来了，并且这就像猫和老鼠的游戏一样。

## 安装库

对于这个项目而言，我会实用一些写得很好的库。[Apache Log Parser](https://github.com/rory/apache-log-parser) 可以解析 Apache 和 Nginx 生成的流量日志。这个库支持从日志文件中解析超过 30 种不同类型的信息，并且我发现，它相当弹性、可靠。[Python User Agents](https://github.com/selwin/python-user-agents) 可以解析用户代理的字符串，并执行一些代理使用的基本分类操作。[Colorama](https://github.com/tartley/colorama) 协助创建有高亮的 ANSI 输出。[Netaddr](https://github.com/drkjam/netaddr/) 是一种成熟的、维护得很好的网络地址操作库。

    $ pip install -e git+https://github.com/rory/apache-log-parser.git#egg=apache-log-parser \
                  -e git+https://github.com/selwin/python-user-agents.git#egg=python-user-agents \
                  colorama \
                  netaddr


## 爬虫机器人监控脚本

接下来的部分是跑 monitor.py 的内容。这段脚本从 stdin（标准输入） 管道中接收 web 流量日志。这说明你可以通过 ssh 在远程服务器上看日志，在本地跑这段脚本。

我先从 Python 标准库里导入两个库，并通过 pip 安装了五个外部库。

```
import sys
from urlparse import urlparse

import apache_log_parser
from colorama import Back, Style
import geoip2.database
from netaddr import IPNetwork, IPAddress
from user_agents import parse
```

接下来我设置好 MaxMind 的 geoip2 库，以使用「GeoLite2-City.mmdb」城市级别的库。

我还设置了 apache_log_parser，来处理存储的 web 日志格式。你的日志格式可能不一样，所以可能需要花点时间比较下你的 web 服务器的流量日志配置与这个库的 [格式文档](https://github.com/rory/apache-log-parser#supported-values)。

最后，我有一个我发现的属于那七家公司的 CIDR 块的字典。在这个列表里，从本质上来说，百度不是一家主机或者云提供商，但是跑着很多无法通过它们的用户代理所识别的爬虫机器人。

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

我创建了一个工具函数，可以传入一个 IPv4 地址和一个 CIDR 块列表，它会告诉我这个 IP 地址是不是属于给定的这些 CIDR 块中的任何一个。

```
def in_block(ip, block):
    _ip = IPAddress(ip)
    return any([True
                for cidr in block
                if _ip in IPNetwork(cidr)])
```

下面这个函数接收请求（ req ）和浏览器代理（ agent ）的对象，并尝试用这两个对象来判断流量源头／浏览器代理是否来自爬虫机器人。这个浏览器代理对象是使用 Python 用户代理库构造的，并且有一些测试用于判断，用户代理字串是否属于某个已知的爬虫机器人。我已经用一些我从库的分类系统中看到的 token 来扩展这些测试。同时我在 CIDR 块迭代，来判断远程主机的 IPv4 地址是否在里面。

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

下面是脚本的主要部分。web 流量日志从标准输入里一行行地读入。内容的每一行都被解析成一个带 token 版本的请求、用户代理和被请求的 URI。这些对象让与这些数据打交道变得更容易，不需要去麻烦地在空中解析它们。

我尝试着用 MaxMind 的库查询与这些 IPv4 相关的城市和国家。如果有任何类型的查询失败，结果会简单地设置为 None。

在爬虫机器人测试后，我准备输出。如果请求看起来是从爬虫机器人处发送的，它会被标成红色背景，高亮在输出上。

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

## 爬虫机器人检测实战

接下来是一个例子，在把这些内容放到监测脚本时，我是用下面这种方式连接输出 web 流量日志的最后一百行的。

```
$ ssh server \
    'tail -n100 -f access.log' \
    | python monitor.py
```


有可能来源于爬虫机器人的请求将使用红色背景和「b」前缀高亮。不存在爬虫机器人的流量将被打上「h」的前缀，代表 human（人）。下面是从脚本出来的样例输出，不过没有 ANSI 背景色。

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
