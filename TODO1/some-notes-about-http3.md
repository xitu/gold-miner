> * 原文地址：[Some notes about HTTP/3](https://blog.erratasec.com/2018/11/some-notes-about-http3.html?m=1)
> * 原文作者：[Errata](https://blog.erratasec.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/some-notes-about-http3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/some-notes-about-http3.md)
> * 译者：
> * 校对者：

# Some notes about HTTP/3

HTTP/3 is going to be standardized. As an old protocol guy, I thought I'd write up some comments.  
  
Google (pbuh) has both the most popular web browser (Chrome) and the two most popular websites (#1 Google.com #2 Youtube.com). Therefore, they are in control of future web protocol development. Their first upgrade they called SPDY (pronounced "speedy"), which was eventually standardized as the second version of HTTP, or HTTP/2. Their second upgrade they called QUIC (pronounced "quick"), which is being standardized as HTTP/3.  
  
  
SPDY (HTTP/2) is already supported by the major web browser (Chrome, Firefox, Edge, Safari) and major web servers (Apache, Nginx, IIS, CloudFlare). Many of the most popular websites support it (even non-Google ones), though you are unlikely to ever see it on the wire (sniffing with Wireshark or tcpdump), because it's always encrypted with SSL. While the standard allows for HTTP/2 to run raw over TCP, all the implementations only use it over SSL.  
  
There is a good lesson here about **standards**. Outside the Internet, standards are often _de jure_, run by government, driven by getting all major stakeholders in a room and hashing it out, then using rules to force people to adopt it. On the Internet, people implement things first, and then if others like it, they'll start using it, too. Standards are often _de facto_, with RFCs being written for what is already working well on the Internet, documenting what people are already using. SPDY was adopted by browsers/servers not because it was standardized, but because the major players simply started adding it. The same is happening with QUIC: the fact that it's being standardized as HTTP/3 is a reflection that it's already being used, rather than some milestone that now that it's standardized that people can start using it.  
  
QUIC is really more of a new version of TCP (TCP/2???) than a new version of HTTP (HTTP/3). It doesn't really change what HTTP/2 does so much as change how the transport works. Therefore, my comments below are focused on transport issues rather than HTTP issues.  
  
The major headline feature is faster connection setup and **latency**. TCP requires a number of packets being sent back-and-forth before the connection is established. SSL again requires a number of packets sent back-and-forth before encryption is established. If there is a lot of network delay, such as when people use satellite Internet with half-second ping times, it can take quite a long time for a connection to be established. By reducing round-trips, connections get setup faster, so that when you click on a link, the linked resource pops up immediately  
  
The next headline feature is **bandwidth**. There is always a bandwidth limitation between source and destination of a network connection, which is almost always due to congestion. Both sides need to discover this speed so that they can send packets at just the right rate. Sending packets too fast, so that they'll get dropped, causes even more congestion for others without improving transfer rate. Sending packets too slowly means unoptimal use of the network.  
  
How HTTP traditionally does this is bad. Using a single TCP connection didn't work for HTTP because interactions with websites require multiple things to be transferred simultaneously, so browsers opened multiple connections to the web server ([typically 6](https://twitter.com/tunetheweb/status/1064422216262213633)). However, this breaks the bandwidth estimation, because each of your TCP connections is trying to do it independently as if the other connections don't exist. SPDY addressed this by its **multiplexing** feature that combined multiple interactions between browser/server with a single bandwidth calculation.  
  
QUIC extends this multiplexing, making it even easier to handle multiple interactions between the browser/server, without any one interaction blocking another, but with a common bandwidth estimation. This will make interactions smoother from a user's perspective, while at the same time reduce congestion that routers experience.  
  
Now let's talk **user-mode stacks**. The problem with TCP, especially on the server, is that TCP connections are handled by the operating system _kernel_, while the service itself runs in _usermode_. Moving things across the kernel/usermode boundary causes performance issues. Tracking a large number of TCP connections causes scalability issues. Some people have tried putting the services into the kernel, to avoid the transitions, which is a bad because it destabilizes the operating system. My own solution, with the BlackICE IPS and masscan, was to use a _usermode driver_ for the hardware, getting packets from the network chip directly to the usermode process, bypassing the kernel (see PoC||GTFO #15), using my own custom TCP stack. This has become popular in recent years with the _DPDK_ kit.  
  
But moving from TCP to UDP can get you much the same performance without usermode drivers. Instead of calling the well-known _recv()_ function to receive a single packet at a time, you can call _recvmmsg()_ to receive a bunch of UDP packets at once. It's still a kernel/usermode transition, but one amortized across a hundred packets received at once, rather a transition per packet.  
  
In my own tests, you are limited to about 500,000 UDP packets/second using the typical _recv()_ function, but with _recvmmsg()_ and some other optimizations (multicore using RSS), you can get to 5,000,000 UDP packets/second on a low-end quad-core server. Since this scales well per core, moving to the beefy servers with 64 cores should improve things even further.  
  
BTW, "RSS" is a feature of network hardware that splits incoming packets into multiple receive queues. The biggest problem with multi-core scalability is whenever two CPU cores need to read/modify the same thing at the same time, so sharing the same UDP queue of packets becomes the biggest bottleneck. Therefore, first Intel and then other Ethernet vendors added RSS giving each core it's own non-shared packet queue. Linux and then other operating systems upgraded UDP to support multiple file descriptors for a single socket (SO_REUSEPORT) to handle the multiple queues. Now QUIC uses those advances allowing each core to manage it's own stream of UDP packets without the scalability problems of sharing things with other CPU cores. I mention this because I personally had discussions with Intel hardware engineers about having multiple packet queues back in 2000. It's a common problem and an obvious solution, and it's been fun watching it progress over the last two decades until it appears on the top end as HTTP/3. Without RSS in the network hardware, it's unlikely QUIC would become a standard.  
  
Another cool solution in QUIC is **mobile** support. As you move around with your notebook computer to different WiFI networks, or move around with your mobile phone, your IP address can change. The operating system and protocols don't gracefully close the old connections and open new ones. With QUIC, however, the identifier for a connection is not the traditional concept of a "socket" (the source/destination port/address protocol combination), but a 64-bit identifier assigned to the connection.  
  
This means that as you move around, you can continue with a constant stream uninterrupted from YouTube even as your IP address changes, or continue with a video phone call without it being dropped. Internet engineers have been struggling with "mobile IP" for decades, trying to come up with a workable solution. They've focused on the end-to-end principle of somehow keeping a constant IP address as you moved around, which isn't a practical solution. It's fun to see QUIC/HTTP/3 finally solve this, with a working solution in the real world.  
  
How can use use this new transport? For decades, the standard for network programing has been the **transport layer API** known as "sockets". That where you call functions like _recv()_ to receive packets in your code. With QUIC/HTTP/3, we no longer have an operating-system transport-layer API. Instead, it's a higher layer feature that you use in something like the _go_ programming language, or using Lua in the OpenResty nginx web server.  
  
I mention this because one of the things that's missing from your education about the OSI Model is that it originally envisioned everyone writing to application layer (7) APIs instead of transport layer (4) APIs. There was supposed to be things like _application service elements_ that would handling things like file transfer and messaging in a standard way for different applications. I think people are increasingly moving to that model, especially driven by Google with _go_, _QUIC_, _protobufs_, and so on.  
  
I mention this because of the contrast between Google and Microsoft. Microsoft owns a popular operating system, so it's innovations are driven by what it can do within that operating system. Google's innovations are driven by what it can put on top of the operating system. Then there is Facebook and Amazon themselves which must innovate on top of (or outside of) the stack that Google provides them. The top 5 corporations in the world are, in order, Apple-Google-Microsoft-Amazon-Facebook, so where each one drives innovation is important.  
  
**Conclusion**  
  
When TCP was created in the 1970s, it was sublime. It handled things, like congestion, vastly better than competing protocols. For all that people claim IPv4 didn't anticipate things like having more than 4-billion addresses, it anticipated the modern Internet vastly better than competing designs throughout the 70s and 80s. The upgrade from IPv4 to IPv6 largely maintains what makes IP great. The upgrade from TCP to QUIC is similarly based on what makes TCP great, but extending it to modern needs. It's actually surprising TCP has lasted this long, and this well, without an upgrade.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
